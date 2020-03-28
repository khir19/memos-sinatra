# frozen_string_literal: true

require "rack/test"
require "./test/base"
require "./memos"
require "./models"

class MemosTest < TestBase
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  def test_access_to_route_redirected_to_memos_page
    get "/"

    assert last_response.redirect?
    assert_match /\/memos$/, last_response.location
  end

  def test_all_memos_are_displayed_on_the_memos_page
    memos = [
      Memo.create(title: "買い物に行く", content: "- レタスを買う\n- トマトを買う"),
      Memo.create(title: "勉強をする", content: "- ウェブアプリの勉強\n- Railsの勉強")
    ]
    get "/memos"

    assert last_response.ok?
    memos.each do |memo|
      assert_includes last_response.body, memo.title
    end
  end
end
