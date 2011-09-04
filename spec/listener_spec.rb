require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Moneypenny::Listener do

  it 'registers all subclasses' do
    k = Class.new(Moneypenny::Listener)
    Moneypenny::Listener.all.should include(k)

    #cleanup
    Moneypenny::Listener.all.delete(k)
    Moneypenny::Listener.all.should_not include(k)
  end
end

