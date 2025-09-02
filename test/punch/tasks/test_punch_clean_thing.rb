require_relative '../test_helper'

describe Punch::Tasks::PunchCleanThing do
  let(:config)  { Punch::Model::CleanDomainConfig.new('clean') }
  let(:store)   { PunchHelper::LocalStore.new }
  let(:subject) { Punch::Tasks::PunchCleanThing.new(store) }

  it '#call' do
    temp_directory do
      Punch::Tasks::WriteCleanConfig.call(config, store)
      Punch::Tasks::ReadCleanConfig.call(store)
      subject.call(%w[interactor sign_in email password])
      subject.call(%w[entity credentials email password])
      subject.call(%w[port store all get put])
      # puts ?\n, Dir['**/*']
    end
  end
end
  
