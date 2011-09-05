module Moneypenny
  ROOT_PATH = File.expand_path(File.join(File.dirname(__FILE__), '..', '..'))
  VERSION = (git_sha = `cd #{ROOT_PATH} && git rev-parse HEAD`.strip) == '' ? "v#{File.read(File.join(ROOT_PATH, 'VERSION')).strip}" : git_sha

  class Moneypenny
    attr_accessor :logger, :listeners, :responders

    def initialize(config, logger)
      @config     = config
      @logger     = logger
      self.responders  = Responder.new
      self.listeners  = Listener.new
      responders.load_all!
      listeners.load_all!
    end

    def connection
      return @connection if defined?(@connection)
      if @config[:connection] == 'echo'
        # hack fabulous
        # disable logging to STDOUT echobot, using STDOUT fucks with the listener
        if @logger.instance_variable_get("@logdev").dev == STDOUT
          @logger = NullLogger.new
        end
        @connection = Connections::Echo.new
      else
        @connection = Connections::Campfire.new(
          @config[:campfire][:subdomain],
          @config[:campfire][:room],
          @config[:campfire][:api_token]
        )
      end
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

    def respond_with(plugins, message)
      response = nil
      plugins.each do |responder|
        response = responder.respond message
        if response
          say response
        end
      end
      response
    end

    def hear(message)
      logger.debug "Heard: #{message}"
      if matched_message = matching_message(message)
        if response = PluginManager.new(responders, listeners).respond( message )
          say response
        elsif !respond_with(responders.loaded_plugins, matched_message)
          apologize
        end
      else
        respond_with(listeners.loaded_plugins, message)
      end
    end

  end
end
