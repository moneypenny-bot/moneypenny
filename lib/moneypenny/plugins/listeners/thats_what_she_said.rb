require 'twss'

module Moneypenny
  module Plugins
    module Listeners
      class ThatsWhatSheSaid < Listener
        def initialize(moneypenny)
          super
          TWSS.threshold = config['threshold']
        end
      
        def default_config
          { 'threshold' => 5.0 }
        end
        
        def respond(message)
          if TWSS(message)
            "That's what she said!"
          else
            false
          end
        end
      end
    end
  end
end
