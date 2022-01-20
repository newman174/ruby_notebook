# frozen_string_literal: true

class Formatter
  def self.snake_case(str)
    str = 'file name' if str.nil? || str.empty?
    str.downcase.gsub(' ', '_').gsub(/\W/, '')
  end

  # def self.heading_case(str)
  #   raise TypeError unless str.is_a?(String)
  #   str = str.dup
  #   str.gsub!('_', ' ')
  #   str.split.map(&:capitalize).join(' ')
  # end
end
