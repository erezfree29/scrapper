require_relative '../lib/methods'
introduction
github_user = selection
url = "https://github.com/#{github_user}"
until url_exists?(url)
  puts 'invalid username or Github url'.red
  github_user = selection
  url = "https://github.com/#{github_user}"
end
doc = fetch_githb_data(github_user)
data_hash = create_data_hash(doc)
print_hash_info(data_hash)
save_to_csv(data_hash)

