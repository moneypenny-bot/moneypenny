require File.expand_path(File.dirname(__FILE__) + '/spec_helper')

describe "Moneypenny" do
  before(:each) do
    @connection = mock('connection', :listen => nil)
    @logger = NullLogger.new
    @bot = Moneypenny::Moneypenny.new(@connection, @logger)
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
      @connection.expects(:say).never
      @bot.hear('foo')
    end
  end
end
