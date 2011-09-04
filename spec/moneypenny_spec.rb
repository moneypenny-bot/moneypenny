require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Moneypenny" do
  before(:each) do
    @connection = mock('connection')
    @logger = NullLogger.new
    @bot = Moneypenny::Moneypenny.new({}, @logger)
    @bot.connection = @connection
  end

  describe "say" do
    it "delegates to the @connection" do
      message = stub('message')
      @connection.expects(:say).with(message)
      @bot.say( message )
    end
  end

  describe "hear" do
    it "ignores messages that don't start with moneypenny or mp" do
      Moneypenny::Responder.expects(:all).never
      Moneypenny::Listener.stubs(:all).returns([])
      @connection.expects(:say).never
      @bot.hear('foo')
    end

    it "passes all messages to listeners" do
      Moneypenny::Listener.expects(:all).returns([])
      @bot.hear('foo')
    end

    it "calls responders on all messages that match the bot's name" do
      message = mock('message')
      @bot.stubs(:matching_message).with(message).returns(true)
      Moneypenny::Responder.expects(:all).returns([])
      @bot.stubs(:apologize)
      @bot.hear( message )
    end

    it "appologizes if the message matches but no responders respond to it" do
      message = mock('message')
      @bot.stubs(:matching_message).with(message).returns(true)
      Moneypenny::Responder.stubs(:all).returns([])
      @bot.expects(:apologize)
      @bot.hear( message )
    end

    it 'says any message returned by a listener' do
      @bot.stubs(:matching_message).returns(false)
      listener = mock('listener', :respond => 'msg')
      Moneypenny::Listener.expects(:all).returns( [listener] )
      @bot.expects(:say).with('msg')
      @bot.hear('foo')
    end

    it 'says any message returned by a responder' do
      @bot.stubs(:matching_message).returns('matching message')
      responder = mock('responder', :respond => 'msg')
      Moneypenny::Responder.stubs(:all).returns( [responder] )
      Moneypenny::Listener.stubs(:all).returns( [] )
      @bot.expects(:say).with('msg')
      @bot.hear('foo')
    end
  end
end
