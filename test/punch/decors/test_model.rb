require_relative '../../test_helper'
require_relative '../dummy'

class TestModelDecor < Minitest::Test
  def subject = Decors::Model

  def test_dry_run
    methods = %i[const namespace indentation open_namespace close_namespace regular_params keyword_params params_yardoc params_yarpro params]

    Dummy.models
       .map{|e| subject.new(e, 'model') }
       .each{|e|methods.each{|m| e.send(m) }
    }
  end
end
