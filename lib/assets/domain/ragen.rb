# Rack actions generator, creates rack actions based on domain
require_relative "domain"
require_relative "sampler"
require "erb"
require "punch"
require "optparse"
include Punch

domain = build_domain
models = domain.services.map{|m| Factory.decorate(:service, m)}

parser = OptionParser.new {|cmd|
  cmd.banner = "Usage: ruby ragen.rb [OPTIONS]"
  cmd.on('-b DIRECTORY', '--basedir DIRECTORY',
    'Setup base punching directory', String)
  cmd.on('-d', '--dry-run true|false', 'Print result instead of punch', TrueClass)
}

puts "Punch Rake Actions Genearator v0.1"
puts "#{parser}"
options = {}
parser.parse(ARGV, into: options)

nulldir = File.expand_path(__FILE__).sub(/\.rb$/, '')
basedir = options.fetch(:basedir, nulldir)
dryrun  = options.fetch('dry-run'.to_sym, true)

generate = proc{|file, body|
   meth = dryrun == true ? Sampler.method(:preview) : Sampler.method(:write)
   meth.(file, body)
}

samples = Sampler.()
samples.transform_values!{|erb| ERB.new(erb, trim_mode: "-") }

source, renderer = samples.shift #
location = File.join(basedir, source)
@model = models
generate.(location, renderer.result)

models.each{|model|
  samples.each{|source, renderer|
    location = File.join(basedir, source % {source: model.name})
    @model = model
    generate.(location, renderer.result)
  }
}

__END__

@@sample actions.rb
<% @model.each do |model| -%>
require_relative "actions/<%= model.name %>"
<% end -%>

@@sample actions/%{source}.rb

require_relative "../config"

class <%= @model.const %>Action < Action
<% query = @model.name.match?(/^query/) -%>
<% proxy = @model.name.gsub('_', '-') -%>
<% if query -%>
  include LinksHelper
  action :get, "<%= proxy %>"
<% else -%>
  action :post, "<%= proxy %>"
<% end -%>
  origin <%= @model.const %>

  def arguments
<% if query -%>
    @page_number = params.fetch('page_number', '0').to_i
    @page_size = params.fetch('page_size', '25').to_i
    where = params.fetch('where', [])
    order = params.fetch('order', {})
    kwargs = {
      where: where,
      order: order,
      page_number: @page_number,
      page_size: @page_size
    }
    [[], kwargs, nil]
<% else -%>
    required = %w|<%= @model.params.reject(&:default?).map{|par| "#{par.name}"}.join(' ') %>|
    missed!(required)
    kwargs = {}
<% @model.params.each do |param| -%>
    <%= param.name %> = params.fetch('<%= param.name %>')
<% if param.sentry? && (!%w|string uuid|.include?(param.sentry.to_s.downcase) ) -%>
    # <%= param.name %> = coerce('<%= param.sentry %>', <%= param.name %>)
<% end -%>
    kwargs.store(:<%= param.name %>, <%= param.name %>)
<% end -%>
    kwargs.compact!
    [[], kwargs, nil]
<% end -%>
  end
<% if query -%>

  def present(result)
    data, more = result
    [data, links(more)]
  end
<% end -%>
end

ActionsHolder.object << <%= @model.const %>Action

@@sample test/actions/test_%{source}.rb

require_relative "../../test_helper"

describe <%= @model.const %>Action do
  it {
    # mock response
    # pass arguments
    # see result
  }
end
