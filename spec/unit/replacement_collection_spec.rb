require 'replacement_collection'
require 'replacement'
require 'rspec'

describe ReplacementCollection do

  it "knows which replacements apply to a given line" do
    replacement_collection = ReplacementCollection.new([
      Replacement.generate("foo(", "bar"),
      Replacement.generate("zzz", "bar")
    ])
    replacement_collection.applicable_replacements("foo(").should == [replacement_collection[0]]
  end

  it "does not provide replacements with duplicate suggestions" do
    replacement_collection = ReplacementCollection.new([
      Replacement.generate("aaaend", "aaaFOOend"),
      Replacement.generate("bbbend", "bbbFOOend")
    ])
    replacement_collection.applicable_replacements("end").should == [replacement_collection[0]]
  end

end
