require_relative '../../test_helper'
include Punch::Values

describe Model do

  it 'must parse name and namespace' do
    dummy = Model.new(*%w(user))
    assert_equal 'user', dummy.name
    assert_empty dummy.space

    dummy = Model.new(*%w(users/user))
    assert_equal 'user', dummy.name
    assert_equal 'users', dummy.space
  end

  it 'must #define_params_str' do
    dummy = Model.new(*['domain/model'])
    assert_empty dummy.define_params_str

    dummy = Model.new(*['domain/model', 'a', 'b = nil', 'c:', 'd:string', 'e:string "42"'])
    assert_equal 'a, b = nil, c:, d:, e: "42"', dummy.define_params_str

    dummy = Model.new(*['domain/model', 'c:', 'b = nil', 'd:string', 'a', 'e:string "42"'])
    assert_equal 'a, b = nil, c:, d:, e: "42"', dummy.define_params_str
  end

  it 'must #assing_params_str' do
    dummy = Model.new(*['domain/model'])
    assert_equal ?\n, dummy.assign_params_str

    dummy = Model.new(*['domain/model', 'a', 'b = nil', 'c:', 'd:string', 'e:string "42"'])
    sample = <<~EOF
      @a = a
      @b = b
      @c = c
      @d = MustbeString.(d)
      @e = MustbeString.(e)
    EOF
    assert_equal sample, dummy.assign_params_str
  end

  it 'must #method_params_str' do
    dummy = Model.new(*['domain/model'])
    assert_empty dummy.method_params_str

    dummy = Model.new(*['domain/model', 'a', 'b = nil', 'c:', 'd:string', 'e:string "42"'])
    assert_equal '@a, @b, c: @c, d: @d, e: @e', dummy.method_params_str
  end

  it 'must #define_properties_str' do
    dummy = Model.new(*['domain/model'])
    assert_equal ?\n, dummy.define_properties_str

    dummy = Model.new(*['domain/model', 'a', 'b = nil', 'c:', 'd:string', 'e:string "42"'])
    sample = <<~EOF
      # @param a [Object]
      attr_reader :a

      # @param b [Object]
      attr_reader :b

      # @param c [Object]
      attr_reader :c

      # @param d [String]
      attr_reader :d

      # @param e [String]
      attr_reader :e
      
    EOF
    assert_equal sample, dummy.define_properties_str
  end

end
