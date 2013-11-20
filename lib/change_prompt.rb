require 'colorize'
require 'file_line'

class ChangePrompt
  LINES_OF_CONTEXT = 2
  USE_EDITOR = "E"

  attr_reader :user_input

  def self.prompt(pattern, file_line, replacements)
    present_line(file_line, pattern)
    puts("Would you like to update this line?\n\n")
    puts("#{USE_EDITOR}:  Edit in Vi")
    replacements.each_with_index do |replacement, index|
      puts "#{index}:  #{replacement.suggest(file_line.raw_contents)}"
    end
    user_input = gets
    puts("")
    ChangePrompt.new(user_input)
  end


  def initialize(user_input)
    @user_input = user_input
  end

  def chose_editor?
    user_input.downcase.match(USE_EDITOR.downcase)
  end

  def integer_input
    Integer(user_input)
  rescue => e
    nil
  end

  private

  def self.present_line(file_line, pattern)
    puts "-----------------------------------"
    puts("FILENAME: #{file_line.path}")
    puts "-----------------------------------"
    puts(file_line.present_contents(pattern, LINES_OF_CONTEXT))
    puts "-----------------------------------"
    puts "\n"
  end
end
