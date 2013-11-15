require 'rspec'
require 'io_prompt'
require 'spec_helper'

describe IOPrompt do

  before(:each) do
    clear_tmp
    @file_path = "tmp/single_file.rb"
    @file_line = FileLine.new(2, @file_path)
    File.write(@file_path, "foo\nbar\nbaz\n")
    IOPrompt.stub(:puts)
    IOPrompt.stub(:gets)
  end

  it "asks user for what the line should be" do
    IOPrompt.stub(gets: "new line contents")
    IOPrompt.stub(:puts)
    IOPrompt.prompt(".+", @file_line).should == "new line contents"
  end

  it "prompts with the pretty version of the line's contents" do
    pattern = ".+"
    IOPrompt.should_receive(:puts).with(@file_line.present_contents(pattern, 2))
    IOPrompt.prompt(pattern, @file_line)
  end
end

