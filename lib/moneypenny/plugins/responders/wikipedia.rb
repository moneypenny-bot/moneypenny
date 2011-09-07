require 'nokogiri'
require 'open-uri'
require 'cgi'

module Moneypenny
  module Plugins
    module Responders
      class Wikipedia < Responder
        def help
          [ 'what is Soap?', 'returns Wikipedia description for Soap' ]
        end
    
        def respond(message)
          if (query = message.match(/\Awhat\ is\ (.+)(\?|)\z/i))
            query = query[1]
            agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_0) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/13.0.782.107 Safari/535.1'
            response = open("http://en.wikipedia.org/w/api.php?action=opensearch&search=#{CGI::escape query}&format=xml&limit=1", 'User-Agent' => agent).read
            description = response.match(/\<Description\ xml\:space\=\"preserve\"\>(.+)\<\/Description\>/m)[1] rescue nil
            url         = response.match(/\<Url\ xml\:space\=\"preserve\"\>(.+)\<\/Url\>/m)[1]                 rescue nil
            if description
              description + " (#{url})"
            else
              "I couldn't find any information on #{query}."
            end
          else
            false
          end
        end
      end
    end
  end
end
    