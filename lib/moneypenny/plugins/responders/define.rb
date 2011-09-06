require 'nokogiri'
require 'open-uri'
require 'cgi'

module Moneypenny
  module Plugins
    module Responders
      class Define < Responder
        def help
          [ 'define space', 'returns Urban Dictionary definition for space' ]
        end
        
        def respond(message)
          if (query = message.match(/\Adefine\ (.+)\z/i))
            term        = query[1]
            definitions = definitions_for_term term
            if definitions.any?
              definition, url = definitions.first
              "#{term} is #{definition} (#{url})"
            else
              "I couldn't find the definition for #{term}."
            end
          else
            false
          end
        end
        
        def url_for_term(term)
          "http://www.urbandictionary.com/define.php?term=#{CGI::escape term}"
        end
        
        def data_for_term(term)
          open url_for_term(term)
        end
        
        def nokogiri_for_term(term)
          Nokogiri::HTML data_for_term(term)
        end
        
        def definitions_for_term(term)
          elements = nokogiri_for_term(term).css 'div.definition'
          url      = url_for_term term
          elements.collect do |element|
            [ element.text, "#{url}&defid=#{element.parent['id'].split('_')[1]}" ]
          end
        end
      end
    end
  end
end
