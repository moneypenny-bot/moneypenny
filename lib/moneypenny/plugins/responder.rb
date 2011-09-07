module Moneypenny
  module Plugins
    module Responders
      class Responder < Plugin
        @registered_responders = []
    
        def self.inherited(subclass)
          @registered_responders << subclass
        end
    
        def self.all
          @registered_responders
        end
      end
    end
  end
end
    