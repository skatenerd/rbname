require 'colorize'
require 'file_line'

class IOPrompt
  LINES_OF_CONTEXT = 2
  def self.prompt(pattern, file_line)
    puts "-----------------------------------"
    puts("FILENAME: #{file_line.path}")
    puts "-----------------------------------"
    puts(file_line.present_contents(pattern, LINES_OF_CONTEXT))
    puts "-----------------------------------"
    puts "\n"
    puts("What should this line become?\n\n")
    new_text = gets
    puts("")
    new_text
  end
end
