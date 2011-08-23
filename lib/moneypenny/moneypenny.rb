module Moneypenny
  class Moneypenny
    attr_accessor :connection, :logger
    
    def initialize(connection, logger)
      @connection = connection
      @logger     = logger
      connection.say 'Hello, Moneypenny here at your service.'
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
      if message.match(/\A(mp|moneypenny)/i)
        message.gsub! /\A(mp|moneypenny)(\,|)/i, ''
        message.strip!
        responded = false
        Responders.constants.each do |responder|
          response = eval("Responders::#{responder}").respond message
          if response
            say response
            responded = true
          end 
        end
        unless responded
          say "Sorry, I do not know how to respond to that."
        end
      end
    end
  end
end
