require 'rspec'
require 'main'
require 'replacement'
require 'occurrences'

describe Main do
  it "upcases all lines containing 'upcaseme'" do
    Main.stub(gets: "upc.*me")
    Main.stub(:puts)
    IOPrompt.stub(prompt: "UPCASEME")
    file_path = "tmp/single_file.rb"
    File.write(file_path, "foo\nupcaseme\nbaz\n")

    Main.replace_all("tmp")

    `cat #{file_path}`.should == "foo\nUPCASEME\nbaz\n"
  end

end
