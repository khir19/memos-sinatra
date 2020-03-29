# frozen_string_literal: true

require "sinatra"
require "./models"

DEFAULT_LOCALS = {
  show_new_memo_button: false,
}

def locals(title:, **kwargs)
  DEFAULT_LOCALS.merge(kwargs, { title: title })
end

get "/" do
  redirect to("/memos")
end

get "/memos" do
  locals = locals(title: "メモ一覧", show_new_memo_button: true, memos: Memo.all)
  erb :memos, locals: locals, layout: :layout
end

post "/memos" do
  title = params["new_memo_title"]
  content = params["new_memo_content"]
  memo = Memo.create(title: title, content: content)
  redirect to("/memos/#{memo.id}")
end

get "/memos/new" do
  locals = locals(title: "新しいメモの作成")
  erb :memos_new, locals: locals, layout: :layout
end
