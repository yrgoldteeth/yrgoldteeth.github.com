require 'httparty'

class Pinboard
  include HTTParty
  base_uri 'https://api.pinboard.in/v1'
  attr_reader :auth

  def initialize
    config = YAML::load(File.read(File.join(ENV['HOME'], '.pinboard')))
    @auth = {:username => config['username'], :password => config['password']}
  end

  def all_posts opts={}
    opts.merge!({:basic_auth => auth})
    self.class.get('/posts/all', opts)
  end

  def posts_to_blog
    all_posts(:query => {:tag => 'to_blog'}).parsed_response["posts"]["post"]
  end

  def add_post opts={}
    opts.merge!({:basic_auth => auth})
    self.class.get('/posts/add', opts)
  end

  def set_post_to_blogged post
    _tags = post['tag'].split(' ') - ['to_blog'] + ['blogged']
    add_post(:query => {:url => post['href'], 
                        :description => post['description'],
                        :extended => post['extended'],
                        :dt => post['time'],
                        :tags => _tags.join(' ') })
  end
end

class Postmaker
  attr_reader :posts, :pinboard

  def initialize
    @pinboard = Pinboard.new
    @posts = pinboard.posts_to_blog
    return true unless posts && posts.any?
    case posts
    when Hash
      generate_post(posts)
    when Array
      posts.each {|p| generate_post(p)}
    end
  end

  def generate_post post
    date = Time.parse post['time']
    uri  = URI.parse post['href']
    file_path = '/home/ubuntu/code/yrgoldteeth.github.com/_posts/'
    file_name = file_path + "#{date.strftime('%Y-%m-%d')}-#{uri.host}-from-pinboard.markdown"
    file = File.open(file_name, 'a')
    file.puts '---'
    file.puts 'layout: post'
    file.puts "title: #{post['description'].gsub(':','-')}"
    file.puts '---'
    file.puts ''
    file.puts '## {{ page.title }}'
    file.puts ''
    post['extended'].each_line do |line|
      file.puts "> #{line}  "
    end
    file.puts ''
    file.puts "<strong><a href='#{post['href']}'>#{post['href']}</a></strong>"
    file.puts ''
    file.puts 'Post automatically generated from my <a href="http://pinboard.in/u:ndfine">pinboard</a>'
    file.close
    pinboard.set_post_to_blogged post
  end

end

class Pusher
  def initialize
    cmd = "cd /home/ubuntu/code/yrgoldteeth.github.com && git add _posts/*;"
    cmd += "git commit -m'add autogenerated posts(s) from pinboard';git push origin master"
    `#{cmd}`
  end
end

p = Postmaker.new
if p.posts && p.posts.any?
  Pusher.new
end
