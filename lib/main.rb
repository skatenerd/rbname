require 'replacement'
require 'change_prompt'

class Main
  def self.replace_all(root_path)

    puts "what is pattern?"
    pattern = gets.chomp
    puts ""
    puts ""

    file_lines = FileLine.find_all(pattern, root_path)
    theories = []

    file_lines.each do |file_line|
      if file_line.raw_contents.match(pattern)
        old_contents = file_line.raw_contents
        user_input = ChangePrompt.prompt(pattern, file_line)
        if user_input.downcase.match('y')
          system "vim +#{file_line.number} #{file_line.path} -c 'normal zz' -c '#{"/"+pattern}' -c 'normal n'"
        end
        new_contents = file_line.raw_contents
        theories << Replacement.new(old_contents, new_contents)
      end
    end
  end
end
