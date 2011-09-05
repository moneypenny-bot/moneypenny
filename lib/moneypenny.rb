require 'rubygems'

dir = File.dirname(__FILE__)
$LOAD_PATH.unshift dir unless $LOAD_PATH.include?(dir)

require 'moneypenny/moneypenny'
require 'moneypenny/plugin'
require 'moneypenny/plugin_manager'
require 'moneypenny/responder'
require 'moneypenny/listener'
require 'moneypenny/connections/campfire'
require 'moneypenny/connections/echo'

#responders
require 'moneypenny/responders/weather'
require 'moneypenny/responders/wikipedia'
require 'moneypenny/responders/image'
require 'moneypenny/responders/help'
require 'moneypenny/responders/define'
require 'moneypenny/responders/version'

#listeners
require 'moneypenny/listeners/thats_what_she_said'
