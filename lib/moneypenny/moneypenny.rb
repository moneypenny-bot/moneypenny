module Moneypenny
  class Moneypenny
    attr_accessor :connection, :logger
    
    def initialize(connection, logger)
      @connection = connection
      @logger     = logger
      connection.say 'hello!'
      connection.listen do |message|
        hear message
      end
    end
    
    def say(message)
      @connection.say message
      logger.debug "Said:  #{message}"
    end

    def hear(message)
      logger.debug "Heard: #{message}"
      if message.match(/\Amoneypenny/i)
        Responders.constants.each do |responder|
          response = eval("Responders::#{responder}").respond message
          say(response) if response
        end
      end
    end
  end
end
