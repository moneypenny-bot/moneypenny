module Moneypenny
  class DefaultConfig
    def self.to_yaml
      default_config_hash.to_yaml
    end

    def self.classes_with_default_config
      classes = [ Connections::Connection,
                  Plugins::Listeners::Listener,
                  Plugins::Responders::Responder ].collect do |type|
        type.all.select{ |klass| klass.respond_to?(:default_config) }
      end
      classes.flatten!
      classes
    end

    def self.default_config_hash
      default_config = {}
      classes_with_default_config.each do |klass|
        x = default_config
        klass.to_s.split('::')[1..-1].each do |key|
          x = x[key] ||= {}
        end
        x.merge! klass.default_config
      end
      default_config
    end
  end
end
