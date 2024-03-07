# frozen_string_literal: true
require "erb"
require_relative "service"
require_relative "../plugins/hashed"
require_relative "../config"

module Punch
  module Services

    class BuildReport < Service
      include Punch::Hashed
      def call
        select.then(&method(:render))
      end

      protected

      Source = Data.define(:location, :filename, :created_at, :punched, :changed)

      PATTERN = '**/*.rb'

      def select
        fu = proc{|loc, arg|
          punched, changed = File.read(arg)
            .then{|text| [excerpt?(text), !correct?(text)] }
          Source.new(loc, arg, File.birthtime(arg), punched, changed)
        }

        [ conf.lib, conf.test ].map{|dir| File.join(dir, PATTERN)}
         .inject([]){|memo, dir|
           cu = fu.curry[dir]
           memo + Dir.glob(dir).map(&cu)
         }
      end

      def render(sources)
        sample = File.read(File.join(Punch.assets, 'report.md.erb'))
        ERB.new(sample, trim_mode: '%<>').result(binding)
      end
    end

  end
end
