require File.expand_path( File.join(File.dirname(__FILE__), '..',  'spec_helper') )

describe Image do
  describe 'help' do
    it 'should return an Array with two Strings' do
      Image.help.should be_an_kind_of Array
      Image.help.size.should be 2
      Image.help[0].should be_a_kind_of String
      Image.help[1].should be_a_kind_of String
    end
  end

  describe 'respond' do
    context 'given a message that it understands' do 
      it "should respond to 'image me'" do 
        Image.respond('image me cat').should match /^https?:\/\/\w/i
      end
      it "should respond to 'find a something image'" do
        Image.respond('find a cat image').should match /^https?:\/\/\w/i
      end
      it "should pass back the error message for a failed search" do
        Image.respond("image me ..................").should match /I was unable to find/
      end
    end

    context 'given a message that it does not recognize' do
      it 'should return false' do
        message = stub 'message'
        Image.respond(message).should be_false
      end
    end

    context 'given you attempt to call a private class method' do
      it 'should throw a no method error exception' do
        lambda { 
          Image.image_search_url 'foo'
        }.should raise_error NoMethodError
      end
    end
  end
end
