require 'rubygems'

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require 'moneypenny/moneypenny'

require 'moneypenny/mixins/has_config'

require 'moneypenny/connection'
require 'moneypenny/connections/campfire'
require 'moneypenny/connections/echo'

require 'moneypenny/plugin'
require 'moneypenny/plugins/listener'
require 'moneypenny/plugins/responder'

#responders
require 'moneypenny/plugins/responders/weather'
require 'moneypenny/plugins/responders/wikipedia'
require 'moneypenny/plugins/responders/image'
require 'moneypenny/plugins/responders/help'
require 'moneypenny/plugins/responders/define'
require 'moneypenny/plugins/responders/version'
require 'moneypenny/plugins/responders/issues'

#listeners
require 'moneypenny/plugins/listeners/thats_what_she_said'

require 'moneypenny/default_config'
