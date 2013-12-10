class ReplacementCollection < Array
  def applicable_replacements(line_contents)
    select do |replacement|
      line_contents.match(Regexp.escape(replacement.removed_by_user))
    end
  end
end


