require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Moneypenny" do
  before(:each) do
    @connection = mock('connection')
    @logger = NullLogger.new
    @bot = Moneypenny::Moneypenny.new({}, @logger)
    @bot.stubs(:connection).returns(@connection)
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
      @bot.expects(:responders).never
      @bot.stubs(:listeners).returns([])
      @connection.expects(:say).never
      @bot.hear('foo')
    end

    it "passes all messages to listeners" do
      @bot.expects(:listeners).returns([])
      @bot.hear('foo')
    end

    it "calls responders on all messages that match the bot's name" do
      message = mock('message')
      @bot.stubs(:matching_message).with(message).returns(true)
      @bot.expects(:responders).returns([])
      @bot.stubs(:apologize)
      @bot.hear( message )
    end

    it "appologizes if the message matches but no responders respond to it" do
      message = mock('message')
      @bot.stubs(:matching_message).with(message).returns(true)
      @bot.stubs(:responders).returns([])
      @bot.expects(:apologize)
      @bot.hear( message )
    end

    it 'says any message returned by a listener' do
      @bot.stubs(:matching_message).returns(false)
      listener = mock('listener', :respond => 'msg')
      @bot.expects(:listeners).returns( [listener] )
      @bot.expects(:say).with('msg')
      @bot.hear('foo')
    end

    it 'says any message returned by a responder' do
      @bot.stubs(:matching_message).returns('matching message')
      responder = mock('responder', :respond => 'msg')
      @bot.stubs(:responders).returns( [responder] )
      @bot.stubs(:listeners).returns( [] )
      @bot.expects(:say).with('msg')
      @bot.hear('foo')
    end
  end
end
