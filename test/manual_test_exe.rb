require_relative "test_helper"

class TestPunchExe < Minitest::Test
  def test_source
    Sandbox.() {
      system "punch preview service signup email user"
    }
  end

  def test_preview
  end
end
