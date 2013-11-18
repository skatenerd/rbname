class Theory
  attr_reader :to_replace, :replacement

  def initialize(to_replace, replacement)
    @to_replace = to_replace
    @replacement = replacement
  end

  def self.suggestions(theories, to_change)
    theories.map { |theory| theory.suggest(to_change) }.uniq.compact
  end

  def self.generate(before, after)
    leading_same_characters_count =  (0..before.length).to_a.find do |index|
      before[index] != after[index]
    end

    trailing_same_characters_count = (0..before.length).to_a.find do |index|
      before[before.length - index - 1] != after[after.length - index - 1]
    end

    to_replace = drop_characters(before, leading_same_characters_count, trailing_same_characters_count)
    replacement = drop_characters(after, leading_same_characters_count, trailing_same_characters_count)

    Theory.new(to_replace, replacement)
  end

  def suggest(to_change)
    if to_change.match(to_replace)
      to_change.gsub(to_replace, replacement)
    end
  end

  private

  def self.drop_characters(subject, leading, trailing)
    subject[leading...(subject.size - trailing)]
  end
end
