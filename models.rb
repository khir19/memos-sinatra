# frozen_string_literal: true

require "./memos_config"

class Memo
  class << self
    def create(title:, content:)
      id = MemoIOUtils.next_id
      MemoIOUtils.next_id += 1
      memo = new(id: id, title: title, content: content)
      memo.save
    end

    def all
      MemoIOUtils.read_all
    end

    def find_by_id(id)
      MemoIOUtils.read(id)
    end
  end

  def initialize(id:, title:, content:)
    @id = id
    @title = title
    @content = content
  end

  attr_accessor :id, :title, :content

  def save
    MemoIOUtils.write(self)
    self
  end

  def delete
    MemoIOUtils.delete(id)
  end
end

class MemoIOUtils
  class << self
    def read(id)
      title, content = read_title_content(memo_file_path(id))
      Memo.new(id: id, title: title, content: content)
    end

    def read_all
      all_ids.map { |id| read(id) }
    end

    def write(memo)
      File.open(memo_file_path(memo.id), "w") do |f|
        f.puts "#{memo.title}\n\n#{memo.content}\n"
      end
    end

    def delete(id)
      FileUtils.rm(memo_file_path(id))
    end

    def exist?(id)
      File.exist?(memo_file_path(id))
    end

    def next_id
      File.read(MemosConfig.next_memo_id_path).to_i
    rescue Errno::ENOENT
      self.next_id = 0
    end

    def next_id=(next_id)
      File.open(MemosConfig.next_memo_id_path, "w") do |f|
        f.puts next_id
      end
    end

    private
      def read_title_content(memo_file_path)
        memo_file_content = File.read(memo_file_path)
        matches = /^(?<title>[^\n]*)\n\n(?<content>.*)\n$/m.match(memo_file_content)
        [matches[:title], matches[:content]]
      end

      def all_ids
        all_memo_file_paths.map { |path| parse_id(path) }
      end

      def all_memo_file_paths
        Dir.glob(File.join(MemosConfig.storage_directory_path, "*.txt"))
          .select { |path| /^\d+.txt$/.match?(File.basename(path)) }
      end

      def parse_id(memo_file_path)
        File.basename(memo_file_path)[/\d+/].to_i
      end

      def memo_file_path(id)
        File.join(MemosConfig.storage_directory_path, "#{id}.txt")
      end
  end
end
