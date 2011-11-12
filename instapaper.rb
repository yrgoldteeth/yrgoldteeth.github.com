require 'crack'
PAGE_FILE = './instapaper.markdown'

class Instapaper
  attr_accessor :file, :existing_links, :delete_after_complete, :links
  
  def initialize file, delete_after_complete=false
    @file = file
    @delete_after_complete = delete_after_complete
    @existing_links = []
    @links = []
  end

  def run
    get_existing_links
    parse_file
    write_links_to_file if new_links?
    clean_up if delete_after_complete
  end

  def generate_li link
    pub_date = Time.parse(link['pubDate']).strftime('%b %e %Y')
    href = link['link']
    title = link['title']
    "<li class='post-link'><span class='label'>#{pub_date}</span><br /><a href='#{href}'>#{title}</a></li>"
  end

  def write_links_to_file
    `cp ./.instapaper/instapaper.markdown .`
    markdown_file = File.open(PAGE_FILE, 'a')
    links.each{|link| markdown_file.puts(generate_li(link));save_link(link)}
    markdown_file.puts('</ul>')
    markdown_file.puts('</div>')
  end

  def save_link link
    File.open('./.instapaper/existing_links','a'){|f|f.puts link['link']} unless existing_links.include?(link['link'])
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

  def get_existing_links
    if File.exist?('./.instapaper/existing_links')
      @existing_links = File.readlines('./.instapaper/existing_links').map(&:strip)
    end
  end
  
  def clean_up
    File.unlink file if delete_after_complete
  end
end

class Pusher
  def initialize
    cmd = "cd /home/ubuntu/code/yrgoldteeth.github.com && git add instapaper.markdown;"
    cmd += "git commit -m'update instapaper favorites';git push origin master"
    `#{cmd}`
  end
end

if File.exist?('./.instapaper/config')
  instapaper_url = File.readlines('./.instapaper/config').map(&:strip).first
  `wget #{instapaper_url} -O ipaper.rss`
  i = Instapaper.new('./ipaper.rss', true).run
end
