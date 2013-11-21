require 'spec_helper'
require 'rspec'
require 'file_line'

describe FileLine do
  before(:each) do
    clear_tmp
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
