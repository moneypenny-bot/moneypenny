require 'tinder'

module Moneypenny
  module Connections
    class Campfire < Connection
      def self.default_config
        { 'subdomain' => nil,
          'room_name' => nil,
          'api_token' => nil }
      end
  
      def room
        unless @room
          campfire = Tinder::Campfire.new config['subdomain'], :token => config['api_token']
          @id      = campfire.me['id']
          @room    = campfire.find_room_by_name config['room_name']
          raise 'Unknown Room' unless @room
        end
        @room
      end
  
      def reconnect
        @room = nil
        room
      end
  
      def say(message)
        if message.include?("\n")
          room.paste message
        else
          room.speak message
        end
      end
  
      def listen(&block)
        begin
          room.listen do |message|
            begin
              block.call(message['body']) if message['user']['id'] != @id
            rescue Exception => exception
              puts exception.to_s
              puts "\t#{exception.backtrace.join "\n\t"}"
            end
          end
        rescue Tinder::ListenFailed
          reconnect
          retry
        end
      end
    end
  end
end
