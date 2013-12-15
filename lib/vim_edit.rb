class VimEdit
  def execute!(file_line, pattern)
    system "vim +#{file_line.line_number} #{file_line.path} -c '#{"/"+pattern}' -c 'normal n' -c 'normal N' -c 'normal zz'"
  end
end
