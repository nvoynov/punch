require_relative '../generator'

module CleanArchitecture

  # INTERACTORS = 'interactor'

  # ENTITIES = 'entities'

  # PORTS = 'ports'

  # Configuraton
  #
  # @example
  #   config = Configuration.new('lib', 'domain')
  #   lib/domain.rb
  #   lib/domain/entities.rb
  #   lib/domain/interactors.rb
  #   lib/domain/ports.rb
  #
  #   test/domain/
  #   test/domain/entities/test_user.rb
  #   test/domain/interactors/test_signin.rb
  #   test/domain/ports/shared_store_tests.rb
  #
  # 
  Configuration = Data.define(:root, :domain)

end
