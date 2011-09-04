require File.expand_path( File.join(File.dirname(__FILE__), '..',  'spec_helper') )

describe ThatsWhatSheSaid do
  it "says That's what she said if TWSS agrees" do
    TWSS.expects(:classify).with('msg').returns(true)
    ThatsWhatSheSaid.respond('msg').should == "That's what she said!"
  end
end
