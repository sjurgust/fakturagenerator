#coding: iso-8859-1
require 'nokogiri'
require './_class_xml_and_aw_sky.rb'

#mottakere_object = XmlAndAWsky.new "mottakere.xml", ["mottakere", "mottaker"]
#mottakere_object._hent_linjer_fra_sky_og_vis


fakturaer_object = XmlAndAWsky.new "fakturaer.xml", ["fakturaer", "faktura"]
#fakturaer_object._leggtil_linjer([{:fnr => "20143", :mottaker_id => "14", :beskrivelse_linje1 => "Piano-backing", :beskrivelse_linje2 => "på Bjørge Nordre, Veldre", :beskrivelse_linje3 => "12. september 2013", :dato_sendt => "17.09.2013", :forfallsdato => "01.10.2013", :antall => "1", :belop => "4 000", :sum => "4 000", :mva => "0", :total => "4 000" }])

fakturaer_object._hent_linjer_fra_sky_og_vis
# legg evt til nye jobber
			#@nye_mottakere <<	{ :mottaker_id => "11" , :linje1 => "Eidsvoll kommune", :linje2 => "Postboks 90", :linje3 => "2080 Eidsvoll", :linje4 => "", :siste_fnr => "20139" }
			#@nye_mottakere <<	{ :mottaker_id => "12" , :linje1 => "KAROLINE AMB", :linje2 => "STORHAMARGATA 34 A", :linje3 => "2317 HAMAR", :linje4 => "", :siste_fnr => "20138" }
			#@nye_mottakere <<	{ :mottaker_id => "13" , :linje1 => "SOLFAKTOR HOLDING", :linje2 => "ATT: AIRBUZZ", :linje3 => "ROSENKRANTZ GATE 9", :linje4 => "0159 OSLO", :siste_fnr => "20140" }
			#@nye_mottakere << { :mottaker_id => "14" , :linje1 => "GAUTE ORMÅSEN", :linje2 => "SANNERGATA 26", :linje3 => "0557 OSLO", :linje4 => "", :siste_fnr => "20142" }
			#@nye_mottakere.length.times {|i| @eksisterende_mottakere << @nye_mottakere[i] }
			# eliminer mulige duplpikater
			#@eksisterende_mottakere.uniq!
			# lagre alt til 
			#@eksisterende_mottakere =[{:mottaker_id=>"11", :linje1=>"Eidsvoll kommune", :linje2=>"Postboks 90", :linje3=>"2080 Eidsvoll", :linje4=>"", :siste_fnr=>"20139"}, {:mottaker_id=>"12", :linje1=>"KAROLINE AMB", :linje2=>"STORHAMARGATA 34 A", :linje3=>"2317 HAMAR", :linje4=>"", :siste_fnr=>"20138"}, {:mottaker_id=>"13", :linje1=>"SOLFAKTOR HOLDING", :linje2=>"ATT: AIRBUZZ", :linje3=>"ROSENKRANTZ GATE 9", :linje4=>"0159 OSLO", :siste_fnr=>"20140"}, {:mottaker_id=>"14", :linje1=>"GAUTE ORM\xC3\x85SEN", :linje2=>"SANNERGATA 26", :linje3=>"0557 OSLO", :linje4=>"", :siste_fnr=>"20142"}]
			#p @nye_mottakere