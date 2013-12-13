require 'extensions/array'
require 'extensions/string'
require 'extensions/object'
require 'replacement/score'

class Replacement
  attr_reader :removed_by_user, :added_by_user

  def initialize(removed_by_user, added_by_user, left_context, right_context)
    @removed_by_user = removed_by_user
    @added_by_user = added_by_user
    @left_context = left_context
    @right_context = right_context
  end

  def self.generate(before, after)
    leading_same_characters_count =  (0..before.length).to_a.find do |index|
      before[index] != after[index]
    end

    trailing_same_characters_count = (0..before.length).to_a.find do |index|
      before[before.length - index - 1] != after[after.length - index - 1]
    end

    removed_by_user = drop_characters(before, leading_same_characters_count, trailing_same_characters_count)
    added_by_user = drop_characters(after, leading_same_characters_count, trailing_same_characters_count)

    left_context = before[0...leading_same_characters_count]

    right_context = before[-trailing_same_characters_count..-1]

    Replacement.new(removed_by_user, added_by_user, left_context, right_context)
  end

  def suggest(requiring_suggestions)
    formattable_suggest(requiring_suggestions, &:identity)
  end

  def highlighted_suggest(requiring_suggestions)
    formattable_suggest(requiring_suggestions, &:red)
  end

  private

  def formattable_suggest(requiring_suggestions)
    indices = requiring_suggestions.indices_of_pattern(removed_by_user)

    best_replacement_index = indices.max_key do |index|
      Score.best_score(removed_by_user, requiring_suggestions, @left_context, @right_context, index)
    end

    return unless best_replacement_index

    subbed = requiring_suggestions[best_replacement_index..-1].sub(removed_by_user, yield(added_by_user))
    requiring_suggestions[0...best_replacement_index] + subbed
  end

  def self.drop_characters(subject, leading, trailing)
    subject[leading...(subject.size - trailing)]
  end
end

