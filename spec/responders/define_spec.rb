require File.expand_path( File.join(File.dirname(__FILE__), '..',  'spec_helper') )

describe Define do
  describe 'help' do
    it 'should return an Array with two Strings' do
      Define.help.should be_an(Array)
      Define.help.size.should == 2
      Define.help[0].should be_a(String)
      Define.help[1].should be_a(String)
    end
  end

  describe 'respond' do
    context "given a term with definitions" do
      it 'should return the first definition' do
        Define.expects(:data_for_term).with('space travel').returns <<-EOF
          <div id='entry_1'><div class='definition'>Wooo Space!</div></div>
          <div id='entry_2'><div class='definition'>Big and Dark</div></div>
        EOF
        Define.respond('define space travel').should == 'space travel is Wooo Space! (http://www.urbandictionary.com/define.php?term=space+travel&defid=1)'
      end
    end
    
    context "given a term without definitions" do
      it 'should say it could not find a definition' do
        Define.expects(:data_for_term).with('space travel').returns <<-EOF
        EOF
        Define.respond('define space travel').should == "I couldn't find the definition for space travel."
      end
    end
  
    context 'given a message that it does not recognize' do
      it 'should return false' do
        message = stub 'message'
        message.expects(:match).returns(false)
        Define.respond(message).should be_false
      end
    end
  end

  describe 'url_for_term' do
    context 'given a term' do
      it 'should construct a url' do
        Define.url_for_term('space travel').should == 'http://www.urbandictionary.com/define.php?term=space+travel'
      end
    end
  end

  describe 'data_for_term' do
    context 'given a term' do
      it 'should call open with the url for the term and return' do
        Define.expects(:url_for_term).with('space travel').returns('url')
        Define.expects(:open).with('url').returns('response')
        Define.data_for_term('space travel').should == 'response'
      end
    end
  end

  describe 'nokogiri_for_term' do
    context 'given a term' do
      it 'should return Nokogiri::HTML for the term and return' do
        Define.expects(:data_for_term).with('space travel').returns('')
        Define.nokogiri_for_term('space travel').should be_a(Nokogiri::HTML::Document)
      end
    end
  end

  describe 'definitions_for_term' do
    context 'given a term' do
      it 'should return definitions with urls' do
        Define.expects(:data_for_term).with('space travel').returns <<-EOF
          <div id='entry_1'><div class='definition'>Wooo Space!</div></div>
          <div id='entry_2'><div class='definition'>Big and Dark</div></div>
        EOF
        definitions = Define.definitions_for_term 'space travel'
        definitions.should be_an(Array)
        definitions.size.should == 2
        definitions[0].should be_an(Array)
        definitions[0].size.should == 2
        definitions[0][0].should == 'Wooo Space!'
        definitions[0][1].should == 'http://www.urbandictionary.com/define.php?term=space+travel&defid=1'
        definitions[1].should be_an(Array)
        definitions[1].size.should == 2
        definitions[1][0].should == 'Big and Dark'
        definitions[1][1].should == 'http://www.urbandictionary.com/define.php?term=space+travel&defid=2'
      end
    end
  end
end
