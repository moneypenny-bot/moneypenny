module Moneypenny
  module HasConfig
    def self.included(base)
      base.extend ClassMethods
    end

    module ClassMethods
      def self.default_config
        {}
      end
    end

    def config
      config_subset = moneypenny.config
      self.class.to_s.split('::')[1..-1].each do |x|
        config_subset[x] ||= {}
        config_subset = config_subset[x]
      end
      self.class.default_config.merge config_subset
    end
  end
end
