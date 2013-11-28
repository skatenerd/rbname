require 'rspec'
require 'replacement'

describe Replacement do
  it "makes a suggestion for a string" do
    replacement = Replacement.generate("stuff bad morestuff", "stuff good morestuff")
    replacement.suggest("this is a bad line").should == "this is a good line"
  end

  it "suggest null, if it cannot make a good suggestion" do
    replacement = Replacement.generate("foo", "babar")
    replacement.suggest("irrelevant").should be_nil
  end

  it "makes suggestions based on a collection of theories" do
    first_replacement = Replacement.generate("this is mediocre", "this is good")
    second_replacement = Replacement.generate("this is mediocre", "this is bad")
    third_replacement = Replacement.generate("i hate pandas", "i love pandas")

    Replacement.suggestions([first_replacement, second_replacement, third_replacement], "another mediocre day..").should == ["another good day..", "another bad day.."]
  end

  it "does not duplicate suggestions" do
    first_replacement = Replacement.generate("foo", "hi")
    second_replacement = Replacement.generate("foo", "hi")

    Replacement.suggestions([first_replacement, second_replacement], "foo").should == ["hi"]
  end
end
