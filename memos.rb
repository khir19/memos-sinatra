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
