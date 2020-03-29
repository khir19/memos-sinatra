# frozen_string_literal: true

require "rack/test"
require "nokogiri"
require "./test/base"
require "./memos"
require "./models"

class TestBaseController < TestBase
  include Rack::Test::Methods

  ID_APPLICATION_NAME = "id_application_name"
  APPLICATION_NAME = "メモアプリ"

  def app
    Sinatra::Application
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
end
