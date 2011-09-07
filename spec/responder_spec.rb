require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe Moneypenny::Responder do

  it 'registers all subclasses' do
    k = Class.new(Moneypenny::Responder)
    Moneypenny::Responder.all.should include(k)

    #cleanup
    Moneypenny::Responder.all.delete(k)
    Moneypenny::Responder.all.should_not include(k)
  end
end

