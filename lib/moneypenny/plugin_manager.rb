module Moneypenny
  class PluginManager
    def initialize(responders, listeners)
      @responders = responders
      @listeners = listeners
    end

    def respond( message )
      case message
      when /unload plugin (.*)/
        begin
          @responders.unload_plugin!($1) &&
          "Unloaded #{$1}"
        rescue ArgumentError
          @listeners.unload_plugin!($1)
          "Unloaded #{$1}"
        end
      when /load plugin (.*)/
        begin
          @responders.load_plugin!($1) &&
          "Loaded #{$1}"
        rescue ArgumentError
          @listeners.load_plugin!($1)
          "Loaded #{$1}"
        end
      when /load all plugins/
        @responders.load_all! &&
        @listeners.load_all!
          "Loaded all plugins"
      else
        false
      end
    rescue ArgumentError
      "Can't find that plugin"
    end
  end
end
