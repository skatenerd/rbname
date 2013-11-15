require 'colorize'
require 'file_line'

class IOPrompt
  LINES_OF_CONTEXT = 2
  def self.prompt(pattern, file_line)
    puts(file_line.present_contents(pattern, LINES_OF_CONTEXT))
    puts "\n"
    puts("What should this line become?\n\n")
    gets
  end
end
