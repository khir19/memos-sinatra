# frozen_string_literal: true

require "./test/base"
require "./models"

class MemosTest < TestBase
  TEST_MEMO_TITLE_FSTRING = "title %d"
  TEST_MEMO_CONTENT_FSTRING = "This is a sample memo.\nThe id of this memo is %d."
  NUM_SAMPLE_MEMOS = 5

  def test_create_a_memo
    title = "Title"
    content = "Content"
    memo = Memo.create(title: title, content: content)

    check_memo_object(FIRST_MEMO_ID, title, content, memo)
    check_next_memo_id(memo.id + 1)
    check_memo_file_contents(memo.id, title, content)
  end

  def test_create_two_memos
    title1 = "Title1"
    content1 = "Content1"
    title2 = "Title2"
    content2 = "Content2"
    memo1 = Memo.create(title: title1, content: content1)
    memo2 = Memo.create(title: title2, content: content2)

    check_memo_object(FIRST_MEMO_ID, title1, content1, memo1)
    check_memo_object(FIRST_MEMO_ID + 1, title2, content2, memo2)
    check_next_memo_id(FIRST_MEMO_ID + 2)
    check_memo_file_contents(memo1.id, title1, content1)
    check_memo_file_contents(memo2.id, title2, content2)
  end

  def test_create_multitple_memos
    create_sample_memos(NUM_SAMPLE_MEMOS)
    check_next_memo_id(FIRST_MEMO_ID + NUM_SAMPLE_MEMOS)
    check_sample_memos(NUM_SAMPLE_MEMOS)
  end

  def test_find_memo_by_id
    create_sample_memos(NUM_SAMPLE_MEMOS)

    memo_id = 2
    expected_title = TEST_MEMO_TITLE_FSTRING % memo_id
    expected_content = TEST_MEMO_CONTENT_FSTRING % memo_id
    memo = Memo.find_by_id(memo_id)
    check_memo_object(memo_id, expected_title, expected_content, memo)
  end

  def test_get_all_memos
    create_sample_memos(NUM_SAMPLE_MEMOS)
    memos = Memo.all.sort { |m1, m2| m1.id <=> m2.id }

    memos.each.with_index do |memo, i|
      expected_id = FIRST_MEMO_ID + i
      expected_title = TEST_MEMO_TITLE_FSTRING % expected_id
      expected_content = TEST_MEMO_CONTENT_FSTRING % expected_id
      check_memo_object(expected_id, expected_title, expected_content, memo)
    end
  end

  def test_update_memo
    original_title = "Title"
    original_content = "Content"
    modified_title = "Modified Title"
    modified_content = "Modified\nContent"
    memo = Memo.create(title: original_title, content: original_content)
    memo.title = modified_title
    memo.content = modified_content
    memo.save

    check_memo_file_contents(memo.id, modified_title, modified_content)
  end

  def test_delete_memo
    title = "Title"
    content = "Content"
    memo = Memo.create(title: title, content: content)
    assert File.exist?(memo_file_path(memo.id))
    memo.delete
    assert !File.exist?(memo_file_path(memo.id))
  end

  private
    def check_memo_object(expected_id, expected_title, expected_content, memo)
      assert_equal expected_id, memo.id
      assert_equal expected_title, memo.title
      assert_equal expected_content, memo.content
    end

    def check_next_memo_id(expected)
      assert File.exist?(MemosConfig.next_memo_id_path)
      File.open(MemosConfig.next_memo_id_path) do |f|
        actual = f.read.to_i
        assert_equal expected, actual
      end
    end

    def check_memo_file_contents(id, title, content)
      expected = expected_memo_file_content(title, content)
      actual = read_memo_file_content(id)
      assert_equal expected, actual
    end

    def expected_memo_file_content(title, content)
      "#{title}\n\n#{content}\n"
    end

    def read_memo_file_content(id)
      File.read(memo_file_path(id))
    end

    def memo_file_path(id)
      File.join(MemosConfig.storage_directory_path, "#{id}.txt")
    end

    def create_sample_memos(n)
      n.times.map do |i|
        memo = Memo.create(title: "", content: "")
        memo.title = TEST_MEMO_TITLE_FSTRING % memo.id
        memo.content = TEST_MEMO_CONTENT_FSTRING % memo.id
        memo.save
      end
    end

    def check_sample_memos(n)
      n.times do |i|
        id = FIRST_MEMO_ID + i
        expected_content = expected_memo_file_content(
          TEST_MEMO_TITLE_FSTRING % id, TEST_MEMO_CONTENT_FSTRING % id)
        assert_equal expected_content, read_memo_file_content(id)
      end
    end
end
