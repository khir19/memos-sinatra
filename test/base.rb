# frozen_string_literal: true

require "minitest/autorun"
require "./memos"

class TestBase < Minitest::Test
  TEST_STORAGE_DIRECTORY = "test/storage/"
  FIRST_MEMO_ID = 0

  def setup
    MemosConfig.storage_directory_path = TEST_STORAGE_DIRECTORY
    delete_files_in_directory(TEST_STORAGE_DIRECTORY, pattern: "*.txt")
    create_next_memo_id_file(next_id: FIRST_MEMO_ID)
  end

  def teardown
    delete_files_in_directory(TEST_STORAGE_DIRECTORY, pattern: "*.txt")
  end

  protected
    def delete_files_in_directory(directory, pattern: "**/*")
      Dir.glob(File.join(directory, pattern))
        .each { |path| FileUtils.rm(path) }
    end

    def create_next_memo_id_file(next_id: 0)
      File.open(MemosConfig.next_memo_id_path, "w") do |f|
        f.puts next_id
      end
    end
end
