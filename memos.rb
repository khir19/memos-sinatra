# frozen_string_literal: true

require "sinatra"
require "./models"

get "/" do
  redirect to("/memos")
end

get "/memos" do
  memos = Memo.all
  erb :memos, locals: { memos: memos }
end

module MemosConfig
  DEFAULT_STORAGE_DIRECTORY = "storage"
  DEFAULT_NEXT_MEMO_ID_FILENAME = "next_memo_id.txt"

  class << self
    attr_writer :storage_directory_path, :next_memo_id_filename

    def storage_directory_path
      @storage_directory_path ||= DEFAULT_STORAGE_DIRECTORY
    end

    def next_memo_id_filename
      @next_memo_id_filename ||= DEFAULT_NEXT_MEMO_ID_FILENAME
    end

    def next_memo_id_path
      File.join(storage_directory_path, next_memo_id_filename)
    end
  end
end
