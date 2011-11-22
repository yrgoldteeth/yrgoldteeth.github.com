require "#{ENV['HOME']}/code/yrgoldteeth.github.com/index_builder"
module Pusher
  extend self

  def push_it_real_good push_type
    IndexBuilder.rebuild!
    cmd = "cd #{ENV['HOME']}/code/yrgoldteeth.github.com && git fetch && git merge origin/master && "
    case push_type
    when :instapaper
      cmd += "git add ./.instapaper/existing_links ./instapaper.markdown _layouts/* && git commit -m'update instapaper favorites' " 
    when :mefi
      cmd += "git add ./.metafilter/existing_links _layouts/* && git commit -m'update mefi favorites' " 
    end
    cmd += "&& git push origin master"
    `#{cmd}`
  end
end 
