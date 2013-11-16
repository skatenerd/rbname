class TheoryGenerator
  def self.generate(before, after)
    leading_same_characters_count =  (0..before.length).to_a.find do |index|
      before[index] != after[index]
    end

    trailing_same_characters_count = (0..before.length).to_a.find do |index|
      before[before.length - index - 1] != after[after.length - index - 1]
    end

    return {
      to_replace: drop_characters(before, leading_same_characters_count, trailing_same_characters_count),
      replacement: drop_characters(after, leading_same_characters_count, trailing_same_characters_count)
    }
  end

  def self.drop_characters(subject, leading, trailing)
    subject[leading...(subject.size - trailing)]
  end
end
