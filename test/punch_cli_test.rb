require_relative "test_helper"

LoggerHolder.object = Logger.new(IO::NULL)

class TestCLI < Minitest::Test

  def dummy
    'dummy'
  end

  def test_folder
    puts "\n--- CLI.folder"
    Tempbox.() {
      CLI.folder(dummy)
      print_folders
      CLI.folder(dummy)
    }
  end

  def test_source
    puts "\n--- CLI.source outside punched project"
    Tempbox.() {
      puts "> faulty klass"
      CLI.source('dummy')
      puts "> proper entity"
      CLI.source(*%w[entity user])
    }
    puts "\n--- CLI.source inside punched project"
    Sandbox.() {
      puts "> faulty klass"
      CLI.source('dummy')
      puts "> proper entity"
      CLI.source(*%w[entity user])
      puts "> proper service"
      CLI.source(*%w[service signin])
      puts "> proper service with sentry"
      CLI.source('service', 'create_order', 'customer_id:uuid')

      puts "> proper plugin"
      CLI.source(*%w[plugin storage])
      print_folders
    }
  end

  def test_preview
    puts "\n--- CLI.preview outside punched project"
    Tempbox.() {
      puts "> faulty klass"
      CLI.preview('dummy')
      puts "> proper entity"
      CLI.preview(*%w[entity user])
    }
    puts "\n--- CLI.preview inside punched project"
    Sandbox.() {
      puts "> faulty klass"
      CLI.preview('dummy')
      puts "> proper entity"
      CLI.preview(*%w[entity user])
      puts "> proper service"
      CLI.preview(*%w[service signin])
      puts "> proper service with sentry"
      CLI.preview('service', 'create_order', 'customer_id:uuid')
      print_folders
    }
  end

  def test_status
    puts "\n--- CLI.staus outside punched project"
    Tempbox.() {
      CLI.status
    }
    puts "\n--- CLI.status inside punched project"
    Sandbox.() {
      puts "> empty"
      CLI.status
      puts "> user/signup"
      CLI.source('service', 'user/signup')
      CLI.status
    }
  end

  def test_domain
    puts "\n--- CLI.domain outside punched project"
    Tempbox.() {
      CLI.domain
    }
    puts "\n--- CLI.domain inside punched project"
    Sandbox.() {
      CLI.domain
      CLI.domain
    }
  end

end
