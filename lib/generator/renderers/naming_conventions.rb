# require_relative '../../basic'

# module Generator
#   module Renderers

#     # no one need it except source name ..
#     module NamingConventions
#       module_function

#       EXT = '.rb'

#       def source_name(str)
#         module_name(str).snakecase
#       end

#       def module_source_name(mod)
#         mod.parents.reverse.push(mod)
#            .map{ filename(it.name) }
#            .then{ File.join(*it)   } + EXT 
#       end
      
#       def module_name(str)
#         str.sanitize.underscore.downcase.camelcase
#       end

#       def constant_name(str)
#         str.sanitize.underscore.upcase
#       end

#       def variable_name(str)
#         str.sanitize.underscore.downcase
#       end
      
#       def function_name(str)
#         str.sanitize.underscore.downcase
#       end
#     end

    
#   end
# end

# # include Generator::Renderers::NamingConventions
# # puts module_name('foo bar_baZ')
# # puts constant_name('foo bar_baZ')
# # puts variable_name('foo bar_baZ')
# # puts function_name('foo bar_baZ')
# # puts source_name('foo bar_baZ')
