$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'rspec'
require 'mocha'
require 'vcr'

require 'moneypenny'
require 'moneypenny/null_logger'

# Requires supporting files with custom matchers and macros, etc,
# in ./support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each {|f| require f}

RSpec.configure do |config|
  # config.mock_framework = :mocha
end

VCR.config do |config|
  config.cassette_library_dir     = 'spec/cassette_library'
  config.stub_with                :webmock
end

def new_moneypenny_instance
  Moneypenny::Moneypenny.new({}, nil)
end
