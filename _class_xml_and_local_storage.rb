#coding: iso-8859-1
require 'nokogiri'
#require 'aws/s3'


#$nye_jobber = [{ :job_id => "KJJDF-5VDV-5-42334-FDFDF" , :filename_in => "jhsjjjjjs", :out_path => "d:/encode", :src_type => "qtref", :dst_type => "local_mp4", :started => "2013-09-13 00:00", :status => "starting" }]
class XmlAndLokalLagring
		attr_accessor :eksisterende_linjer, :nye_linjer, :archive_path, :archive_name, :xpath_array, :xpath

		def initialize(archive_name, xpath_array)
			@eksisterende_linjer, @nye_linjer = [], []
						
			@archive_path = 'bucket_sjur'
			@archive_name = archive_name
			@xpath_array = xpath_array
			@xpath = bygg_xpath
			
		end
		def bygg_xpath
			xpathstr='//'
			xpath_array.each {|x| xpathstr += "#{x}/"}
			return xpathstr.chop
		end
		def _linjer
			@eksisterende_linjer
		end
		def _leggtil_linjer(nye_linjer, clear_first=false)
			@eksisterende_linjer = [] if clear_first
			nye_linjer.length.times {|i| @eksisterende_linjer << nye_linjer[i] }
			#lagre_til_aw_sky
			lagre_lokalt()
		end
		def _oppdater_linje(ny_data, id)

			4.times {|i| @eksisterende_linjer[id]["linje#{i+1}".to_sym] = ny_data[i] }

			#@eksisterende_linjer
			#lagre_til_aw_sky
			lagre_lokalt()
		end		
		def _slett_linje(index)
			@eksisterende_linjer.delete_at(index)
			#@eksisterende_linjer.each {|l|
			#	p l
			#}
			#lagre_til_aw_sky
			lagre_lokalt()
		end		
		def _hent_linjer_fra_lokal_lagring_og_vis
			# kople til amazon web services
			doc = Nokogiri::XML(hent_lokalt())
			# monteringpunkt xml for a hente ut linjer/jobber
			@eksisterende_linjer = _to_array_ doc.xpath(@xpath)
			# puts '-----------------'
			
			# @eksisterende_linjer.each {|l|
			# 	p l
			# 	puts
			# }
		end
		def _to_xml_(content)
			b = Nokogiri::XML::Builder.new(:encoding => 'UTF-8') do |xml|
				# bygg xml struktur
				xml.send(:"#{@xpath_array[0]}") {
					content.each { |m|
						xml.send(:"#{@xpath_array[1]}") {
							keys = m.keys
							values = m.values
						  	keys.count.times {|i|
							  	xml.send(:"#{keys[i]}", values[i])
							   }
					}
					}
				}
			end
			return b.to_xml
		end
		def _to_array_(xml_content)
			# tmp array 
			_linjer = []

			xml_content.each { |m|
				keys, values = [], []
				m.element_children.each {|child|
					keys << child.name.to_sym
					values << child.text.to_s
				}
				# en smart funksjon som bygger om 2 arrays til en hash, kays => values
				_linjer << Hash[keys.zip values]
			}
			return _linjer
		end
		
		def lagre_lokalt 
			this_filepath = File.dirname(__FILE__)
			save_path = File.join(this_filepath, @archive_path) + File::SEPARATOR
			File.open(save_path + @archive_name, 'w') { |file| file.write(_to_xml_(@eksisterende_linjer)) }	
		end
		def hent_lokalt 
			this_filepath = File.dirname(__FILE__)
			load_path = File.join(this_filepath, @archive_path) + File::SEPARATOR
			file = nil
			begin
    			file = File.new(load_path + @archive_name, "r")
    		rescue => err
    			puts "Exception: #{err}"
    			err
			end
			return file
		end
		# def est_aw_connection
		#   # disse er Sjur sine, som han betaler for privat, sa bruk med disskresjon
		#   AWS::S3::Base.establish_connection!(
		#     :access_key_id     => $_ACCESS_KEY,
		#     :secret_access_key => $_ACCESS_KEY_SECRET
		#   )
		# end
		# def lagre_til_aw_sky 
		# 	est_aw_connection
		#  	AWS::S3::S3Object.store(@archive_name, _to_xml_(@eksisterende_linjer), $_BUCKET)
		# end
		# def hent_fra_aw_sky
		# 	est_aw_connection
		# 	xfile = AWS::S3::S3Object.find @archive_name, $_BUCKET
		# 	#N.B. The actual data for the file is not downloaded in both the example where the file appeared in the bucket and when fetched directly. You get the data for the file like this:
		# 	return xfile.value
		# end


end