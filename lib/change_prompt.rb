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
      puts "#{index}:  #{replacement.suggest(file_line.raw_contents)}"
    end
    puts HORIZONTAL_LINE
    get_the_input(replacements)
  end

  def self.get_the_input(replacements)
    user_input = gets
    puts("")
    prompt = ChangePrompt.new(user_input, replacements.count)

    until(prompt.valid?)
      puts "Yo, that is not a good answer.  Try again"
      user_input = gets
      puts("")
      prompt = ChangePrompt.new(user_input, replacements.count)
    end
    prompt
  end


  def initialize(user_input, replacements_count)
    @user_input = user_input
    @replacements_count = replacements_count
  end

  def chose_editor?
    user_input.downcase.match(USE_EDITOR.downcase)
  end

  def integer_input
    Integer(user_input)
  rescue => e
    nil
  end

  def valid?
    chose_editor? || valid_integer_input || user_input.chomp.empty?
  end

  private

  attr_reader :replacements_count

  def valid_integer_input
    (0...replacements_count).include?(integer_input)
  end

  def self.present_line(file_line, pattern)
    puts HORIZONTAL_LINE
    puts("FILENAME: #{file_line.path}")
    puts HORIZONTAL_LINE
    puts(FileLinePresenter.present_contents(file_line, pattern, LINES_OF_CONTEXT))
    puts HORIZONTAL_LINE
    puts "\n"
  end
end
