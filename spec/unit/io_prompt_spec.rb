require 'rspec'
require 'io_prompt'
require 'spec_helper'

describe IOPrompt do

  before(:each) do
    @file_path = "tmp/single_file.rb"
    IOPrompt.stub(:puts)
    IOPrompt.stub(:gets)
    clear_tmp
  end

  it "asks user for what the line should be" do
    File.write(@file_path, "foo\nbar\nbaz\n")
    IOPrompt.stub(gets: "new line contents")
    IOPrompt.stub(:puts)
    IOPrompt.prompt(".+", FileLine.new(2, @file_path)).should == "new line contents"
  end

  it "colorizes the text in the prompt" do
    IOPrompt.should_receive(:puts).with("\nfoo\n#{"bar".red}\nbaz\n")
    File.write(@file_path, "foo\nbar\nbaz\n")
    IOPrompt.prompt(".+", FileLine.new(2, @file_path))
  end

  it "colorizes when at the boundary of the file" do
    IOPrompt.should_receive(:puts).with("\n\n#{"foo".red}\nbar\nbaz")
    File.write(@file_path, "foo\nbar\nbaz\n")
    IOPrompt.prompt(".+", FileLine.new(1, @file_path))
  end
end

