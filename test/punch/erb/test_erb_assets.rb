require_relative '../../test_helper'

describe 'assets/erb' do

  let(:punch) { 'service users/create_user name email:string' }
  let(:decor) { Decor.new(punch) }

  it 'all templates ready to punch' do
    dir = File.join(Punch.assets, 'erb')
    src = Dir.chdir(dir) { Dir.glob('*.rb.erb') }
    src.map{|s| File.join(dir, s)}.each do |erb|
      # pp erb
      ErbGen.(File.read(erb), decor)
    end
  end

end
