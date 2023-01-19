# frozen_string_literal: true

require_relative "service"
require_relative "../plugins/hashed"

module Punch
  module Services

    class ReportStatus < Service
      include Punch::Hashed

      def call
        look_through_folders(config.lib, config.test)
      end

      protected

      def look_through_folders(*dirs)
        fun = proc{|arg|
          param = [arg, File.birthtime(arg)]
          param.concat(look_throug_source(arg))
          Model.new(*param)
        }
        store = dirs.map{|dir|
          [dir, Dir.glob("#{dir}/**/*.rb").map(&fun)]
        }.to_h
        report_status(store)
      end

      def look_throug_source(name)
        sloc, blnk, cmnt = 0, 0, 0
        calc = proc{|string|
          source = String.new(string).lines
            .map{|l| l.strip + ?\n}.join
          sloc = source.lines.size
          blnk = source.lines.select{|l| l == ?\n }.size
          cmnt = source.lines.select{|l| l =~ /^#/}.size
        }
        body = File.read(name)
        calc.(body)
        punched = !!excerpt?(body)
        changed = !correct?(body)
        [sloc, blnk, cmnt, punched, changed]
      end

      # @param payload [Hash] dir => Array<Model>
      def report_status(payload)
        calc = proc{|ary|
          total = ary.size
          sloc = ary.map{|m| m.sloc}.sum
          blnk = ary.map{|m| m.blnk}.sum
          cmnt = ary.map{|m| m.cmnt}.sum
          pnch = ary.select{|m| m.punched == true}.size
          wild_orig = ary
            .select{|m| m.punched == true && m.changed == false}
            .map(&:orig)
          wild = wild_orig.size
          [total, sloc, blnk, cmnt, pnch, wild, wild_orig]
        }

        store = payload.map{|dir, store| [dir, calc.(store)]}.to_h
        total = store.values.map{|i| i[0]}.sum
        sloc  = store.values.map{|i| i[1]}.sum
        blnk  = store.values.map{|i| i[2]}.sum
        cmnt  = store.values.map{|i| i[3]}.sum
        pnch  = store.values.map{|i| i[4]}.sum
        wild  = store.values.map{|i| i[5]}.sum

        dirs = payload.keys
        summary = <<~EOF
          Looking through #{dirs.map{"'#{_1}'"}.join(', ')} directories..

          - #{total} sources, #{pnch} "punched" (#{wild} remain "punched")
          - #{sloc} SLOC, #{blnk} blank and #{cmnt} comment lines
        EOF

        folders = store.map{|dir, numbers|
          total, sloc, blnk, cmnt, pnch, wild, wild_orig = numbers

          remain = wild_orig.map{"- #{_1}"}.join(?\n)
          remain = "\nremain \"punched\":\n#{remain}\n" unless remain.empty?
          <<~EOF
            '#{dir}' summary:
            - #{total} sources, #{pnch} "punched" (#{wild} remain "punched")
            - #{sloc} SLOC, with #{blnk} blank lines and #{cmnt} comments\n#{remain}
          EOF
        }.join

        summary + ?\n + folders
      end

      class Model
        attr_reader :orig
        attr_reader :birth
        attr_reader :sloc
        attr_reader :blnk
        attr_reader :cmnt
        attr_reader :punched
        attr_reader :changed

        def initialize(*args)
          @orig = args.shift
          @birth = args.shift
          @sloc = args.shift
          @blnk = args.shift
          @cmnt = args.shift
          @punched = args.shift
          @changed = args.shift
        end
      end
    end

  end
end
