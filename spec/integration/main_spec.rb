require 'rspec'
require 'main'
require 'replacement'
require 'occurrences'

describe Main do
  it "upcases all lines containing 'upcaseme'" do
    file_path = "tmp/single_file.rb"
    File.write(file_path, "foo\nupcaseme\nbaz\n")
    occurrences = Occurrences.find("upcaseme", "tmp")

    occurrences.each do |occurrence|
      Replacement.replace(occurrence) do |line|
        line.upcase
      end
    end

    `cat #{file_path}`.should == "foo\nUPCASEME\nbaz\n"
  end
end
