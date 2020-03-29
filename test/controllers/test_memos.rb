# frozen_string_literal: true

require "rack/test"
require "nokogiri"
require "./test/controllers/base_controller"
require "./memos"
require "./models"

class MemosTest < TestBaseController
  ID_LIST_MEMOS = "id_list_memos"
  MEMOS_PAGE_TITLE = "メモ一覧"
  ID_BUTTON_NEW_MEMO = "id_button_new_memo"
  BUTTON_NEW_MEMO_TEXT = "メモを追加"
  BUTTON_NEW_MEMO_HREF = "/memos/new"
  ID_INPUT_NEW_MEMO_TITLE = "id_input_new_memo_title"
  NEW_MEMO_TITLE_PLACEHOLDER = "新しいメモのタイトル"

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

  def test_post_creates_new_memo
    assert_equal 0, Memo.all.size

    title = "Webアプリケーションに関連するツール"
    content = "- Webサーバ\n- Rack\n- Webアプリケーションフレームワーク"
    post "/memos", { "new_memo_title": title, "new_memo_content": content }

    assert_equal 1, Memo.all.size
    check_memo_object(FIRST_MEMO_ID, title, content, Memo.all.first)
  end

  def test_post_redirects_to_newly_created_memo
    json = JSON.dump({ title: "title", content: "content" })
    post("/memos", json, { CONTENT_TYPE: "application/json" })

    memo = Memo.all.first
    assert last_response.redirect?
    assert_match %r{/memos/#{memo.id}$}, last_response.location
  end

  private
    def extract_memo_titles(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.css("##{ID_LIST_MEMOS} li").map(&:text)
    end

    def extract_new_memo_button_text(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_BUTTON_NEW_MEMO}").text
    end

    def extract_new_memo_button_href(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_BUTTON_NEW_MEMO}")["href"]
    end

    def check_memo_object(expected_id, expected_title, expected_content, memo)
      assert_equal expected_id, memo.id
      assert_equal expected_title, memo.title
      assert_equal expected_content, memo.content
    end
end
