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
      occurrences[0].line_number.should == 2
      occurrences[0].path.should == file_path
    end

    it "reports multiple occurrences in one file" do
      file_path = "tmp/single_file.rb"
      File.write(file_path, "foo\nfoo\nfoo\n")
      occurrences = FileLine.find_all("foo", "tmp")
      occurrences.count.should == 3
    end

    it "excludes a file" do
      file = "tmp/single_file.rb"
      File.write(file, "foo\nbar\nbaz\n")
      occurrences = FileLine.find_all("foo", "tmp", "single_file.rb")
      occurrences.count.should == 0
    end

    it "excludes multiple files" do
      first_file = "tmp/first_file.rb"
      second_file = "tmp/second_file.rb"

      File.write(first_file, "foo\nbar\nbaz\n")
      File.write(second_file, "baz\nbar\nfoo\n")
      occurrences = FileLine.find_all("foo", "tmp", "first_file.rb",
                                      "second_file.rb")
      occurrences.count.should == 0
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

  describe "#update_filesystem!" do
    it "changes an entire line" do
      file_path = "tmp/single_file.rb"
      File.write(file_path, "foo\nfoo\nfoo\n")

      file_line = FileLine.new(2, file_path)
      file_line.update_filesystem!("lol")

      File.read(file_path).should == "foo\nlol\nfoo"
    end

    it "does not mess up single quotations" do
      file_path = "tmp/single_file.rb"
      File.write(file_path, "require 'what'")

      file_line = FileLine.new(1, file_path)
      file_line.update_filesystem!("require 'okay'")

      File.read(file_path).should == "require 'okay'"
    end
  end

end
