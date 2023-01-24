require "fileutils"

module Sampler
  extend self
  include FileUtils

  def call(stream = DATA)
    read(stream)
  end

  def write(source, content)
    path = File.dirname(source)
    makedirs path unless Dir.exist? path
    File.write source, content
  end

  def preview(source, content)
    puts "\n>>> #{source}"
    puts content
  end

  protected

  def read(stream)
    fu = method(:parse)
    stream.read.split(SAMPLE)
      .map(&:strip)
      .reject(&:empty?)
      .map(&fu)
      .to_h
  end

  def parse(text)
    head, *tail = text.lines
    tail.shift while tail.first == ?\n
    tail.pop(1) while tail.last == ?\n
    [head.strip, tail.join.strip]
  end

  SAMPLE = '@@sample'.freeze
end
#
# require "stringio"
# require "minitest/autorun"
# class TestSampler < Minitest::Test
#   def subject
#     Sampler
#   end
#
#   def test_call
#     samples = subject.()
#     assert samples
#     assert_kind_of Hash, samples
#     assert_equal 3, samples.size
#
#     stream = StringIO.new
#     stream.puts ""
#     assert_equal Hash.new, subject.(stream.tap(&:rewind))
#
#     stream.puts ""
#     stream.puts "#{subject::SAMPLE}%{source}.rb"
#     stream.puts "bla-bla-bla"
#     stream.puts ""
#     samples = subject.(stream.tap(&:rewind))
#     assert_equal 1, samples.size
#     assert_equal '%{source}.rb', samples.keys.first
#
#     stream.puts "#{subject::SAMPLE}  test_%{source}.rb"
#     stream.puts "require_relative \"../test_helper\""
#     stream.puts "class Test<%= @model %> < Minitest::Test"
#     stream.puts "end"
#     samples = subject.(stream.tap(&:rewind))
#     assert_equal 2, samples.size
#     assert_equal '%{source}.rb', samples.keys.first
#     assert_equal 'test_%{source}.rb', samples.keys.last
#
#   end
# end
#
# __END__
#
# @@sample actions/%{source}.rb
# # frozen_string_literal: true
# class <%= @model.const %>
# end
#
# @@sample %{source}.rb
# require_relative "actions/<%= @model.name %>"
#
# @@sample test/actions/test_%{source}.rb
# require_relative "../../test_helper"
#
# describe <%= @model.const %> do
#   let(:action) { <%= @model.const %> }
#   it {
#     skip "not implemented yet"
#     action.()
#   }
# end
