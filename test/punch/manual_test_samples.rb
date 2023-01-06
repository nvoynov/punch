require_relative "../test_helper"
require "erb"

class TestSamples < Minitest::Test

  def render(erb, model)
    @model = model
    renderer = ERB.new(erb, trim_mode: '-')
    renderer.result(binding)
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
end
