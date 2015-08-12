require_relative '../config/environment'

twitter = TwitterApi.new
puts twitter.collect_tweets_from("KanyeOfficiaI").sample
