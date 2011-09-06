module Moneypenny
  module HasConfig
    def default_config
      {}
    end

    def config
      config_subset = moneypenny.config
      self.class.to_s.split('::')[1..-1].each do |x|
        config_subset[x] ||= {}
        config_subset = config_subset[x]
      end
      default_config.merge config_subset
    end
  end
end
