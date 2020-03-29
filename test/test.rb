# frozen_string_literal: true

require "rack/test"
require "nokogiri"
require "./test/base"
require "./memos"
require "./models"

class MemosTest < TestBase
  include Rack::Test::Methods

  ID_APPLICATION_NAME = "id_application_name"
  APPLICATION_NAME = "メモアプリ"
  ID_LIST_MEMOS = "id_list_memos"
  MEMOS_PAGE_TITLE = "メモ一覧"
  ID_BUTTON_NEW_MEMO = "id_button_new_memo"
  BUTTON_NEW_MEMO_TEXT = "メモを追加"
  BUTTON_NEW_MEMO_HREF = "/memos/new"
  ID_INPUT_NEW_MEMO_TITLE = "id_input_new_memo_title"
  NEW_MEMO_TITLE_PLACEHOLDER = "新しいメモのタイトル"

  def app
    Sinatra::Application
  end

  def test_access_to_route_redirected_to_memos_page
    get "/"

    assert last_response.redirect?
    assert_match %r{/memos$}, last_response.location
  end

  def test_memos_page_has_page_title
    get "/memos"

    title = extract_page_title(last_response.body)
    assert last_response.ok?
    assert_equal MEMOS_PAGE_TITLE, title
  end

  def test_memos_page_has_application_name
    get "/memos"

    application_name = extract_application_name(last_response.body)
    assert last_response.ok?
    assert_equal APPLICATION_NAME, application_name
  end

  def test_all_memos_are_displayed_on_the_memos_page
    memos = [
      Memo.create(title: "買い物に行く", content: "- レタスを買う\n- トマトを買う"),
      Memo.create(title: "勉強をする", content: "- ウェブアプリの勉強\n- Railsの勉強")
    ]
    get "/memos"

    memo_titles = extract_memo_titles(last_response.body)
    assert last_response.ok?
    assert_equal memos.map(&:title).sort, memo_titles.sort
  end

  def test_memos_page_has_button_to_create_new_memo
    get "/memos"

    html = last_response.body
    button_text = extract_new_memo_button_text(html)
    button_href = extract_new_memo_button_href(html)
    assert last_response.ok?
    assert_equal BUTTON_NEW_MEMO_TEXT, button_text
    assert_equal BUTTON_NEW_MEMO_HREF, button_href
  end

  private
    def extract_page_title(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.title
    end

    def extract_application_name(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_APPLICATION_NAME}").text
    end

    def extract_memo_titles(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.css("##{ID_LIST_MEMOS} li").map(&:text)
    end

    def extract_new_memo_title(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_INPUT_NEW_MEMO_TITLE}").text
    end

    def extract_new_memo_title_placeholder(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_INPUT_NEW_MEMO_TITLE}")["placeholder"]
    end

    def extract_new_memo_button_text(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_BUTTON_NEW_MEMO}").text
    end

    def extract_new_memo_button_href(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_BUTTON_NEW_MEMO}")["href"]
    end
end
