class ReplacementCollection < Array
  def applicable_replacements(line_contents)
    applicable = select do |replacement|
      line_contents.match(Regexp.escape(replacement.removed_by_user))
    end
    applicable.uniq do |replacement|
      replacement.suggest(line_contents)
    end
  end
end


