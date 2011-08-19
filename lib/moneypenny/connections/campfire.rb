require 'tinder'
  
module Moneypenny
  module Connections
    class Campfire
      def initialize(subdomain, room_name, api_token)
        @subdomain = subdomain
        @room_name = room_name
        @api_token = api_token
      end
      
      def room
        unless @room
          campfire = Tinder::Campfire.new @subdomain, :token => @api_token
          @id      = campfire.me['id']
          @room    = campfire.find_room_by_name @room_name
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
