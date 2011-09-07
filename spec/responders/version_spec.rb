require File.expand_path( File.join(File.dirname(__FILE__), '..',  'spec_helper') )

describe Moneypenny::Plugins::Responders::Version do
  before :each do
    @version = Moneypenny::Plugins::Responders::Version.new stub('moneypenny')
  end
  
  describe 'help' do
    it 'should return an Array with two Strings' do
      @version.help.should be_an(Array)
      @version.help.size.should == 2
      @version.help[0].should be_a(String)
      @version.help[1].should be_a(String)
    end
  end

  describe 'respond' do
    context "given 'version'" do
      it 'should return the current version' do
        @version.respond('version').should =~ /Current Moneypenny version: /
      end
    end

    context 'given a message that it does not recognize' do
      it 'should return false' do
        message = stub 'message'
        message.expects(:match).returns(false)
        @version.respond(message).should be_false
      end
    end
  end
end
