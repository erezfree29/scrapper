require 'bundler/setup'
Bundler.require
require 'open-uri'
require 'net/http'
require 'set'
require 'csv'
puts 'hello welcome to the github scrapper'.light_blue
puts "please enter a github's account username or enter the
the link to your git hub".light_blue
# get the input from the user and downcase it in order to run the include method on it
github_url = gets.chomp.downcase
# creating a url from the input
github_url = "https://github.com/#{github_url}" unless github_url.include? 'https://github.com/'

# A method for checking if url exists and valid
def url_exists?(github_url)
  url = URI.parse(github_url)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = true
  res = req.request_head(url.path)
  if res.is_a?(Net::HTTPRedirection)
    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL
  else
    res.code[0] != '4' # false if http code starts with 4 - error on your side.
  end
rescue Errno::ENOENT
  false # false if can't find the server
end

# keep asking for input until the url is valid
until url_exists?(github_url)
  puts 'not a valid user account or link please re-enter'.red
  github_url = gets.chomp.downcase
  github_url = if github_url.include?('https://github.com/')
                 github_url
               else
                 "https://github.com/#{github_url}"
               end
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
data[:github_account] = doc.search('meta')[2].attribute('content').value.split('-')[1]
data[:picture_url] = doc.css('img.avatar-user').find do |picture|
  picture.attributes['width'].value.include?('260')
end.attributes['src'].value

data[:about] = doc.search('meta')[2].attribute('content').value.split('-')[0]
pinned_repos_urls_array = []
doc.css('div.js-pinned-items-reorder-container a span').each do |span|
  pinned_repos_urls_array << "#{github_url}/#{span.attribute('title')}"
end
data[:pinned_repos_urls] = pinned_repos_urls_array
data[:conterbutions] = doc.css('h2.f4.text-normal')[1].content.split('c')[0].strip
def url_exist?(url_string)
  url = URI.parse(url_string)
  req = Net::HTTP.new(url.host, url.port)
  req.use_ssl = (url.scheme == 'https')
  path = url.path if url.path.present?
  res = req.request_head(path || '/')
  if res.is_a?(Net::HTTPRedirection)
    url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL
  else
    !%w[4 5].include?(res.code[0]) # Not from 4xx or 5xx families
  end
rescue Errno::ENOENT
  false # false if can't find the server
end

puts 'here is your information'.light_blue
puts 'Name'.yellow + ':' "#{data[:name]}".light_green
puts 'Git hub username'.yellow + ':' "#{data[:github_account]}".light_green
puts 'profile picture url'.yellow + ':' "#{data[:picture_url]}".light_green
puts 'about'.yellow + ':' "#{data[:about]}".light_green
puts 'number of conterbutions last'.yellow + ':' "#{data[:conterbutions]}".light_green
puts 'pinned repostitories'.light_blue
puts "1) #{data[:pinned_repos_urls][0]}".light_magenta
puts "2) #{data[:pinned_repos_urls][1]}".light_magenta
puts "3) #{data[:pinned_repos_urls][2]}".light_magenta
puts "4) #{data[:pinned_repos_urls][3]}".light_magenta
puts "5) #{data[:pinned_repos_urls][4]}".light_magenta
puts "6) #{data[:pinned_repos_urls][5]}".light_magenta

HEADERS = %w[
  dog
  cat
  donkey
].freeze

# wrting into a csv file
h = [data[:name], data[:github_account], data[:picture_url], data[:about]]
CSV.open('data.csv', 'w', write_headers: true, headers: h) do |csv|
  csv << [data[:name], data[:github_account], data[:picture_url], data[:about]]
  csv << ["number of last year's conterbutions #{data[:conterbutions]}"]
  csv << ['pinned repositories']
  csv << ["1) #{data[:pinned_repos_urls][0]}"]
  csv << ["2) #{data[:pinned_repos_urls][1]}"]
  csv << ["3) #{data[:pinned_repos_urls][2]}"]
  csv << ["4) #{data[:pinned_repos_urls][3]}"]
  csv << ["5) #{data[:pinned_repos_urls][4]}"]
  csv << ["6) #{data[:pinned_repos_urls][5]}"]
end
