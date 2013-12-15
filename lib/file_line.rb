require 'colorize'

class FileLine
  attr_accessor :line_number, :path
  def initialize(line_number, path)
    @line_number = line_number
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
    `sed -e '#{line_number} s/.*/#{new_contents}/' -i '' #{path}`
  end

  def raw_contents
    `sed -n #{line_number}p #{path}`.chomp
  end

end
