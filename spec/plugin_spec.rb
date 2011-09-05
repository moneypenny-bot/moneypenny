require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class TestPlugin < Moneypenny::Plugin
  def help
    ['','']
  end

  def respond(message)
    false
  end
end


describe Moneypenny::Plugin do
  let(:plugin) { Moneypenny::Plugin.new }

  before(:each) do
    plugin.class.stubs(:all).returns([TestPlugin])
  end

  it "loads nothing into loaded_plugins by default" do
    plugin.loaded_plugins.should be_empty
  end

  describe "load_plugin!" do
    it "accepts the name of a plugin and adds it to the loaded_plugins array" do
      plugin.loaded_plugins.should_not include(TestPlugin)
      plugin.load_plugin!("TestPlugin")
      plugin.loaded_plugins.should include(TestPlugin)
    end

    it "raises an ArgumentError if you try and load an unknown plugin" do
      lambda {
        plugin.load_plugin!("MadeUpPlugin")
      }.should raise_error(ArgumentError)
    end

    it "only ever loads one copy of the plugin" do
      plugin.load_plugin!("TestPlugin")
      plugin.load_plugin!("TestPlugin")
      plugin.loaded_plugins.count {|p|
        p == TestPlugin
      }.should == 1
    end
  end

  describe "load_all!" do
    it "loads all plugins" do
      plugin.load_all!
      plugin.loaded_plugins.should == Set.new(Moneypenny::Plugin.all)
    end
  end

  describe "unload_plugin!" do
    it "unloads a loaded plugin" do
      plugin.load_plugin!("TestPlugin")
      plugin.loaded_plugins.should include(TestPlugin)
      plugin.unload_plugin!("TestPlugin")
      plugin.loaded_plugins.should_not include(TestPlugin)
    end

    it "raises an ArgumentError if you try and unload an unknown plugin" do
      lambda {
        plugin.unload_plugin!("MadeUpPlugin")
      }.should raise_error(ArgumentError)
    end

    it "does nothing if you try and unload an unloaded plugin" do
      plugin.unload_plugin!("TestPlugin")
    end
  end
end
