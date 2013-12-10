class Array
  def max_key
    values = map do |element|
      yield(element)
    end

    values.index(values.max)
  end
end
