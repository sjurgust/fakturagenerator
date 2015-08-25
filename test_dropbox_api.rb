require 'dropbox_sdk'

client = DropboxClient.new("mk6zdX6kkmoAAAAAAAAAAZpOH-rmcRAsoqmWSEg2jmA")

#client.put_file('/xmltes2t.rb', open('./xmltes2t.rb'))

puts "linked account:", client.account_info().inspect