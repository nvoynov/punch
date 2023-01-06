require_relative "../../test_helper"

describe Hashed do
  include Hashed

  let(:dummy) { 'dummy' }

  it 'must provide #exerpt, #excerpt?, and #correct?' do
    excerpt(dummy)
    refute excerpt?(dummy)
    sample = [excerpt(dummy) ,dummy].join
    assert excerpt?(sample)
    assert correct?(sample)
    refute correct?(sample + ?\n)
  end
end
