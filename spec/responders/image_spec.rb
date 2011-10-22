describe Moneypenny::Plugins::Responders::Image do
  before :each do
    moneypenny = Moneypenny::Moneypenny.new({}, nil)
    @image = Moneypenny::Plugins::Responders::Image.new moneypenny
  end

  describe 'help' do
    it 'should return an Array with two Strings' do
      @image.help.should be_an_kind_of Array
      @image.help.size.should be 2
      @image.help[0].should be_a_kind_of String
      @image.help[1].should be_a_kind_of String
    end
  end

  describe 'respond' do
    bad_search_term = ".................."
    good_search_term = "cat"

    context 'given a message that it understands' do 
      it "should respond to 'image me'" do 
        VCR.use_cassette('image_good_search') do
          @image.respond('image me #{good_search_term}').should match /^https?:\/\/\w/i
        end
      end

      it "should respond to 'find a something image'" do
        VCR.use_cassette('image_good_search') do
          @image.respond('find a #{good_search_term} image').should match /^https?:\/\/\w/i
        end
      end

      it "should pass back the default error message for a failed search" do
        VCR.use_cassette('image_bad_search') do
          @image.respond("image me #{bad_search_term}").should match /I was unable to find/
        end
      end

      it "should pass back a custom error message for a failed search" do
        VCR.use_cassette('image_bad_search') do
          @image.respond("find a #{bad_search_term} photo").should match Regexp.new("a[^n].*#{bad_search_term}.*photo")
        end
      end
    end

    context 'given a message that it does not recognize' do
      it 'should return false' do
        message = stub 'message'
        @image.respond(message).should be_false
      end
    end

  end
end
