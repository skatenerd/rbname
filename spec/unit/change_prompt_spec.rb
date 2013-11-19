require 'rspec'
require 'change_prompt'
require 'spec_helper'

describe ChangePrompt do

  before(:each) do
    clear_tmp
    @file_path = "tmp/single_file.rb"
    @file_line = FileLine.new(2, @file_path)
    File.write(@file_path, "foo\nbar\nbaz\n")
    ChangePrompt.stub(:puts)
    ChangePrompt.stub(:gets)
  end

  it "asks user for what the line should be" do
    ChangePrompt.stub(gets: "new line contents")
    ChangePrompt.stub(:puts)
    ChangePrompt.prompt(".+", @file_line).should == "new line contents"
  end

  it "prompts with the pretty version of the line's contents" do
    pattern = ".+"
    ChangePrompt.should_receive(:puts).with(@file_line.present_contents(pattern, 2))
    ChangePrompt.prompt(pattern, @file_line)
  end
end

