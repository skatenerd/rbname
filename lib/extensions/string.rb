class String
  def indices_of_pattern(pattern)
    indices = []
    split("").each_with_index do |_, idx|
      if self[idx..-1].start_with?(pattern)
        indices  << idx
      end
    end
    indices
  end
end
