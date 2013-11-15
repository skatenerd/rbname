require 'spec_helper'
require 'rspec'
require 'file_line'

describe FileLine do
  before(:each) do
    clear_tmp
  end

  it "shows a line from file with no context" do
    file_path = "tmp/single_file.rb"
    contents = "a\nstuffMATCHstuff\nc\n"
    File.write(file_path, contents)
    FileLine.new(2, file_path).present_contents("MATCH").should == "2:  stuff#{"MATCH".red}stuff"
  end

  it "shows a line from file with 1 line on each side of context" do
    file_path = "tmp/single_file.rb"
    contents = "a\nb\nc\n"
    File.write(file_path, contents)
    FileLine.new(2, file_path).present_contents(".+", 1).should ==
"""1:  a
2:  #{"b".red}
3:  c"""
  end

  it "handles too much context blowing past end of file" do
    file_path = "tmp/single_file.rb"
    contents = "a\nb\n"
    File.write(file_path, contents)
    FileLine.new(1, file_path).present_contents(".+", 2).should == "1:  #{"a".red}\n2:  b"
  end

end
