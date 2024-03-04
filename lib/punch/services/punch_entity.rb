require_relative 'punch_model'

module Punch
  module Services

    class PunchEntity < PunchModel
      # @param model [Models::Plugin]
      def initialize(model)
        super(model, :entity, conf.entities)
      end
    end

  end
end
