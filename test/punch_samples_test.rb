require_relative "test_helper"
require "erb"

describe 'Samples' do

  let(:sentry) { Factory.decorate(:sentry, SentryModel.new('dummy')) }
  let(:source) {
    ModelBuilder.('dummy', 'a', 'b:', 'c nil', 'e:integer 42')
  }

  def render(erb, model)
    @model = model
    renderer = ERB.new(erb, trim_mode: '-')
    renderer.result(binding)
  end

  it 'must render samples/*.erb' do
    samples = Dir.glob(File.join(Punch.samples, '*.erb'))
    samples.each {|sample|
      puts "\n--- #{sample}"
      erb = File.read(sample)
      model = case sample
        when /sentry/;  sentry
        when /entity/;  Factory.decorate(:entity, source)
        when /service/; Factory.decorate(:service, source)
        when /plugin/;  Factory.decorate(:plugin, source)
        end
      puts render(erb, model)
    }
  end

end




  def test_entity
    model = ModelBuilder.('dummy',
      'a', 'b:', 'c nil', 'd:integer', 'e:integer 42')
    decor = Factory.decorate(:entity, model)

    sample = File.join(Punch.samples, 'entity.rb.erb')
    erb = File.read(sample)
    puts render(erb, decor)

    sample = File.join(Punch.samples, 'test_entity.rb.erb')
    erb = File.read(sample)
    puts render(erb, decor)

    sample = File.join(Punch.samples, 'service.rb.erb')
    erb = File.read(sample)
    puts render(erb, decor)

    sample = File.join(Punch.samples, 'test_service.rb.erb')
    erb = File.read(sample)
    puts render(erb, decor)
  end
