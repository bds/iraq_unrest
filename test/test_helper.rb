require 'iraq_unrest'      # Require our gem so we can test it
require 'byebug'
require 'ap'

require 'webmock/minitest'
WebMock.allow_net_connect! # Test against the live data source

require 'vcr'
VCR.configure do |c|
 c.cassette_library_dir = 'test/fixtures/vcr_cassettes'
 c.hook_into :webmock
end

require 'minitest/spec'
require 'minitest/unit'
require 'minitest/pride'
require 'minitest/autorun' # Actually runs the tests
