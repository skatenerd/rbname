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
    pattern, root_path, file_exclusions = prompt_search_details

    file_lines = FileLine.find_all(pattern, root_path, *file_exclusions.split(","))
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
          take_user_suggestion!(user_input.selected_replacement, file_line)
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
    puts "Any files to exclude? (separate by ',' please, no whitespace)"
    file_exclusions = gets.chomp
    puts ""
    [pattern, root_path, file_exclusions]
  end

  def get_root_path
    search_root_input = gets.chomp

    until valid_path?(search_root_input)
      puts "That path doesn't exist, buddy.  Hit me again"
      search_root_input = gets.chomp
    end

    if  search_root_input.empty?
      puts "Defaulting to current directory.  Hit return to begin"
      gets
      return "."
    end
    return search_root_input
  end

  def valid_path?(path_input)
    File.exist?(path_input) || path_input.empty?
  end

  def record_manual_replacement!(replacement_collection, old_contents, file_line)
    new_contents = file_line.raw_contents
    replacement_collection << Replacement.generate(old_contents, new_contents) unless old_contents == new_contents
    replacement_collection
  end

  def take_user_suggestion!(replacement, file_line)
    new_contents = replacement.suggest(file_line.raw_contents)
    file_line.update_filesystem!(new_contents)
  end

end
