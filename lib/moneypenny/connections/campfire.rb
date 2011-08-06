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
        @room.speak message
      end
      
      def listen(&block)
        @room.listen do |message|
          block.call(message['body']) if message['user']['id'] != @id
        end
      end
    end
  end
end
