require 'spec_helper'
require 'main'

describe Main do

  before(:each) do
    clear_tmp
  end

  class FakeVimEdit
    def initialize(replacements_to_perform)
      @replacements_to_perform = replacements_to_perform
    end

    def execute!(file_line, pattern)
      file_line.update_filesystem!(replacements_to_perform.shift)
    end

    private

    attr_reader :replacements_to_perform
  end

  it "Permits making 2 kinds of edits and choosing between them.  And making erroneous inputs" do
    File.write("tmp/first_file.rb", "hello\nthis line contains foo\nyup")
    File.write("tmp/second_file.rb", "yolo\nyolo\nfoo")
    File.write("tmp/third_file.rb", "foo\n")

    ChangePrompt.stub(:gets).and_return("E\n", "99\n", "E\n", "1000", "1")
    ChangePrompt.stub(:puts)

    main = Main.new
    main.stub(:puts)
    main.manual_edit = FakeVimEdit.new(["this line contains bar", "baz"])
    main.stub(:gets).and_return("foo", "./tmp")
    main.replace_all

    File.read("tmp/first_file.rb").should match("bar")
    File.read("tmp/second_file.rb").should match("baz")
    File.read("tmp/third_file.rb").should match("baz")
  end
end
