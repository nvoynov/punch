
# open String and provide some helpful methods
class String 
  # @return [String] with remove non-word characters
  #   and adding ?n prfix when it starts from number
  def sanitize
    gsub(/[^\w\s]/, '')
      .gsub(/\s{1,}/, ' ')
      .then{ it.start_with?(/\d/) ? "n#{it}" : it }
  end

  def underscore 
    gsub(/\s{1,}/, ?_)
  end

  # @return [String] "snake_case" from "CamelCase"
  def snakecase
    gsub(/([A-Z]+)([A-Z][a-z])/, '\1_\2')
      .gsub(/([a-z\d])([A-Z])/, '\1_\2')
      .downcase
  end

  # @return [String] "CamelCase" fron "snake_case"
  def camelcase
    split(/_/).map(&:capitalize).join
  end
end
