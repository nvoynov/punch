require_relative 'basic'
require_relative 'generator/syntax'
require_relative 'generator/renderers'
require_relative 'generator/assembly'
 
# Punch Generator namespace
module Generator
  extend self

  # @param kmodule [Syntax::KModule]
  # @return [Array<Assembly::Source>]
  def generate(kmodule)
    renderer = Renderers::KModule.new
    make_content = proc{ renderer.render(it) }
    make_source = proc{ Assembly::Source.new(filename(it), make_content.(it)) }
    
    kmodule
      .select{ it.is_a?(Syntax::KModule) }
      .map(&make_source)
  end

  protected 
  
  def filename(kmodule)
    kmodule.parents.reverse.push(kmodule)
      .map{ it.name.sanitize.underscore.downcase }
      .then{ File.join(*it) + '.rb' }
  end
end
