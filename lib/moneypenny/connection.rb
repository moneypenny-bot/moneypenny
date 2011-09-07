module Moneypenny
  module Connections
    class Connection
      include HasConfig

      attr_reader :moneypenny

      @registered_connections = []
  
      def self.inherited(subclass)
        @registered_connections << subclass
      end
  
      def self.all
        @registered_connections
      end

      def initialize(moneypenny)
        @moneypenny = moneypenny
      end
    end
  end
end
