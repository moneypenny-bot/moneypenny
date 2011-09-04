require File.expand_path( File.join(File.dirname(__FILE__), '..',  'spec_helper') )

describe Version do
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
