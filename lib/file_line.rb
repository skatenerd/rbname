require 'colorize'

class FileLine
  attr_accessor :number, :path
  def initialize(number, path)
    @number = number
    @path = path
  end

  def present_contents(pattern, context = 0)
    lines = lines_with_context(context)
    lines[context].gsub!(/#{pattern}/) do |match|
      match.red
    end
    lines.join("\n")
  end

  def lines_with_context(context)
    lower_limit = [number - context, 1].max
    upper_limit = number + context

    lower_padding = [1 - (number - context), 0].max
    upper_padding = [(number + context) - file_length, 0].max

    raw_sed = `sed -n '#{lower_limit},#{upper_limit} p' #{path}`
    splitted_sed = raw_sed.split("\n")

    [""] * lower_padding + splitted_sed + [""] * upper_padding
  end

  def file_length
    file_length = `wc -l #{path}`.strip.split(" ")[0].to_i
  end
end
