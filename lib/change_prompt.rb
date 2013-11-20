require 'colorize'
require 'file_line'

class ChangePrompt
  LINES_OF_CONTEXT = 2
  def self.prompt(pattern, file_line, replacements)
    present_line(file_line, pattern)
    puts("Would you like to update this line?\n\n")
    puts("E:  Edit in Vi")
    replacements.each_with_index do |replacement, index|
      puts "#{index}:  #{replacement.suggest(file_line.raw_contents)}"
    end
    new_text = gets
    puts("")
    new_text
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
