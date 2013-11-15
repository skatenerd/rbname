require 'file_line'

class Replacement
  def self.replace(file_line)
    new_line = yield(file_line).chomp
    replace_line!(new_line, file_line)
  end

  def self.replace_line!(new_line, file_line)
    `sed -e '#{file_line.number} s/.*/#{new_line}/' -i '' #{file_line.path}`
  end
end
