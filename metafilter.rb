INDEX_FILE = "#{ENV['HOME']}/code/yrgoldteeth.github.com/.generators/mefi_recent"
EXISTING_FILE = "#{ENV['HOME']}/code/yrgoldteeth.github.com/.metafilter/existing_links"

require "#{ENV['HOME']}/code/yrgoldteeth.github.com/generator_methods"
class Metafilter
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
    index_file = File.open(INDEX_FILE, 'w')
    links.each{|link| save_link(link)}
    links[0,5].each{|link| index_file.puts(generate_index_li(link))}
    index_file.close
  end
  
end
cmd = "wget http://www.metafilter.com/favorites/128709/posts/rss -O #{ENV['HOME']}/tmp/mefi.rss"
`#{cmd}`
m = Metafilter.new("#{ENV['HOME']}/tmp/mefi.rss", true)
m.run
Pusher.push_it_real_good(:mefi) if m.new_links? && defined?(Pusher)
