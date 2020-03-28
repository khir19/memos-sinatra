# frozen_string_literal: true

require "minitest/autorun"
require "rack/test"
require "./memos"

class MemosTest < Minitest::Test
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_sinatra_is_working
    get "/"
    assert_equal "Hello, 世界!", last_response.body
  end
end
