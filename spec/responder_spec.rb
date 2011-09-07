require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Moneypenny::Plugins::Responders::Responder do

  it 'registers all subclasses' do
    k = Class.new(Moneypenny::Plugins::Responders::Responder)
    Moneypenny::Plugins::Responders::Responder.all.should include(k)

    #cleanup
    Moneypenny::Plugins::Responders::Responder.all.delete(k)
    Moneypenny::Plugins::Responders::Responder.all.should_not include(k)
  end
end

