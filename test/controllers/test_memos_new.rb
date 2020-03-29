# frozen_string_literal: true

require "rack/test"
require "nokogiri"
require "./test/controllers/base_controller"
require "./memos"
require "./models"

class MemosNewTest < TestBaseController
  ID_FORM_NEW_MEMO = "id_form_new_memo"
  ID_INPUT_NEW_MEMO_TITLE = "id_input_new_memo_title"
  ID_INPUT_NEW_MEMO_CONTENT = "id_input_new_memo_content"
  ID_BUTTON_SUBMIT_NEW_MEMO = "id_button_submit_new_memo"

  def test_memos_page_has_page_title
    get "/memos/new"

    title = extract_page_title(last_response.body)
    assert last_response.ok?
    assert_equal "新しいメモの作成", title
  end

  def test_memos_page_has_application_name
    get "/memos/new"

    application_name = extract_application_name(last_response.body)
    assert last_response.ok?
    assert_equal APPLICATION_NAME, application_name
  end

  def test_memos_new_page_has_text_input_for_memo_title
    get "/memos/new"

    html = last_response.body
    title = extract_new_memo_title(html)
    placeholder = extract_new_memo_title_placeholder(html)
    assert last_response.ok?
    assert_equal "", title
    assert_equal "新しいメモのタイトル", placeholder
  end

  def test_memos_new_page_has_text_input_for_memo_content
    get "/memos/new"

    html = last_response.body
    content = extract_new_memo_content(html)
    placeholder = extract_new_memo_content_placeholder(html)
    assert last_response.ok?
    assert_equal "", content
    assert_equal "新しいメモの内容", placeholder
  end

  def test_memos_new_page_has_button_to_submit_new_memo
    get "/memos/new"

    html = last_response.body
    action, method = extract_form_action_and_method(html)
    button_text = extract_submit_button_text(html)
    assert last_response.ok?
    assert_equal "/memos", action
    assert_equal "POST", method
    assert_equal "送信", button_text
  end

  private
    def extract_new_memo_title(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_INPUT_NEW_MEMO_TITLE}").text
    end

    def extract_new_memo_title_placeholder(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_INPUT_NEW_MEMO_TITLE}")["placeholder"]
    end

    def extract_new_memo_content(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_INPUT_NEW_MEMO_CONTENT}").text
    end

    def extract_new_memo_content_placeholder(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_INPUT_NEW_MEMO_CONTENT}")["placeholder"]
    end

    def extract_form_action_and_method(html_string)
      html_doc = Nokogiri::HTML(html_string)
      form = html_doc.at_css("##{ID_FORM_NEW_MEMO}")
      [form["action"], form["method"]]
    end

    def extract_submit_button_text(html_string)
      html_doc = Nokogiri::HTML(html_string)
      html_doc.at_css("##{ID_BUTTON_SUBMIT_NEW_MEMO}").text
    end
end
