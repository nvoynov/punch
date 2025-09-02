require_relative '../test_helper'

describe Punch::Tasks::PunchCleanThing do
  let(:store)   { PunchHelper::LocalStore.new }
  let(:subject) { Punch::Tasks::PunchCleanDomain.new(store) }

  it '#call' do
    temp_directory do
      subject.call('clean')
      # puts ?\n, Dir['**/*'], File.read('clean.rb'), File.read('clean/interactors.rb')
    end
  end
end
  
