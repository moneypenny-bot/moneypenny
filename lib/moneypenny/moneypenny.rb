module Moneypenny
  class Moneypenny
    attr_accessor :logger

    def initialize(config, logger)
      @config     = config
      @logger     = logger
    end

    def connection
      @connection ||= Connections::Campfire.new(
        @config[:campfire][:subdomain],
        @config[:campfire][:room],
        @config[:campfire][:api_token]
      )
    end

    def listen!
      connection.listen do |message|
        hear message
      end
    end

    def say(message)
      connection.say message
      logger.debug "Said:  #{message}"
    end

    def apologize
      say "Sorry, I do not know how to respond to that."
    end

    def matching_message(message)
      return unless message.match(/\A(mp|moneypenny)/i)
      message.gsub( /\A(mp|moneypenny)(\,|)/i, '' ).strip
    end

    def hear(message)
      logger.debug "Heard: #{message}"
      if matched_message = matching_message(message)
        responded = false
        Responder.all.each do |responder|
          response = responder.respond matched_message
          if response
            say response
            responded = true
          end
        end
        unless responded
          apologize
        end
      else
        Listener.all.each do |listener|
          if response = listener.respond( message )
            say response
          end
        end
      end
    end
  end
end
