require 'io_prompt'
require 'occurrences'
require 'replacement'

class Main
  def self.replace_all(root_path)

    puts "what is pattern?"
    pattern = gets.chomp

    occurrences = Occurrences.find(pattern, root_path)

    occurrences.each do |occurrence|
      Replacement.replace(occurrence) do |file_line|
        IOPrompt.prompt(pattern, file_line)
      end
    end
  end
end
