require_relative 'test_helper'

describe Generator do

  it '#create_source' do
    foo = Generator::Syntax::KModule.new(name: 'foo')
    bar = Generator::Syntax::KModule.new(name: 'bar').add(foo)

    Generator.generate(foo)
    Generator.generate(bar)
  end
end
