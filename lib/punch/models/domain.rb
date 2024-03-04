# frozen_string_literal: true
module Punch
  module Models

    class Domain < Data.define(:name, :actors, :sentries, :entities, :services, :plugins, :desc)
      def initialize(name:, actors: [], sentries: [], entities: [],  services: [], plugins: [], desc: '')
        super
      end
    end

  end
end
