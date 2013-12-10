require 'rspec'
require 'replacement/score'

class Replacement

  describe Score do

    it "chooses the best score from left and right contexts" do
      Score.best_score("FOO", "leftFOOright", "left", "right", 4).should == 5
    end

    it "scores based on amount of right context matched" do
      Score.right_score("FOO", "FOOdefg", "defz", 0).should == 3
      Score.right_score("FOO", "abcFOOdefg", "defz", 3).should == 3
      Score.right_score("", "abcdefg", "defz", 3).should == 3
      Score.right_score("", "irrelevant", "foo", 3).should == 0
      Score.right_score("foo", "abcfooefg", "def", 3).should == 0
    end

    it "scores based on amount of left context matched" do
      Score.left_score("zFOOOabcfoo", "yFOOO", 5).should == 4
      Score.left_score("abcdefg", "rrrrrrrrr", 3).should == 0
    end
  end


end
