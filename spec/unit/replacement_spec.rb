require 'rspec'
require 'replacement'

describe Replacement do

  before(:each) do
    FileUtils.rm_rf("tmp/.", secure: true)
  end

  it "replaces by line number and new-text, one-indexed" do
    file_path = "tmp/wat"

initial_file_contents =
"""foo
bar
baz
"""

    File.write(file_path, initial_file_contents)
    Replacement.replace(FileLine.new(2, file_path)) do
      "new stuff"
    end
    `cat #{file_path}`.should == "foo\nnew stuff\nbaz\n"
  end

  it "manipulates lines in the file" do
    file_path = "tmp/wat"
    File.write(file_path, "foo\n")
    Replacement.replace(FileLine.new(1, file_path)) do |file_line|
      file_line.raw_contents.upcase
    end
    `cat #{file_path}`.should == "FOO\n"
  end
end
