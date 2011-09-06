require File.expand_path( File.join(File.dirname(__FILE__), '..',  'spec_helper') )

describe Moneypenny::Plugins::Listeners::ThatsWhatSheSaid do
  before :each do
    moneypenny = stub 'moneypenny'
    moneypenny.expects(:config).returns({})
    @thats_what_she_said = Moneypenny::Plugins::Listeners::ThatsWhatSheSaid.new moneypenny
  end

  it "says That's what she said if TWSS agrees" do
    TWSS.expects(:classify).with('msg').returns(true)
    @thats_what_she_said.respond('msg').should == "That's what she said!"
  end
end
