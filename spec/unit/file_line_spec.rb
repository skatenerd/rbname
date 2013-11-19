require 'spec_helper'
require 'rspec'
require 'file_line'

describe FileLine do
  before(:each) do
    clear_tmp
  end

  describe "#present_contents" do
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

  describe ".find_all" do
    it "reports a single occurrence in one file" do
      file_path = "tmp/single_file.rb"
      File.write(file_path, "foo\nbar\nbaz\n")
      occurrences = FileLine.find_all("bar", "tmp")
      occurrences.count.should == 1
      occurrences[0].number.should == 2
      occurrences[0].path.should == file_path
    end

    it "reports multiple occurrences in one file" do
      file_path = "tmp/single_file.rb"
      File.write(file_path, "foo\nfoo\nfoo\n")
      occurrences = FileLine.find_all("foo", "tmp")
      occurrences.count.should == 3
    end

    it "reports multiple occurrences in multiple files" do
      first_path = "tmp/first_file.rb"
      second_path = "tmp/second_file.rb"
      File.write(first_path, "foo\nfoo\nfoo\n")
      File.write(second_path, "foo\nfoo\nfoo\n")
      occurrences = FileLine.find_all("foo", "tmp")
      occurrences.count.should == 6
    end

  end

end
