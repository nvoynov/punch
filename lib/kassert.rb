require 'stringio'
require 'pp'
 
module KAssert
  class Failure < StandardError; end
  
  module_function
  
  # @param context [Binding]
  # @param kwargs [Hash]
  def verify(context = nil, **kwargs)
    mapfu = proc{|key, payload|
      value = context ? context.local_variable_get(key) : key
      options = payload.last.is_a?(Hash) ? payload.pop : {}

      message = 
        case payload.first
        when :identifier
          identifier_assertion(value)
        when :boolean
          boolean_assertion(value)
        when :enumerable
          enumerable_assertion(value, *payload, **options)
        when Class
          kind_of_assertion(value, *payload)
        when Proc
          payload.call(value)
        end

      [key, message]
    }

    violations = kwargs
      .transform_values{ it.is_a?(Array) ? it : [it] }
      .map(&mapfu)
      .select{ it.last }
      .to_h

    return unless violations.any?
    violations
  end

  # raises Failure on constraints violation
  # @see #verify
  # 
  # @param context [Binding]
  # @param kwargs [Hash]
  def assert(context = nil, **kwargs)
    (violations = verify(context, **kwargs)) or return

    pretty = StringIO.new
      .tap{ PP.pp(violations, it) }
      .string
    
    fail Failure, "assert failed on violation(s):\n#{pretty}", caller
  end
  
  def boolean_assertion(value)
    kind_of_assertion(value, TrueClass, FalseClass)
  end
  
  # @param value [Object]
  # @param klasses [Array<Class>]
  # @return [nil, String]
  def kind_of_assertion(value, *args)
    klasses = args.select{ it.is_a?(Class) }
    # TODO: handle Proc argument
    # procs = args.select{ it.is_a?(Proc) } 
    klasses.any?{ value.is_a?(it) } ? nil : "required #{klasses}"
  end

  # @param value [Object]
  # @param klasses [Array<Class>]
  # @return [nil, String]
  def identifier_assertion(value)
    violated = kind_of_assertion(value, String, Symbol)
    return violated if violated
    return if value.is_a?(Symbol)
    !value.strip.empty? ? nil : "required non-empty [String] or [Symbol]"
  end

  # @example
  #   collection(value)
  #   collection(value, Integer)
  #   collection(value, Integer, :at_least_one)
  #   collection(value, Integer, :at_least_one, uniq: name)
  #
  # @param value [Object]
  # @param args [Array<Object>]
  # @param kwargs [Hash]
  # @return [nil, String] nil when the assertion valid,
  #   otherwise violation message
  def collection_assertion(value, *args, **kwargs)
    message = "required [Enumerable]"
    return message unless value.is_a?(Enumerable)

    klass, at_least_one = args
    return "#{message} of [#{klass}]" \
      if klass.is_a?(Class) && !value.all?{ it.is_a?(klass) }
    
    return "#{message} of at least one [#{klass}]" \
      if (at_least_one == :at_least_one) && !value.any?

    uniq_property = kwargs[:uniq]
    return unless uniq_property

    get_property =
      if klass.is_a?(Hash)
        proc{ it.fetch(uniq_property, nil)  }
      else
        proc{ it.public_send(uniq_property) }
      end

    return "#{message} of [#{klass}] with uniq property :#{uniq_property}" \
      unless value.map(&get_property).uniq.size == value.size    
  end
end
