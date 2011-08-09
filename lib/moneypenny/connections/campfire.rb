require 'tinder'
  
module Moneypenny
  module Connections
    class Campfire
      def initialize(subdomain, room, api_token)
        campfire = Tinder::Campfire.new subdomain, :token => api_token
        @id      = campfire.me['id']
        @room    = campfire.find_room_by_name room
      end
      
      def say(message)
        if message.include?("\n")
          @room.paste message
        else
          @room.speak message
        end
      end
      
      def listen(&block)
        @room.listen do |message|
          begin
            block.call(message['body']) if message['user']['id'] != @id
          rescue Exception => exception
            puts exception.to_s
          end
        end
      end
    end
  end
end
