# frozen_string_literal: true

# @todo why I can't do that getting "undefined method 'include' in template?"
# module Punch

  # Erb helper module provides suitable methods erb templates
  # All the methods below are required @model that should be
  # passed to ERB template
  # module ErbHelper

    # @return [String] that starts namespace
    # @example
    #   module One
    #     module Two
    def open_namespace
      source = @model.namespace.split('::')
      @spacer = '  ' * source.size
      [].tap{|ary|
        source.each{|item| ary << '  ' * ary.size + "module #{item}\n"}
      }.join
    end

    # @return [String] that closes namespace
    # @example
    #     end
    #   end
    def close_namespace
      source = @model.namespace.split('::')
      source
        .inject([]){|memo, item| memo << "#{'  ' * memo.size}end\n"}
        .reverse
        .join
    end

    # @return [String] of attr_readers
    def define_properties
      prop = <<~EOF
        #{@spacer}  # @return [%<type>s]
        #{@spacer}  attr_reader :%<name>s
      EOF
      @model.params.map{|para|
        prop % {name: para.name, type: para.type&.capitalize || 'Object'}
      }.join
    end

    # @return [String] of assigning arguments to object variables, sentried parameter first
    def assing_properties
      paratt = "#{@spacer}    @%<name>s = %<para>s\n"
      source = @model.params
      [].then{|para| para.concat(source.select{|para| para.typed?})}
        .then{|para| para.concat(source.select{|para| !para.typed?})}
        .map {|item|
          para = item.typed? ? "Mustbe#{item.type.capitalize}.(#{item.name})" : item.name
          paratt % {name: item.name, para: para}
        }.join
    end

    def test_helper
      level = @model.namespace.split('::').size
      "require_relative '#{'../' * level}test_helper'"
    end

    # @todo for deep nesting classes where basic class is 'services/service'
    #       and punched service is services/users/create_users
    def require_class_to_inherit
      fail "UNDER CONSTRUCTION"
    end

    # @return [String] of params for constructor, keyword arguments last
    # @example
    #    # @model = 'entity user name email:email'
    #    parameters_string # => 'name, email:'
    def parameters_string
      args = @model.params.reject(&:kwarg?)
      kwar = @model.params.select(&:kwarg?)
      [].tap do |ary|
        ary.concat(args.map(&:name))
        ary.concat(kwar.map{|kw| "#{kw.name}:"})
      end.join(', ')
    end

    # @return [String] of argumetns, keyword argumnents last
    def arguments_string
      args = @model.params.reject(&:kwarg?).map{|ar| "@#{ar.name}"}
      kwar = @model.params.select(&:kwarg?).map{|kw|
        "#{kw.name}: @#{kw.name}"}
      args.concat(kwar).join(', ')
    end
  # end

# end
