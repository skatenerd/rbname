require 'file_line'

class FileLinePresenter

  TAB = "  "

  def self.present_contents(file_line, pattern, context = 0)
    current_highlighted_line = with_line_number(file_line, with_highlighting(file_line, pattern))
    line_number = file_line.line_number
    line_path = file_line.path
    lower_limit = [line_number - context, 1].max
    upper_limit = [line_number + context, file_length(file_line)].min
    above_line_indices = (lower_limit...line_number)
    below_line_indices = (line_number + 1..upper_limit)

    above_lines = numbered_lines_at(above_line_indices, line_path)
    below_lines = numbered_lines_at(below_line_indices, line_path)
    (above_lines + [current_highlighted_line] + below_lines).join("\n")
  end

  private

  def self.numbered_lines_at(indices, path)
    indices.map do |line_number|
      with_line_number(FileLine.new(line_number, path))
    end
  end

  def self.with_line_number(file_line, contents = file_line.raw_contents)
    "#{file_line.line_number}:#{TAB}#{contents}"
  end

  def self.with_highlighting(file_line, pattern)
    file_line.raw_contents.gsub!(/#{pattern}/) do |match|
      match.red
    end
  end

  def self.file_length(file_line)
    `wc -l #{file_line.path}`.strip.split(" ")[0].to_i
  end

end
