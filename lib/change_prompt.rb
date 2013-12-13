require 'colorize'
require 'file_line_presenter'

class ChangePrompt
  LINES_OF_CONTEXT = 2
  USE_EDITOR = "E"
  HORIZONTAL_LINE = "-" * 100

  attr_reader :user_input

  def self.prompt(pattern, file_line, replacements)
    present_line(file_line, pattern)
    puts("How would you like to update the above line? Options below.  Hit return to do nothing\n\n")
    puts HORIZONTAL_LINE
    puts("#{USE_EDITOR}:  Edit in Vi")
    replacements.each_with_index do |replacement, index|
      puts "#{one_indexed(index)}:  #{replacement.suggest(file_line.raw_contents)}"
    end
    puts HORIZONTAL_LINE
    get_the_input(replacements)
  end

  def self.get_the_input(replacements)
    user_input = gets
    puts("")
    prompt = ChangePrompt.new(user_input, replacements)

    until(prompt.valid?)
      puts "Yo, #{prompt.instance_variable_get(:@user_input)} is not a good answer.  Try again"
      user_input = gets
      puts("")
      prompt = ChangePrompt.new(user_input, replacements)
    end
    prompt
  end


  def initialize(user_input, replacements)
    @user_input = user_input
    @replacements = replacements
  end

  def chose_editor?
    user_input.downcase.match(USE_EDITOR.downcase)
  end

  def selected_replacement
    replacements[zero_indexed(integer_input)] if integer_input
  end

  def valid?
    chose_editor? || valid_integer_input || user_input.chomp.empty?
  end

  private

  attr_reader :replacements

  def integer_input
    Integer(user_input)
  rescue => e
    nil
  end

  def zero_indexed(index)
    index - 1
  end

  def valid_integer_input
    (1..replacements.count).include?(integer_input)
  end

  def self.one_indexed(index)
    index + 1
  end

  def self.present_line(file_line, pattern)
    puts "\n" * 50
    puts HORIZONTAL_LINE
    puts("FILENAME: #{file_line.path}")
    puts HORIZONTAL_LINE
    puts(FileLinePresenter.present_contents(file_line, pattern, LINES_OF_CONTEXT))
    puts HORIZONTAL_LINE
    puts "\n"
  end
end
