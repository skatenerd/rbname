require 'rspec'
require 'theory'

describe Theory do
  it "encapsulates a replacement inside a string" do
    presented_to_user = "same foo same"
    after_user_update = "same babar same"
    theory = Theory.generate(presented_to_user, after_user_update)
    theory.to_replace.should == "foo"
    theory.replacement.should == "babar"
  end

  it "makes a suggestion for a string" do
    theory = Theory.new("foo", "babar")
    theory.suggest("another foo example").should == "another babar example"
  end

  it "suggest null, if it cannot make a good suggestion" do
    theory = Theory.new("foo", "babar")
    theory.suggest("irrelevant").should be_nil
  end

  it "makes suggestions based on a collection of theories" do
    first_theory = Theory.new("foo", "hi")
    second_theory = Theory.new("foo", "bye")
    third_theory = Theory.new("not_found", "panda")

    Theory.suggestions([first_theory, second_theory, third_theory], "foo").should == ["hi", "bye"]
  end

  it "does not duplicate suggestions" do
    first_theory = Theory.new("foo", "hi")
    second_theory = Theory.new("foo", "hi")

    Theory.suggestions([first_theory, second_theory], "foo").should == ["hi"]
  end
end
