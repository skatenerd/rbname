require 'rspec'
require 'replacement'

describe Replacement do
  it "encapsulates a replacement inside a string" do
    presented_to_user = "same foo same"
    after_user_update = "same babar same"
    replacement = Replacement.generate(presented_to_user, after_user_update)
    replacement.to_replace.should == "foo"
    replacement.new_text.should == "babar"
  end

  it "makes a suggestion for a string" do
    replacement = Replacement.new("foo", "babar")
    replacement.suggest("another foo example").should == "another babar example"
  end

  it "suggest null, if it cannot make a good suggestion" do
    replacement = Replacement.new("foo", "babar")
    replacement.suggest("irrelevant").should be_nil
  end

  it "makes suggestions based on a collection of theories" do
    first_replacement = Replacement.new("foo", "hi")
    second_replacement = Replacement.new("foo", "bye")
    third_replacement = Replacement.new("not_found", "panda")

    Replacement.suggestions([first_replacement, second_replacement, third_replacement], "foo").should == ["hi", "bye"]
  end

  it "does not duplicate suggestions" do
    first_replacement = Replacement.new("foo", "hi")
    second_replacement = Replacement.new("foo", "hi")

    Replacement.suggestions([first_replacement, second_replacement], "foo").should == ["hi"]
  end
end
