require 'crack'
class PinboardTags
  attr_accessor :auth
  
  def initialize 
    config = YAML::load(File.read(File.join(ENV['HOME'], '.pinboard')))
    @auth = {:username => config['username'], :password => config['password']}
  end

  def tags
    @tags ||= Hash[*(Crack::XML.parse(File.open(file))['tags']['tag'].map{|t|[[t['tag']], t['count'].to_i]}.flatten)]
  end

  def top_25
    @top_25 ||= Hash[*(tags.sort_by{|k,v|v}.reverse[0,25].flatten)]
  end

  private
  def save_file_location
    "#{ENV['HOME']}/.pinboardtags.xml"
  end
  
  def file
    if File.exist?(save_file_location) && File.ctime(save_file_location) < Time.now - 68400
      save_file_location
    else
      download_file
    end
  end

  def download_file
    `wget https://#{auth[:username]}:#{auth[:password]}@api.pinboard.in/v1/tags/get -q -O #{save_file_location} --no-check-certificate`
    save_file_location
  end

end
