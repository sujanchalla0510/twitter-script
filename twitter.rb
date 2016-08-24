require 'rubygems'
require 'json'
require 'httparty'
require 'oauth'

#gets first arguemnt from terminal
hash_tag = ARGV.first
#checks if hashtag is passed in argument
if hash_tag.nil?
  puts "Please provide tag  Example rails"
  exit
end

# this will generate and return the acces token
def get_access_token(oauth_token, oauth_token_secret)
  consumer = OAuth::Consumer.new("1C4cuauobW97RJqlZSb9Hkb7J","T23XDsA6dkHuxuoKIUd3EW1cDzPKzIcCwWnmEbGIKU5ZVAuyyk", { :site => "https://api.twitter.com", :scheme => :header })
  token_hash = { :oauth_token => oauth_token, :oauth_token_secret => oauth_token_secret }
  access_token = OAuth::AccessToken.from_hash(consumer, token_hash )
  return access_token
end

token = get_access_token("765682240038633472-Q55T4pV9rb6qSIeRXg2EpcPszeyKr8Z", "tWnXynKKJT9X17BLyxHIZHZpjTZqfM8VehgWZ1NvyREOj")
response = token.request(:get, "https://api.twitter.com/1.1/search/tweets.json?q=%23#{hash_tag}&result_type=recent&count=100") # count=100 give 100 tweets and result_type=recent gives recent tweets
hash_response = JSON.parse(response.body) # Json response for the query
urls=[] 
hash_response["statuses"].each do |hash| 
  urls << hash["text"].match(/\bhttps?:\/\/\S+\b/) # filters using regular expression
  media=[]
  media << hash["entities"]["media"]
    media.each do |media_urls|
      urls << media_urls.to_s.match(/\bhttps?:\/\/\S+\b/)
    end
end

urls = urls.uniq # make urls unique
puts urls # display urls
