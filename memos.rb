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

post "/memos" do
  title = params["new_memo_title"]
  content = params["new_memo_content"]
  memo = Memo.create(title: title, content: content)
  redirect to("/memos/#{memo.id}")
end

get "/memos/new" do
  erb :memos_new
end
