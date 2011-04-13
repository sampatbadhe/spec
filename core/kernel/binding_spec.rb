require File.expand_path('../../../spec_helper', __FILE__)
require File.expand_path('../fixtures/classes', __FILE__)

describe "Kernel#binding" do
  it "is a private method" do
    Kernel.should have_private_instance_method(:binding)
  end
  
  before(:each) do
    @b1 = KernelSpecs::Binding.new(99).get_binding
  end

  it "returns a Binding object" do
    @b1.kind_of?(Binding).should == true
  end

  it "encapsulates the execution context properly" do
    eval("@secret", @b1).should == 100
    eval("a", @b1).should == true
    eval("b", @b1).should == true
    eval("@@super_secret", @b1).should == "password"

    eval("square(2)", @b1).should == 4
    eval("self.square(2)", @b1).should == 4

    eval("a = false", @b1)
    eval("a", @b1).should == false
  end

  it "raises a NameError on undefined variable" do
    lambda { eval("a_fake_variable", @b1) }.should raise_error(NameError)
  end
end

describe "Kernel.binding" do
  it "needs to be reviewed for spec completeness"
  
  ruby_version_is ""..."1.9" do
    it "uses Kernel for 'self' in the binding" do
      eval('self', Kernel.binding).should == Kernel
    end
  end
  
  ruby_version_is "1.9" do
    it "uses the caller's self for 'self' in the binding" do
      eval('self', Kernel.binding).should == self
    end
    
    it "uses the class or module as 'self' in a binding call from Class/Module.new block form" do
      cls_self = nil
      cls = Class.new {cls_self = eval 'self', Kernel.binding}
      cls_self.should == cls
      
      cls_self = nil
      cls = Class.new {cls_self = eval 'self', binding}

      cls_self.should == cls
    end
  end
end
