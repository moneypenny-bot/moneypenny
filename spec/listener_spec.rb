require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Moneypenny::Plugins::Listeners::Listener do

  it 'registers all subclasses' do
    k = Class.new(Moneypenny::Plugins::Listeners::Listener)
    Moneypenny::Plugins::Listeners::Listener.all.should include(k)

    #cleanup
    Moneypenny::Plugins::Listeners::Listener.all.delete(k)
    Moneypenny::Plugins::Listeners::Listener.all.should_not include(k)
  end
end

