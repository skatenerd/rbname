require 'replacement'
require 'change_prompt'
require 'replacement_collection'

class Main
  def self.replace_all

    pattern, root_path = prompt_search_details

    file_lines = FileLine.find_all(pattern, root_path)
    replacement_collection = ReplacementCollection.new

    file_lines.each do |file_line|
      if file_line.raw_contents.match(pattern)
        old_contents = file_line.raw_contents
        applicable_replacements = replacement_collection.applicable_replacements(old_contents)
        user_input = ChangePrompt.prompt(pattern, file_line, applicable_replacements)
        if user_input.chose_editor?
          edit_with_vim!(file_line, pattern)
          record_manual_replacement!(replacement_collection, old_contents, file_line)
        elsif user_input.integer_input
          take_user_suggestion!(user_input.integer_input, applicable_replacements, file_line)
        end
      end
    end
  end

  private

  def self.prompt_search_details
    puts "We will be replacing some text today."
    puts "What is a pattern describing the text you want to replace?"
    pattern = gets.chomp
    puts ""
    puts "What is root of your search? ('.' would probably work fine)"
    root_path = gets.chomp
    puts ""
    [pattern, root_path]
  end

  def self.record_manual_replacement!(replacement_collection, old_contents, file_line)
    new_contents = file_line.raw_contents
    replacement_collection << Replacement.generate(old_contents, new_contents) unless old_contents == new_contents
  end

  def self.take_user_suggestion!(integer_input, applicable_replacements, file_line)
    replacement = applicable_replacements[integer_input]
    new_contents = replacement.suggest(file_line.raw_contents)
    file_line.update_filesystem!(new_contents)
  end

  def self.edit_with_vim!(file_line, pattern)
    system "vim +#{file_line.number} #{file_line.path} -c '#{"/"+pattern}' -c 'normal n' -c 'normal N' -c 'normal zz'"
  end

end
