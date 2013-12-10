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

  it "understands pure insertions based on what is to the right" do
    replacement = Replacement.generate("use MyClass", "use ExtendedMyClass")
    replacement.suggest("require MyClass").should == "require ExtendedMyClass"
  end

  it "understands pure insertions based on what is to the left" do
    replacement = Replacement.generate("MyClass lol", "MyClassExtended lol")
    replacement.suggest("MyClass zzz").should == "MyClassExtended zzz"
  end
end
