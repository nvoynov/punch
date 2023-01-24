require "optparse"
require_relative "sampler"

parser = OptionParser.new {|cmd|
  cmd.banner = "Usage: ruby fagen.rb [OPTIONS]"
  cmd.on('-b DIRECTORY', '--basedir DIRECTORY',
    'Setup base punching directory', String)
  cmd.on('-d', '--dry-run true|false', 'Print result instead of punch', TrueClass)
}

puts "Punch Face Genearator v0.1"
puts "#{parser}"
options = {}
parser.parse(ARGV, into: options)

nulldir = File.expand_path(__FILE__).sub(/\.rb$/, '')
basedir = options.fetch(:basedir, nulldir)
dryrun  = options.fetch('dry-run'.to_sym, true)

generate = proc{|file, body|
   meth = dryrun == true ? Sampler.method(:preview) : Sampler.method(:write)
   meth.(file, body)
}

samples = Sampler.()
samples.each{|source, sample|
  location = File.join(basedir, source)
  generate.(location, sample)
}

__END__

@@sample basics/proxy.rb
# frozen_string_literal: true

class Proxy
  class << self
    def origin(arg)
      fail ArgumentError, "must respond to :call" unless arg.respond_to? :call
      @subject = arg
    end

    def subject
      @subject
    end

    def call(*args, **kwargs, &block)
      new(*args, **kwargs, &block).call
    end
  end

  def initialize(*args, **kwargs, &block)
    @args, @kwargs, @block = args, kwargs, block
  end

  def call
    fail FAULTY_ORIGIN unless subject
    args = arguments
    subject.(*args[0], **args[1], &args[2])
  end

  protected

  def subject
    self.class.subject
  end

  def arguments
    [@args, @kwargs, @block]
  end

  FAULTY_ORIGIN = <<~EOF
    :origin must be provided
    class #{self.class.name}
      origin <callableconst>
      ^^^^^^^^^^^^^^^^^^^^^^
    end
  EOF
end

@@sample basics/action.rb
# frozen_string_literal: true
require_relative "proxy"

class Action < Proxy
  class << self
    def handle(arg)
      # fail "faulty handle" unless arg.is_a?(Hash)
      @action = arg
    end

    def action
      @action
    end
  end

  def initialize(request)
    @request = request
  end
end

@@sample basics/presenter.rb
# frozen_string_literal: true

class Presenter
  class << self
    def present(subject)
      fail "subject must be Class" unless subject.is_a?(Class)
      @presented = subject
    end

    def properties(*args)
      @properties ||= []
      @properties.concat args
    end

    def collection(*args)
      @collections ||= []
      @collections << args
    end

    def presented
      @presented || Object
    end

    def _properties
      @properties&.uniq || []
    end

    def collections
      @collections ||= []
    end

    def call(object)
      new(object).()
    end
  end

  def initialize(object)
    fail "object must be #{presented}" unless object.is_a?(presented)
    @object = object
  end

  private_class_method :new

  def call
    {}.tap{|hsh|
      hsh.store('type', "#{@object.class}".split('::').last.downcase)
      hsh.store('id', @object.id) if @object.respond_to?(:id)

      fu = presentfu(@object)
      props = properties.map(&fu).to_h
      hsh.store('properties', props) if props.any?

      colls = collections.inject({}){|acc, co|
        acc.merge presentco(co)
      }
      hsh.store('collections', colls) if colls.any?
    }
  end

  protected

  # basic property presenter
  def present(obj, prop)
    [prop.to_s, _present(obj.send(prop))]
  end

  def _present(arg)
    case arg
    when BigDecimal
      arg.round(2, :up).to_s('F')
    else
      arg.to_s
    end
  end

  # basic presenting fu
  def presentfu(obj)
    method(:present).curry.(obj)
  end

  # present collection
  def presentco(coll)
    head, *tail = coll  # => collection, *properties
    tail.uniq!
    subj = @object.send(head)
    {
      head.to_s => subj.inject([]){|acc, co|
        fu = presentfu(co)
        acc << tail.map(&fu).to_h
      }
    }
  end

  def presented
    self.class.presented
  end

  def properties
    self.class._properties
  end

  def collections
    self.class.collections
  end
end

@@sample basics.rb
require_relative "basics/proxy"
require_relative "basics/action"
require_relative "basics/presenter"

@@sample config.rb

require_relative "basics"
# when you need replace some holders from domain
# require_relative "./lib/domain/config"
# StoreHolder.plugin Ranch::InMemoryStore

# when yu need logger
# require "logger"
# Logger.extend(Plugin)
# LoggerHolder = Logger.plugin

class Presenters
  extend Plugin

  def initialize
    @store = {}
  end

  def put(arg)
    fail ArgumentError, "must be Presenter" unless arg < Presenter
    @store[arg.presented] = arg
  end
  alias :add :put
  alias :<< :put

  def get(arg)
    klass = arg.is_a?(Class) ? arg : arg.class
    fu = proc{|key, _| arg.is_a?(key) }
    @store.find(&fu)&.last || Presenter
  end
  alias :call :get
end

class Actions
  extend Plugin

  def initialize
    @store = {}
  end

  def put(arg)
    fail ArgumentError, "must be Action" unless arg < Action
    @store[arg.action] = arg
  end
  alias :add :put
  alias :<< :put

  def get(key)
    fu = proc{|k,v| k == key }
    @store.find(&fu)&.last
  end
  alias :call :get
end

ActionsHolder = Actions.plugin
PresentersHolder = Presenters.plugin

@@sample actions.rb
require_relative "basics"
require_relative "config"

class SomeAction < Action
  handle :get, '/hello'
  origin SomeDomainService

  def arguments
    # override it
  end
end

ActionsHolder.object << SomeAction

@@sample presenters.rb
require_relative "basics"
require_relative "config"

class HashPresenter < Presenter
  present Hash
  def call
    @object.transform_keys(&:to_s)
  end
end

class FailurePresenter < Presenter
  present StandardError
  properties :class, :message
end

presenters = PresentersHolder.object
presenters << FailurePresenter
presenters << HashPresenter

@@sample face.rb
require_relative "config"
require_relative "actions"
require_relative "presenters"

require "forwardable"

class Face
  extend Forwardable
  def_delegator :LoggerHolder, :object, :logger
  def_delegator :ActionsHolder, :object, :actions
  def_delegator :PresentersHolder, :object, :presenters

  def handle(request)
    action = Actions.(request)
    unless action
      # handle unknown action
    end
    present(action.(request))
  rescue => e
    logger.error e
    present(e)
  end

  def present(obj)
    # JSON.dump(presenters.(obj).(obj))
    presenters.(obj).(obj)
  end
end
