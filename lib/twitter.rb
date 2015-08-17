require 'twitter'
require 'yaml'

class TwitterApi
  attr_reader :client, :get_name

  def initialize
    keys = YAML.load_file('application.yml')

    @client = Twitter::REST::Client.new do |config|
      config.consumer_key        = keys['CONSUMER_KEY']
      config.consumer_secret     = keys['CONSUMER_SECRET']
      config.access_token        = keys['ACCESS_TOKEN']
      config.access_token_secret = keys['ACCESS_TOKEN_SECRET']
    end
  end

  def most_recent_follower
    client.friends.first
  end

  def find_user_for(username)
    client.user(username)
    binding.pry
  end

  def find_followers_for(user)
    client.followers(user).first(10)
  end

  def get_name(username)
    client.user(username).name
  end

  def collect_tweets_from(user)
    client.search("from:#{user}").map {|tweet| "#{tweet.text}"}
    # binding.pry
  end

  def collect_with_max_id(collection=[], max_id=nil, &block)
    response = yield(max_id)
    collection += response
    response.empty? ? collection.flatten : collect_with_max_id(collection, response.last.id - 1, &block)
  end

  def get_all_tweets(user)
    collect_with_max_id do |max_id|
      options = {count: 200, include_rts: true}
      options[:max_id] = max_id unless max_id.nil?
      client.user_timeline(user, options)
    end
  end


end
