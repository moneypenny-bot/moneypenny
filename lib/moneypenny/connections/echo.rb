module Moneypenny
  module Connections
    class Echo
      def say(message)
        puts 'Echobot: ' + message
      end

      def listen
        loop do
          message = gets
          next if message =~ /^Echobot: /
          yield message.to_s
        end
      end
    end
  end
end
