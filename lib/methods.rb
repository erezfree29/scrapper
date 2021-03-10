require 'bundler/setup'
Bundler.require
require 'open-uri'
require 'net/http'
require 'set'
require 'csv'
# introduction of the Github tool
def introduction
  puts 'hello welcome to the github scrapper'.light_blue
  puts 'this tool is desgined to for fetching data from github quickly and saving it to a csv file'.light_blue
end

# get selection from user
def selection(github_url = nil)
  puts 'please enter a Github user name or a Github url'.light_green
  github_url = if github_url.nil?
                 gets.chomp.downcase
               else
                 github_url.downcase
               end
  # in case that the input is the full url extract only the username
  return github_url.split('m/')[1] if
  github_url.include? 'https://github.com/'

  github_url
end

# check if url is valid and exits
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

def fetch_githb_data(github_user)
  # # get plain text of html
  html = open("https://github.com/#{github_user}")
  # make plain text into type doc
  Nokogiri::HTML(html)
end

# put the data into a data hash
def create_data_hash(doc)
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
    pinned_repos_urls_array << "https://github.com/#{data[:github_account]}#{span.attribute('title')}"
  end
  data[:pinned_repos_urls] = pinned_repos_urls_array
  data[:conterbutions] = doc.css('h2.f4.text-normal')[1].content.split('c')[0].strip
  data
end

# print information of a given hash
def print_hash_info(data)
  puts 'Here is your information.'.light_blue
  puts "#{'Name'.yellow}:#{(data[:github_account]).to_s.light_green}"
  puts 'Git hub username'.yellow + ':' "#{data[:github_account]}".light_green
  puts 'profile picture url'.yellow + ':' "#{data[:picture_url]}".light_green
  puts 'about'.yellow + ':' "#{data[:about]}".light_green
  puts 'number of conterbutions last'.yellow + ':' "#{data[:conterbutions]}".light_green
  puts 'pinned repostitories'.light_blue
  puts "#{data[:pinned_repos_urls][0]} ,#{data[:pinned_repos_urls][1]},#{data[:pinned_repos_urls][2]}".light_magenta
  puts "#{data[:pinned_repos_urls][3]} ,#{data[:pinned_repos_urls][4]},#{data[:pinned_repos_urls][5]}".light_magenta
end

# save information to a csv file from a given hash
def save_to_csv(data)
  h = %w[name github_account picture_url about]
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
end
