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

end
