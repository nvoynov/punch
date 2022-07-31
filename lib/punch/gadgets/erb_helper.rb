# frozen_string_literal: true

def open_namespace
  source = @model.namespace.split('::')
  @spacer = '  ' * source.size
  [].tap{|ary|
    source.each{|item| ary << '  ' * ary.size + "module #{item}\n"}
  }.join
end

def close_namespace
  source = @model.namespace.split('::')
  source
    .inject([]){|memo, item| memo << "#{'  ' * memo.size}end\n"}
    .reverse
    .join
end

def with_spacer(str)
  str.lines.map{|l| @spacer + l}.join
end

# @return [String] of attr_readers
def define_properties
  with_spacer(@model.define_properties_str)
end

def parameters_string
  @model.method_params_str
end

# @return [String] of assigning arguments to object variables, sentried parameter first
def assing_properties
  with_spacer(@model.assign_params_str)
end

def test_helper
  level = @model.namespace.split('::').size
  "require_relative '#{'../' * level}test_helper'"
end

def arguments_string
  @model.method_params_str
end
