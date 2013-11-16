require 'rspec'
require 'theory_generator'

describe TheoryGenerator do
  it "generates a diff from before and after" do
    presented_to_user = "same foo same"
    after_user_update = "same babar same"
    TheoryGenerator.generate(presented_to_user, after_user_update).should == {
      to_replace: "foo",
      replacement: "babar"
    }
  end
end
