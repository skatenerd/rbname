require 'rspec'
require 'main'
require 'replacement'
require 'occurrences'

describe Main do
  it "upcases all lines containing 'upcaseme'" do
    file_path = "tmp/single_file.rb"
    File.write(file_path, "foo\nupcaseme\nbaz\n")

    Main.replace_all("upcaseme", "tmp") do |line|
      line.upcase
    end

    `cat #{file_path}`.should == "foo\nUPCASEME\nbaz\n"
  end
end
