require 'rspec'
require 'replacement'
require 'change_prompt'

describe ChangePrompt do
  before(:each) do
    ChangePrompt.stub(gets: "", puts: "")
  end

  it "lets the user choose to edit with vim" do
    ChangePrompt.stub(gets: "e\n")
    file_line = FileLine.new(1, __FILE__)
    user_input = ChangePrompt.prompt(".*", file_line, [])
    user_input.should be_chose_editor
  end

  it "lets the user chose the first option presented" do
    ChangePrompt.stub(gets: "1\n")
    replacement = Replacement.generate("require", "zzzzzzzzz")
    file_line = FileLine.new(1, __FILE__)
    user_input = ChangePrompt.prompt(".*", file_line, [replacement])
    user_input.selected_replacement.should == replacement
  end

  it "keeps prompting until the user enters good inputs" do
    ChangePrompt.stub(:gets).and_return("9\n", "1\n")
    replacement = Replacement.generate("require", "zzzzzzzzz")
    file_line = FileLine.new(1, __FILE__)
    user_input = ChangePrompt.prompt(".*", file_line, [replacement])
    user_input.selected_replacement.should == replacement
  end

  it "lets the user enter empty input" do
    ChangePrompt.stub(:gets).and_return("\n")
    file_line = FileLine.new(1, __FILE__)
    replacement = Replacement.generate("require", "zzzzzzzzz")
    user_input = ChangePrompt.prompt(".*", file_line, [replacement])
    user_input.should_not be_chose_editor
    user_input.selected_replacement.should be_nil
  end
end
