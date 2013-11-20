class ReplacementCollection < Array
  def applicable_replacements(line_contents)
    select do |replacement|
      line_contents.match(replacement.to_replace)
    end
  end
end


