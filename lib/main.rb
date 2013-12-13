require 'replacement'
require 'change_prompt'
require 'replacement_collection'
require 'vim_edit'

class Main

  attr_accessor :manual_edit

  def initialize
    @manual_edit = VimEdit.new
  end

  def replace_all
    pattern, root_path = prompt_search_details

    file_lines = FileLine.find_all(pattern, root_path)
    replacement_collection = ReplacementCollection.new

    file_lines.each do |file_line|
      if file_line.raw_contents.match(pattern)
        old_contents = file_line.raw_contents
        applicable_replacements = replacement_collection.applicable_replacements(old_contents)
        user_input = ChangePrompt.prompt(pattern, file_line, applicable_replacements)
        if user_input.chose_editor?
          manual_edit.execute!(file_line, pattern)
          record_manual_replacement!(replacement_collection, old_contents, file_line)
        elsif user_input.selected_replacement
          take_user_suggestion!(user_input.selected_replacement, applicable_replacements, file_line)
        end
      end
    end
  end

  private

  def prompt_search_details
    puts "We will be replacing some text today."
    puts "What is a pattern describing the text you want to replace?"
    pattern = gets.chomp
    puts ""
    puts "What is root of your search? ('.' would probably work fine)"
    root_path = get_root_path
    puts ""
    [pattern, root_path]
  end

  def get_root_path
    chomped = gets.chomp
    if chomped.empty?
      puts "Defaulting to current directory.  Hit return to begin"
      gets
      return "."
    end
    return chomped
  end

  def record_manual_replacement!(replacement_collection, old_contents, file_line)
    new_contents = file_line.raw_contents
    replacement_collection << Replacement.generate(old_contents, new_contents) unless old_contents == new_contents
    replacement_collection
  end

  def take_user_suggestion!(replacement, applicable_replacements, file_line)
    new_contents = replacement.suggest(file_line.raw_contents)
    file_line.update_filesystem!(new_contents)
  end

end
