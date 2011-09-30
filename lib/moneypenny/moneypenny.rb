module Moneypenny
  ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  VERSION = (git_sha = `cd #{ROOT_PATH} && git rev-parse HEAD`.strip) == '' ? "v#{File.read(File.join(ROOT_PATH, 'VERSION')).strip}" : git_sha

  class Moneypenny
    attr_accessor :config, :logger, :listeners, :responders

    def initialize(config, logger)
      @config = config
      @logger = logger
      @responders = Plugins::Responders::Responder.all.collect do |responder_class|
        responder_class.new self
      end
      @listeners = Plugins::Listeners::Listener.all.collect do |listeners_class|
        listeners_class.new self
      end
    end

    def connection
      @connection ||= Connections::Campfire.new self
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
      return unless message && message.match(/\A(mp|moneypenny)/i)
      message.gsub( /\A(mp|moneypenny)\,?\s*/i, '' ).strip
    end

    def hear(message)
      logger.debug "Heard: #{message}"
      if matched_message = matching_message(message)
        responded = false
        responders.each do |responder|
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
        listeners.each do |listener|
          if response = listener.respond( message )
            say response
          end
        end
      end
    end
  end
end
