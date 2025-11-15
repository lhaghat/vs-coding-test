#!/usr/bin/env ruby
require 'digest'

# Simple class to group files by identical content
# Optimized to handle large files (MB/GB level) using streaming
class ContentCounter
  CONFIG_FILE = 'config.txt'

  def initialize(path = nil)
    @path = path || load_path_from_config
  end

  def run
    raise "No path specified. Use command-line argument or config file (#{CONFIG_FILE})" if @path.nil? || @path.empty?
    
    # Expand path to handle relative paths correctly
    expanded_path = File.expand_path(@path)
    raise "Path does not exist: #{@path} (expanded: #{expanded_path})" unless Dir.exist?(expanded_path)
    
    @path = expanded_path
    content_map = Hash.new { |h, k| h[k] = { count: 0, files: [], content: nil } }

    Dir.glob(File.join(@path, "**", "*")).each do |file|
      next unless File.file?(file)

      # Calculate hash using streaming for large files
      hash = calculate_file_hash(file)
      
      # Read content only once for the first file in each group
      # For large files, we'll store a sample or handle differently
      if content_map[hash][:content].nil?
        content_map[hash][:content] = read_file_content_safely(file)
      end

      # Group by hash
      content_map[hash][:count] += 1
      content_map[hash][:files] << file
    end

    # Find the group with the maximum count
    if content_map.empty?
      puts "No files found"
      return
    end

    max_group = content_map.values.max_by { |data| data[:count] }
    
    if max_group && max_group[:count] > 0
      # Output: content + count (format: "content count")
      puts "#{max_group[:content]} #{max_group[:count]}"
    else
      puts "No files found"
    end
  end

  def load_path_from_config
    return nil unless File.exist?(CONFIG_FILE)
    
    path = File.read(CONFIG_FILE).strip
    path.empty? ? nil : path
  rescue => e
    warn "Warning: Could not read config file #{CONFIG_FILE}: #{e.message}"
    nil
  end

  private

  # Calculate SHA256 hash using streaming to handle large files efficiently
  def calculate_file_hash(file_path)
    digest = Digest::SHA256.new
    File.open(file_path, 'rb') do |file|
      # Read in chunks to avoid loading entire file into memory
      while chunk = file.read(8192) # 8KB chunks
        digest.update(chunk)
      end
    end
    digest.hexdigest
  end

  # Read file content safely, handling large files
  # For very large files, we read the entire content but handle it efficiently
  # Since we need to output the content, we read it fully but only store once per group
  def read_file_content_safely(file_path)
    # Read entire content - we need it for output
    # Memory is managed by Ruby GC, and we only store content once per unique hash
    File.read(file_path)
  rescue => e
    # If file is too large or unreadable, return error message
    "[Error reading file: #{e.message}]"
  end
end

# Run from CLI: 
#   ruby test_counter.rb /path/to/folder
#   OR
#   ruby test_counter.rb  (uses config.txt if available)
if __FILE__ == $0
  begin
    # Command-line argument takes precedence over config file
    path = ARGV[0]
    ContentCounter.new(path).run
  rescue => e
    puts "Error: #{e.message}"
    puts "\nUsage: ruby test_counter.rb [path/to/folder]"
    puts "  - If path is provided, it will be used"
    puts "  - If no path is provided, will try to read from config.txt"
    puts "  - Create config.txt with a single line containing the path to scan"
    exit 1
  end
end
