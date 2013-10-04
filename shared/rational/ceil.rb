require File.expand_path('../../../spec_helper', __FILE__)

ruby_version_is "1.9.2" do
  describe :rational_ceil, :shared => true do
    before do
      @rational = Rational(2200, 7)
    end

    describe "with no arguments (precision = 0)" do
      it "returns an Integer" do
        Rational(19.18).ceil.should be_kind_of(Integer)
      end

      it "returns the truncated value toward positive infinity" do
        Rational(200, 87).ceil.should == 3
        Rational(6.1, 9).ceil.should == 1
        Rational(686543**99).ceil.should == 686543**99
      end
    end

    describe "with a precision < 0" do
      it "returns an Integer" do
        @rational.ceil(-2).should be_kind_of(Integer)
        @rational.ceil(-1).should be_kind_of(Integer)
      end

      it "moves the truncation point n decimal places left" do
        @rational.ceil(-3).should == 1000
        @rational.ceil(-2).should == 400
        @rational.ceil(-1).should == 320
      end
    end

    describe "with precision > 0" do
      it "returns a Rational" do
        @rational.ceil(1).should be_kind_of(Rational)
        @rational.ceil(2).should be_kind_of(Rational)
      end

      it "moves the truncation point n decimal places right" do
        @rational.ceil(1).should == Rational(3143, 10)
        @rational.ceil(2).should == Rational(31429, 100)
        @rational.ceil(3).should == Rational(157143, 500)
      end
    end
  end
end

ruby_version_is ""..."1.9.2" do
  describe :rational_ceil, :shared => true do
    it "returns an Integer" do
      Rational(19).ceil.should be_kind_of(Integer)
    end

    ruby_version_is ""..."1.8.6" do
      it "returns the smallest integer >= self as an integer" do
        Rational(200, 87).ceil.should == 3
        Rational(6, 9).ceil.should == 1
      end
    end

    ruby_version_is "1.8.6"..."" do
      it "returns the smallest integer >= self as an integer" do
        Rational(200, 87).ceil.should == 3
        Rational(6, 9).ceil.should == 1
        Rational(686543**99).ceil.should == 686543**99
      end
    end
  end
end
