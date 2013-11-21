require 'spec_helper'
require 'rspec'
require 'file_line'
require 'file_line_presenter'

describe FileLine do
  before(:each) do
    clear_tmp
  end

  describe "#present_contents" do
    it "shows a line from file with no context" do
      file_path = "tmp/single_file.rb"
      contents = "a\nstuffMATCHstuff\nc\n"
      File.write(file_path, contents)
      file_line = FileLine.new(2, file_path)
      presented_line = FileLinePresenter.present_contents(file_line, "MATCH")
      presented_line.should == "2:  stuff#{"MATCH".red}stuff"
    end

    it "shows a line from file with 1 line on each side of context" do
      file_path = "tmp/single_file.rb"
      contents = "a\nb\nc\n"
      File.write(file_path, contents)
      file_line = FileLine.new(2, file_path)
      presented_line = FileLinePresenter.present_contents(file_line, ".+", 1)
      presented_line.should ==
"""1:  a
2:  #{"b".red}
3:  c"""
    end

    it "handles too much context blowing past end of file" do
      file_path = "tmp/single_file.rb"
      contents = "a\nb\n"
      File.write(file_path, contents)
      file_line = FileLine.new(1, file_path)
      presented_line = FileLinePresenter.present_contents(file_line, ".+", 2)
      presented_line.should == "1:  #{"a".red}\n2:  b"
    end
  end

end
