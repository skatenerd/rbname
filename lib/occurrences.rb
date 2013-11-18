require 'file_line'

class Occurrences
  def self.find(pattern, directory_path)
    grep_results = `grep -Irn "#{pattern}" #{directory_path} --exclude-dir="*.*.*"`
    grep_results.split("\n").map do |grep_hit|
      file_path, line_number, _ = grep_hit.split(":")
      line_number = line_number.to_i
      FileLine.new(line_number, file_path)
    end
  end
end
