require_relative 'punch_model'

module Punch
  module Services

    class PunchService < PunchModel
      # @param model [Models::Plugin]
      def initialize(model)
        super(model, :service, conf.services)
      end
    end

  end
end
