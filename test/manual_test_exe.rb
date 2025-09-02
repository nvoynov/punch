require_relative 'test_helper'

describe "exe/punch" do

  it 'help' do
    dir = Dir.pwd
    demo = "demo"
    
    temp_directory do 
      system "#{dir}/exe/punch"
      system "#{dir}/exe/punch ruby #{demo}"

      Dir.chdir(demo) do 
        system "#{dir}/exe/punch clean domain Clean"
        system "#{dir}/exe/punch clean interactor sign_in email password"
        system "#{dir}/exe/punch clean interactor log_out"
        system "#{dir}/exe/punch clean entity credentials email password"
        system "#{dir}/exe/punch clean port store all put get"
        # puts File.read('lib/clean/interactors.rb')
        # puts File.read('lib/clean/interactors/sign_in.rb')
        # puts File.read('lib/clean/entities/credentials.rb')
        # system "tree"
      end

    end
  end

end
