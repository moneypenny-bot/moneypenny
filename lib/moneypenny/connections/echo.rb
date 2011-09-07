module Moneypenny
  module Connections
    class Echo < Connection
      def say(message)
        @listener.call message
      end
  
      def listen(&block)
        @listener = block
      end
    end
  end
end
