module Moneypenny
  class Plugin
    attr_accessor :loaded_plugins

    def initialize(options = {})
      self.loaded_plugins = Set.new
    end

    def load_plugin!(plugin_name)
      self.loaded_plugins << find_plugin_by_name(plugin_name)
    end

    def load_all!
      self.class.all.each do |p|
        load_plugin!(p.name)
      end
    end

    def find_plugin_by_name(plugin_name)
      plugin = self.class.all.find {|p| p.name == plugin_name}
      raise ArgumentError, "Unknown plugin: #{plugin_name}" if plugin.nil?
      plugin
    end

    def unload_plugin!(plugin_name)
      self.loaded_plugins.delete find_plugin_by_name(plugin_name)
    end
  end
end
