require 'replacement_collection'
require 'replacement'
require 'rspec'

describe ReplacementCollection do

  it "knows which replacements apply to a given line" do
    replacement_collection = ReplacementCollection.new([
      Replacement.new("foo(", "bar"),
      Replacement.new("zzz", "bar")
    ])
    replacement_collection.applicable_replacements("foo(").should == [replacement_collection[0]]
  end

end
