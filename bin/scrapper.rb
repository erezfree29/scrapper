require 'bundler/setup'
Bundler.require
require 'open-uri'
require "net/http"
require 'set'
require "csv"
puts "hello welcome to the github scrapper".light_blue
puts "please enter a github's account username or enter the 
the link to your git hub".light_blue
# get the input from the user and downcase it in order to run the include method on it
github_url = gets.chomp.downcase 
# creating a url from the input
github_url.include?("https://github.com/") ? (github_url = github_url) : 
(github_url = "https://github.com/" + github_url)

# A method for checking if url exists and valid
def url_exists?(github_url)
  url = URI.parse(github_url)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = true
  res = req.request_head(url.path)
  if res.kind_of?(Net::HTTPRedirection)
    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
  else
    res.code[0] != "4" #false if http code starts with 4 - error on your side.
  end
 rescue Errno::ENOENT
  false #false if can't find the server
end

# keep asking for input until the url is valid
until url_exists?(github_url)
  puts "not a valid user account or link please re-enter".red
  github_url = gets.chomp.downcase
  github_url.include?("https://github.com/") ? (github_url = github_url) : 
 (github_url = "https://github.com/" + github_url)
end

# get plain text of html
html = open(github_url)
# make plain text into type doc
doc = Nokogiri::HTML(html)
# get data from url
data = {}
doc.css('span.p-name').each do |link|
     data[:name] = link.content
end
data[:github_account] = doc.search("meta")[2].attribute("content").value.split('-')[1]
data[:picture_url] = doc.css("img.avatar-user").find{|picture| 
picture.attributes["width"].value.include?("260")}.attributes["src"].value    

data[:about] = doc.search("meta")[2].attribute("content").value.split('-')[0]
pinned_repos_urls_array = []
doc.css("div.js-pinned-items-reorder-container a span").each {|span|
pinned_repos_urls_array <<  github_url + '/' + span.attribute("title")}
data[:pinned_repos_urls] = pinned_repos_urls_array
data[:conterbutions] = doc.css("h2.f4.text-normal")[1].content.split('c')[0]
def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
  path = url.path if url.path.present?
  res = req.request_head(path || '/')
  if res.kind_of?(Net::HTTPRedirection)
    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL 
  else
    ! %W(4 5).include?(res.code[0]) # Not from 4xx or 5xx families
  end
rescue Errno::ENOENT
  false #false if can't find the server
end

puts "here is your information".light_blue
puts "Name".yellow +  ':' "#{data[:name]}".light_green
puts "Git hub username".yellow +  ':' "#{data[:github_account]}".light_green
puts "profile picture url".yellow +  ':' "#{data[:picture_url]}".light_green
puts "about".yellow +  ':' "#{data[:about]}".light_green
puts "number of last year's conterbutions".yellow +  ':' "#{data[:conterbutions]}".light_green
puts "pinned repostitories".light_blue
puts "1) #{data[:pinned_repos_urls][0]}".light_magenta
puts "2) #{data[:pinned_repos_urls][1]}".light_magenta
puts "3) #{data[:pinned_repos_urls][2]}".light_magenta
puts "4) #{data[:pinned_repos_urls][3]}".light_magenta
puts "5) #{data[:pinned_repos_urls][4]}".light_magenta
puts "6) #{data[:pinned_repos_urls][5]}".light_magenta

HEADERS = [
  'dog',
  'cat',
  'donkey'
]

# wrting into a csv file
h = ["name","erez_name","pictur_url","about"]
CSV.open("data.csv", "w",:write_headers=> true,headers: h ) do |csv|
  csv <<  [data[:name], data[:github_account],data[:picture_url],data[:about]]
  csv << ["number of last year's conterbutions #{data[:conterbutions]}"]
  csv << ["pinned repositories"]
  csv << ["1) #{data[:pinned_repos_urls][0]}"]
  csv << ["2) #{data[:pinned_repos_urls][1]}"]
  csv << ["3) #{data[:pinned_repos_urls][2]}"]
  csv << ["4) #{data[:pinned_repos_urls][3]}"]
  csv << ["5) #{data[:pinned_repos_urls][4]}"]
  csv << ["6) #{data[:pinned_repos_urls][5]}"]
end



















# class GithubSpider < Kimurai::Base
#   @name = "github_spider"
#   @engine = :selenium_chrome
#   @start_urls = ["https://github.com/search?q=Ruby%20Web%20Scraping"]
#   @config = {
#     user_agent: "Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/68.0.3440.84 Safari/537.36",
#     before_request: { delay: 4..7 }
#   }

#   def parse(response, url:, data: {})
#     response.xpath("//ul[@class='repo-list']/div//h3/a").each do |a|
#       request_to :parse_repo_page, url: absolute_url(a[:href], base: url)
#     end

#     if next_page = response.at_xpath("//a[@class='next_page']")
#       request_to :parse, url: absolute_url(next_page[:href], base: url)
#     end
#   end

#   def parse_repo_page(response, url:, data: {})
#     item = {}

#     item[:owner] = response.xpath("//h1//a[@rel='author']").text
#     item[:repo_name] = response.xpath("//h1/strong[@itemprop='name']/a").text
#     item[:repo_url] = url
#     item[:description] = response.xpath("//span[@itemprop='about']").text.squish
#     item[:tags] = response.xpath("//div[@id='topics-list-container']/div/a").map { |a| a.text.squish }
#     item[:watch_count] = response.xpath("//ul[@class='pagehead-actions']/li[contains(., 'Watch')]/a[2]").text.squish
#     item[:star_count] = response.xpath("//ul[@class='pagehead-actions']/li[contains(., 'Star')]/a[2]").text.squish
#     item[:fork_count] = response.xpath("//ul[@class='pagehead-actions']/li[contains(., 'Fork')]/a[2]").text.squish
#     item[:last_commit] = response.xpath("//span[@itemprop='dateModified']/*").text

#     save_to "results.json", item, format: :pretty_json
#   end
# end

# GithubSpider.crawl!

