module Moneypenny
  module Connections
    class Connection
      include HasConfig

      attr_reader :moneypenny
    
      def initialize(moneypenny)
        @moneypenny = moneypenny
      end
    end
  end
end
