PAGE_FILE = './instapaper.markdown'
INDEX_FILE = './.generators/instapaper_recent'
EXISTING_FILE = './.metafilter/existing_links'

require './generator_methods'
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
    `cp ./.instapaper/instapaper.markdown .`
    markdown_file = File.open(PAGE_FILE, 'a')
    index_file = File.open(INDEX_FILE, 'w')
    links.each{|link| markdown_file.puts(generate_li(link));save_link(link)}
    links[0,4].each{|link| index_file.puts(generate_index_li(link))}
    markdown_file.puts('  </ul>')
    markdown_file.puts('</div>')
    markdown_file.close
  end
end

if File.exist?('./.instapaper/config')
  instapaper_url = File.readlines('./.instapaper/config').map(&:strip).first
  `wget #{instapaper_url} -O ipaper.rss`
  i = Instapaper.new('./ipaper.rss', true)
  i.run
  Pusher.push_it_real_good(:instapaper) if i.new_links? && defined?(Pusher)
end
