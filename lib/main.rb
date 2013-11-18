require 'theory'
require 'io_prompt'
require 'occurrences'
require 'replacement'

class Main
  def self.replace_all(root_path)

    puts "what is pattern?"
    pattern = gets.chomp
    puts ""
    puts ""

    occurrences = Occurrences.find(pattern, root_path)
    theories = []

    occurrences.each do |occurrence|
      Replacement.replace(occurrence) do |file_line|
        old = file_line.raw_contents
        new = IOPrompt.prompt(pattern, file_line, theories)
        theories << Theory.new(old, new)
        new
      end
    end
  end
end
