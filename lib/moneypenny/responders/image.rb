require 'json'
require 'open-uri'
require 'cgi'

module Moneypenny
  class Image < Responder

    SAFE = 'on'
    RESULT_SIZE = 8
    VERSION = '1.0'

    def self.help
      [ 'find a kitten image', 'returns a random kitten picture from Google Image search' ]
    end

    def self.respond(message)
      case message
      when /^image me (.*)$/i
        image_response $1
      when /^find\ (a|an)\ (.+)\ (image|picture|photo)$/i
        image_response $2, "I couldn't find #{$1} #{$2} #{$3}."
      else
        false
      end
    end

    def self.image_response(query, error_msg = nil)
      images = JSON.parse(open(image_search_url(query)).read)['responseData']['results'] rescue []
      if images.tap { |i| i.compact! }.any?
        images.shuffle.first['url']
      else
        error_msg || "I was unable to find an image for that, sir!"
      end
    end
    private_class_method :image_response

    def self.image_search_url(query)
      "https://ajax.googleapis.com/ajax/services/search/images?safe=#{SAFE}&rsz=#{RESULT_SIZE}&v=#{VERSION}&q=#{CGI::escape query}"
    end
    private_class_method :image_search_url

  end
end
