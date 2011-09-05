require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class TestResponder < Moneypenny::Responder
  def help
    ['','']
  end

  def respond(message)
    false
  end
end

describe Moneypenny::Responder do
  let(:responder) { Moneypenny::Responder.new }

  it "registers all subclasses" do
    k = Class.new(Moneypenny::Responder)
    Moneypenny::Responder.all.should include(k)

    #cleanup
    Moneypenny::Responder.all.delete(k)
    Moneypenny::Responder.all.should_not include(k)
  end

  it "loads nothing into loaded_plugins by default" do
    responder.loaded_plugins.should be_empty
  end

  describe "load_plugin!" do
    it "accepts the name of a plugin and adds it to the loaded_plugins array" do
      responder.loaded_plugins.should_not include(TestResponder)
      responder.load_plugin!("TestResponder")
      responder.loaded_plugins.should include(TestResponder)
    end

    it "raises an ArgumentError if you try and load an unknown plugin" do
      lambda {
        responder.load_plugin!("MadeUpResponder")
      }.should raise_error(ArgumentError)
    end

    it "only ever loads one copy of the plugin" do
      responder.load_plugin!("TestResponder")
      responder.load_plugin!("TestResponder")
      responder.loaded_plugins.count {|p|
        p == TestResponder
      }.should == 1
    end
  end

  describe "load_all!" do
    it "loads all plugins" do
      responder.load_all!
      responder.loaded_plugins.should == Set.new(Moneypenny::Responder.all)
    end
  end

  describe "remove_plugin!" do
    it "removes a loaded plugin" do
      responder.load_plugin!("TestResponder")
      responder.loaded_plugins.should include(TestResponder)
      responder.remove_plugin!("TestResponder")
      responder.loaded_plugins.should_not include(TestResponder)
    end

    it "raises an ArgumentError if you try and remove an unknown plugin" do
      lambda {
        responder.remove_plugin!("MadeUpResponder")
      }.should raise_error(ArgumentError)
    end

    it "does nothing if you try and remove an unloaded plugin" do
      responder.remove_plugin!("TestResponder")
    end
  end
end
