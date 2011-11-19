PAGE_FILE = "#{ENV['HOME']}/code/yrgoldteeth.github.com/instapaper.markdown"
INDEX_FILE = "#{ENV['HOME']}/code/yrgoldteeth.github.com/.generators/instapaper_recent"
EXISTING_FILE = "#{ENV['HOME']}/code/yrgoldteeth.github.com/.instapaper/existing_links"

require "#{ENV['HOME']}/code/yrgoldteeth.github.com/generator_methods"
class Instapaper
  include GeneratorMethods
  attr_accessor :file, :existing_links, :delete_after_complete, :links, :complete
  
  def initialize file, delete_after_complete=false
    @complete = false
    @file = file
    @delete_after_complete = delete_after_complete
    @existing_links = []
    @links = []
  end

  def write_links_to_file
    `cp #{ENV['HOME']}/code/yrgoldteeth.github.com/.instapaper/instapaper.markdown #{ENV['HOME']}/code/yrgoldteeth.github.com/`
    markdown_file = File.open(PAGE_FILE, 'a')
    index_file = File.open(INDEX_FILE, 'w')
    links.each{|link| markdown_file.puts(generate_li(link));save_link(link)}
    links[0,4].each{|link| index_file.puts(generate_index_li(link))}
    markdown_file.puts('  </ul>')
    markdown_file.puts('</div>')
    markdown_file.close
    index_file.close
  end
end

if File.exist?("#{ENV['HOME']}/code/yrgoldteeth.github.com/.instapaper/config")
  instapaper_url = File.readlines("#{ENV['HOME']}/code/yrgoldteeth.github.com/.instapaper/config").map(&:strip).first
  `wget #{instapaper_url} -O #{ENV['HOME']}/tmp/ipaper.rss`
  i = Instapaper.new("#{ENV['HOME']}/tmp/ipaper.rss", true)
  i.run
  Pusher.push_it_real_good(:instapaper) if i.new_links? && defined?(Pusher)
end
