class Main
  def self.replace_all(pattern, root_path)
    occurrences = Occurrences.find(pattern, root_path)

    occurrences.each do |occurrence|
      Replacement.replace(occurrence) do |line|
        yield(line)
      end
    end
  end
end
