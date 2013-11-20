require 'colorize'

class FileLine
  TAB = "  "
  attr_accessor :number, :path
  def initialize(number, path)
    @number = number
    @path = path
  end

  def self.find_all(pattern, directory_path)
    grep_results = `grep -Irn "#{pattern}" #{directory_path} --exclude-dir="*.*.*"`
    grep_results.split("\n").map do |grep_hit|
      file_path, line_number, _ = grep_hit.split(":")
      line_number = line_number.to_i
      FileLine.new(line_number, file_path)
    end
  end

  def update_filesystem!(new_contents)
    `sed -e '#{number} s/.*/#{new_contents}/' -i '' #{path}`
  end

  def present_contents(pattern, context = 0)
    current_highlighted_line = add_line_number(with_highlighting(pattern))
    lower_limit = [number - context, 1].max
    upper_limit = [number + context, file_length].min
    above_line_indices = (lower_limit...number)
    below_line_indices = (number + 1..upper_limit)

    above_lines = numbered_lines_at(above_line_indices)
    below_lines = numbered_lines_at(below_line_indices)
    (above_lines + [current_highlighted_line] + below_lines).join("\n")
  end

  def raw_contents
    `sed -n '#{number}p' #{path}`.chomp
  end

  def with_line_number
    add_line_number(raw_contents)
  end

  private

  def numbered_lines_at(indices)
    indices.map do |line_number|
      FileLine.new(line_number, path).with_line_number
    end
  end

  def with_highlighting(pattern)
    raw_contents.gsub!(/#{pattern}/) do |match|
      match.red
    end
  end


  def add_line_number(contents)
    "#{number}:#{TAB}#{contents}"
  end

  def file_length
    file_length = `wc -l #{path}`.strip.split(" ")[0].to_i
  end
end
