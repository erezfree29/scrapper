require_relative '../lib/methods'
require 'open3'
describe 'selection method' do
  # the url will be given as a value which replaces the user input for the purpose of the test
  let(:url) { 'https://github.com/erezfree29/' }
  it "it will receive data from the user and return a Github username
  in case that the data includes a url it wll not include it" do
    expect(selection(url)).not_to include('https://github.com/')
  end
end

describe 'test the url_exists? method' do
  it 'will return false if the url does not exist' do
    expect(url_exists?('https://gist.github.com/beware_of_the_danger')).to be false
  end
  it 'will return true if the url exists' do
    expect(url_exists?('https://github.com/erezfree29/')).to be true
  end
end

describe 'test the fetch_githb_data method' do
  it 'will return an object of type Nokogiri for given git hub user' do
    expect(fetch_githb_data('erezfree29').class).to eql(Nokogiri::HTML::Document)
  end
end

describe 'test the create_data_hash method' do
  let(:doc) { fetch_githb_data('mimipeshy') }
  let(:data_hash) { create_data_hash(doc) }
  it 'will accept an object of typeNokogiri and create a hash with all the required keys' do
    expect(data_hash.keys).to eql(%i[name github_account picture_url about
                                     pinned_repos_urls conterbutions])
  end
  it "The values of the created hash should be of type string
  unless the key is :pinned_repos_urls" do
    # while iterating over the hash each value is an array,the first postion in the array
    # is the key and the second postion is the value
    def values_are_string?(data_hash)
      data_hash.each do |value|
        return false if value[1].class != (String) && value[0] != :pinned_repos_urls
      end
      true
    end
    expect(values_are_string?(data_hash)).to eql(true)
  end
end

describe 'test the print_hash_info method' do
  let(:doc) { fetch_githb_data('mimipeshy') }
  let(:data_hash) { create_data_hash(doc) }
  # get the curret library that the rspec command is going to be run from
  path = Open3.capture3('pwd')
  # convert the path to a string
  path = path.join(', ')
  if path.include?('spec')
    # The function print_hash_info is saved into the variable stdout
    stdout = Open3.capture3('ruby print_hush_info.rb')
    puts 'spec'
  else
    # The function print_hash_info is saved into the variable stdout
    stdout = Open3.capture3('ruby spec/print_hush_info.rb')
  end
  it 'prints information of a given hash' do
    # convert stdout into a string
    stdout = stdout.join(', ')
    expect(stdout).to include(data_hash[:name])
    expect(stdout).to include(data_hash[:github_account])
    expect(stdout).to include(data_hash[:picture_url])
    expect(stdout).to include(data_hash[:conterbutions])
    expect(stdout).to include(data_hash[:pinned_repos_urls][0])
    expect(stdout).to include(data_hash[:pinned_repos_urls][1])
    expect(stdout).to include(data_hash[:pinned_repos_urls][2])
    expect(stdout).to include(data_hash[:pinned_repos_urls][3])
    expect(stdout).to include(data_hash[:pinned_repos_urls][4])
    expect(stdout).to include(data_hash[:pinned_repos_urls][5])
  end
end

describe 'test the save_to_csv method' do
  let(:doc) { fetch_githb_data('mimipeshy') }
  let(:data_hash) { create_data_hash(doc) }
  it 'would create a csv file when given a hash' do
    expect(save_to_csv(data_hash).class).to eql(CSV)
  end
end
