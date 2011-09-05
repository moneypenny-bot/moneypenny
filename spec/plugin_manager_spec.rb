require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

class TestResponder < Moneypenny::Responder
  def self.respond(message)
  end
end

class TestListener < Moneypenny::Listener
  def self.respond(message)
  end
end

describe Moneypenny::PluginManager do

  before(:each) do
    @responder = Moneypenny::Responder.new
    @listener = Moneypenny::Listener.new
    @plugin_manager = Moneypenny::PluginManager.new(@responder, @listener)
  end

  describe "respond" do
    it "returns true for a message 'unload plugin (.*)'" do
      @plugin_manager.respond("unload plugin bar").should be_true
    end

    it "it removes the requested responder plugin" do
      @responder.load_plugin!(TestResponder.name)
      @responder.loaded_plugins.should include(TestResponder)
      @plugin_manager.respond("unload plugin TestResponder")
      @responder.loaded_plugins.should_not include(TestResponder)
    end

    it "it removes the requested listener plugin" do
      @listener.load_plugin!(TestListener.name)
      @listener.loaded_plugins.should include(TestListener)
      @plugin_manager.respond("unload plugin TestListener")
      @listener.loaded_plugins.should_not include(TestListener)
    end

    it "returns true for a message 'load plugin (.*)'" do
      @plugin_manager.respond("load plugin bar").should be_true
    end

    it "it loads the requested responder plugin" do
      @responder.loaded_plugins.should_not include(TestResponder)
      @plugin_manager.respond("load plugin TestResponder")
      @responder.loaded_plugins.should include(TestResponder)
    end

    it "it loads the requested listener plugin" do
      @listener.loaded_plugins.should_not include(TestListener)
      @plugin_manager.respond("load plugin TestListener")
      @listener.loaded_plugins.should include(TestListener)
    end

    it "returns true for a message 'load all plugins'" do
      @plugin_manager.respond("load all plugins").should be_true
    end

    it "loads all plugins when asked to" do
      @listener.loaded_plugins.should_not include(TestListener)
      @responder.loaded_plugins.should_not include(TestResponder)
      @plugin_manager.respond("load all plugins")
      @responder.loaded_plugins.should include(TestResponder)
      @listener.loaded_plugins.should include(TestListener)
    end

    it "returns false for any non-matching message" do
      @plugin_manager.respond("piss off").should be_false
    end
  end
end
