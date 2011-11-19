require 'crack'
if !defined?(Pusher) && File.exist?('./pusher.rb')
  require './pusher'
end
module GeneratorMethods
  def run
    get_existing_links
    parse_file
    write_links_to_file if new_links?
    clean_up if delete_after_complete
    @complete = true
  end
  
  def parse_file
    @links = Crack::XML.parse(File.open(file))['rss']['channel']['item']
  end

  def new_links?
    new_links.any? ? puts('New Links Found') : puts('No New Links')
    new_links.any?
  end

  def new_links
    links.map{|l|l['link']} - existing_links
  end
  
  def clean_up
    File.unlink file if delete_after_complete
  end
  
  def generate_li link
    pub_date = Time.parse(link['pubDate']).strftime('%e %b %Y')
    href = link['link']
    title = link['title']
    "    <li class='post-link'><span class='label'>#{pub_date}</span><br /><a href='#{href}'>#{title}</a></li>"
  end

  def generate_index_li link
    pub_date = Time.parse(link['pubDate']).strftime('%b %e %Y')
    href = link['link']
    title = link['title']
    "    <li class='sidebar'><span class='label'>#{pub_date}</span><br /><a href='#{href}'>#{title}</a></li>"
  end
  
  def get_existing_links
    if File.exist?(EXISTING_FILE)
      @existing_links = File.readlines(EXISTING_FILE).map(&:strip)
    end
  end
  
  def save_link link
    File.open(EXISTING_FILE,'a'){|f|f.puts link['link']} unless existing_links.include?(link['link'])
  end
end
