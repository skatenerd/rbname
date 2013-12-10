class Replacement
  class Score
    def self.best_score(pattern, to_update, left_context, right_context, pattern_index)
      [right_score(pattern, to_update, right_context, pattern_index),
        left_score(to_update, left_context, pattern_index)].max
    end

    def self.right_score(pattern, to_update, right_context, pattern_index)
      pattern_length = pattern.length
      start_index = pattern_index + pattern_length
      string_dot_product(to_update[start_index..-1], right_context).count
    end

    def self.left_score(to_update, left_context, pattern_index)
      string_dot_product(to_update[0...pattern_index].reverse, left_context.reverse).count
    end


    def self.string_dot_product(first, second)
      first.split("").zip(second.split("")).take_while do |(a,b)|
        a == b
      end
    end
  end
end
