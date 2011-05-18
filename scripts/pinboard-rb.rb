require 'httparty'

class Pinboard
  include HTTParty
  base_uri 'https://api.pinboard.in/v1'
  attr_reader :auth

  def initialize user, pass
    @auth = {:username => user, :password => pass}
  end

  def all_posts opts={}
    opts.merge!({:basic_auth => auth})
    self.class.get('/posts/all', opts)
  end

  def posts_to_blog
    all_posts(:query => {:tag => 'to_blog'}).parsed_response["posts"]["post"]
  end
end
