require 'json'
require 'open-uri'
require 'cgi'

module Moneypenny
  module Responders
    class Image
      def self.respond(message)
        if (match = message.match(/\Afind\ (a|an)\ (.+)\ image\z/i))
          query = match[2]
          url = "https://ajax.googleapis.com/ajax/services/search/images?safe=off&rsz=8&v=1.0&q=#{CGI::escape query}"
          images = JSON.parse(open(url).read)['responseData']['results'] rescue []
          if images.any?
            images[rand(8)]['url']
          else
            "I couldn't find #{match[1]} #{match[2]} image."
          end
        else
          false
        end
      end
    end
  end
end