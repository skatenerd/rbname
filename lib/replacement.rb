class Replacement
  attr_reader :to_replace, :new_text

  def initialize(to_replace, new_text)
    @to_replace = to_replace
    @new_text = new_text
  end

  def self.suggestions(replacements, to_change)
    replacements.map { |replacement| replacement.suggest(to_change) }.uniq.compact
  end

  def self.generate(before, after)
    leading_same_characters_count =  (0..before.length).to_a.find do |index|
      before[index] != after[index]
    end

    trailing_same_characters_count = (0..before.length).to_a.find do |index|
      before[before.length - index - 1] != after[after.length - index - 1]
    end

    to_replace = drop_characters(before, leading_same_characters_count, trailing_same_characters_count)
    new_text = drop_characters(after, leading_same_characters_count, trailing_same_characters_count)

    Replacement.new(to_replace, new_text)
  end

  def suggest(to_change)
    if to_change.match(to_replace)
      to_change.sub(to_replace, new_text)
    end
  end

  private

  def self.drop_characters(subject, leading, trailing)
    subject[leading...(subject.size - trailing)]
  end
end
