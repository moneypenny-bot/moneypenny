require 'json'
require 'open-uri'
require 'cgi'

module Moneypenny
  module Plugins
    module Responders
      class Image < Responder
        def self.default_config
          { 'safe'        => 'on',
            'result_size' => 8,
            'version'     => '1.0' }
        end

        def help
          [ 'find a kitten image', 'returns a random kitten picture from Google Image search' ]
        end
    
        def respond(message)
          case message
          when /^image me (.*)$/i
            image_response $1
          when /^find\ (a|an)\ (.+)\ (image|picture|photo)$/i
            image_response $2, "I couldn't find #{$1} #{$2} #{$3}."
          else
            false
          end
        end

        private
          def image_response(query, error_msg = nil)
            images = JSON.parse(open(image_search_url(query)).read)['responseData']['results'] rescue []
            if images.tap { |i| i.compact! }.any?
              images.shuffle.first['url']
            else
              error_msg || "I was unable to find an image for that, sir!"
            end
          end
          
          def image_search_url(query)
            "https://ajax.googleapis.com/ajax/services/search/images?safe=#{config['safe']}&rsz=#{config['result_size']}&v=#{config['version']}&q=#{CGI::escape query}"
          end
      end
    end
  end
end
