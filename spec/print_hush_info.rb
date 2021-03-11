require_relative '../lib/methods'
doc = fetch_githb_data('mimipeshy')
data_hash = create_data_hash(doc)
print data_hash[:name]
print_hash_info(data_hash)
