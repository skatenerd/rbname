require 'replacement'
require 'change_prompt'
require 'replacement_collection'

class Main
  def self.replace_all(root_path)

    puts "what is pattern?"
    pattern = gets.chomp
    puts ""
    puts ""

    file_lines = FileLine.find_all(pattern, root_path)
    replacements_so_far = ReplacementCollection.new

    file_lines.each do |file_line|
      if file_line.raw_contents.match(pattern)
        old_contents = file_line.raw_contents
        applicable_replacements = replacements_so_far.applicable_replacements(old_contents)
        user_input = ChangePrompt.prompt(pattern, file_line, applicable_replacements)
        if user_input.downcase.match('e')
          system "vim +#{file_line.number} #{file_line.path} -c 'normal zz' -c '#{"/"+pattern}' -c 'normal n'"
        elsif as_integer(user_input)
          replacement = applicable_replacements[as_integer(user_input)]
          new_contents = replacement.suggest(file_line.raw_contents)
          replace_line!(new_contents, file_line)
        end
        new_contents = file_line.raw_contents
        replacements_so_far << Replacement.generate(old_contents, new_contents) unless old_contents == new_contents
      end
    end
  end
  def self.replace_line!(new_line, file_line)
    `sed -e '#{file_line.number} s/.*/#{new_line}/' -i '' #{file_line.path}`
  end

  def self.as_integer(s)
    return Integer(s)
  rescue => e
    return nil
  end
end
