require_relative '../config/environment'

twitter = TwitterApi.new
# File.open("./lib/tweets.txt", "r+") {|x| x.write(p twitter.collect_tweets_from("taylorswift13"))}

array = twitter.collect_tweets_from("taylorswift13")

tweet = array.sample


usernames = tweet.scan(/@(\w+)/)
remainder = tweet.split(/@(\w+)/)

names = usernames.map do |username|
  username = twitter.get_name(username)
end

swapped = remainder.map do |section|
  if usernames.include?([section])
    index = usernames.index([section])
    section = names[index]
  else
    section
  end
end

puts swapped.join
