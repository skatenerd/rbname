class FileLine
  attr_accessor :number, :path
  def initialize(number, path)
    @number = number
    @path = path
  end

  def contents
    `sed -n '#{number}p' #{path}`
  end
end
