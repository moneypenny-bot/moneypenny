require File.expand_path( File.join(File.dirname(__FILE__), '..',  'spec_helper') )

describe Version do
  describe 'help' do
    it 'should return an Array with two Strings' do
      Version.help.should be_an(Array)
      Version.help.size.should == 2
      Version.help[0].should be_a(String)
      Version.help[1].should be_a(String)
    end
  end

  describe 'respond' do
    context "given 'version'" do
      it 'should return the current version' do
        Version.respond('version').should =~ /Current Moneypenny version: /
      end
    end

    context 'given a message that it does not recognize' do
      it 'should return false' do
        message = stub 'message'
        message.expects(:match).returns(false)
        Version.respond(message).should be_false
      end
    end
  end
end
