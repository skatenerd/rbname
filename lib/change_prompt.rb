require 'colorize'
require 'file_line_presenter'

class ChangePrompt
  LINES_OF_CONTEXT = 2
  USE_EDITOR = "E"

  attr_reader :user_input

  def self.prompt(pattern, file_line, replacements)
    present_line(file_line, pattern)
    puts("How would you like to update the above line? Options below.  Hit return to do nothing\n\n")
    puts "------------------------------"
    puts("#{USE_EDITOR}:  Edit in Vi")
    replacements.each_with_index do |replacement, index|
      puts "#{index}:  #{replacement.suggest(file_line.raw_contents)}"
    end
    puts "------------------------------"
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
    puts(FileLinePresenter.present_contents(file_line, pattern, LINES_OF_CONTEXT))
    puts "-----------------------------------"
    puts "\n"
  end
end
