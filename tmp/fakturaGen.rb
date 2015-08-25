#coding: iso-8859-1
require 'gtk2'
require 'date'
require 'thread'
require 'nokogiri'
require './_class_xml_and_aw_sky.rb'
require './_class_listviewdata.rb'

#mottakere_object = XmlAndAWsky.new "mottakere.xml", ["mottakere", "mottaker"]
#mottakere_object._hent_linjer_fra_sky_og_vis




class FakturaGeneratorInput < Gtk::Window

	def initialize

		super	

		set_title "faktura generator input"
		set_size_request(850,600)
		

		signal_connect ("destroy") { 
				Gtk.main_quit 
				p 'talas.....'
			}

		signal_connect( "key-press-event" )  { |w, e|			
				#fanger tastetrykk
				#p e.keyval
				if e.keyval == 65293 then #enter
					$buttons[0].clicked unless !$buttons[0]
				end
				}
		
		fakturaer_xmldataobject = XmlAndAWsky.new "fakturaer.xml", ["fakturaer", "faktura"]
		#fakturaer_object._leggtil_linjer([{:fnr => "20143", :mottaker_id => "14", :beskrivelse_linje1 => "Piano-backing", :beskrivelse_linje2 => "på Bjørge Nordre, Veldre", :beskrivelse_linje3 => "12. september 2013", :dato_sendt => "17.09.2013", :forfallsdato => "01.10.2013", :antall => "1", :belop => "4 000", :sum => "4 000", :mva => "0", :total => "4 000" }])

		fakturaer_xmldataobject._hent_linjer_fra_sky_og_vis
		fakturaer_xmldataobject._linjer

		mottakere_xmldataobject = XmlAndAWsky.new "mottakere.xml", ["mottakere", "mottaker"]
		mottakere_xmldataobject._hent_linjer_fra_sky_og_vis
		mottakere_xmldataobject._linjer
		#select mottaker

		#en fixed for a putte pa edit felt og knapper
		$fixed_felles = Gtk::Fixed.new
		add $fixed_felles
		$labels, $entries = [], []



		$entry_data = [ {:w => 200, :h => 30, :x => 30,  :y => 30,  :title => " mottaker_linje1 ", :value => ""}, \
						{:w => 200, :h => 30, :x => 30,  :y => 90,  :title => " mottaker_linje2 ", :value => ""}, \
						{:w => 200, :h => 30, :x => 30,  :y => 150, :title => " mottaker_linje3 ", :value => ""}, \
						{:w => 200, :h => 30, :x => 30,  :y => 210, :title => " mottaker_linje4 ", :value => ""}, \
						{:w => 100, :h => 30, :x => 330, :y => 30,  :title => " fakturanr ", :value => "nnnnn"}, \
						{:w => 100, :h => 30, :x => 330, :y => 90, :title => " fakturadato ", :value => DateTime.now.strftime("%d-%m-%Y").to_s}, \
						{:w => 100, :h => 30, :x => 330, :y => 150, :title => " forfallsdato ", :value => (DateTime.now + 14).strftime("%d-%m-%Y").to_s}, \
						{:w => 5,  :h => 30, :x => 10,  :y => 300, :title => " antall ", :value => "1"}, \
						{:w => 300, :h => 30, :x => 72,  :y => 300, :title => " beskrivelse1 ", :value => "PIANO/SYNTH for Airbuzz"}, \
						{:w => 300, :h => 30, :x => 72,  :y => 360, :title => " beskrivelse2 ", :value => "Frognerparken, Oslo, 13. september 2013"}, \
						{:w => 300, :h => 30, :x => 72,  :y => 420, :title => " beskrivelse3 ", :value => ""}, \
						{:w => 100, :h => 30, :x => 370,  :y => 300, :title => " sum ", :value => "3 000"}, \
						{:w => 100, :h => 30, :x => 500,  :y => 300, :title => " mva ", :value => "0"}, \
						{:w => 100, :h => 30, :x => 500,  :y => 350, :title => " total ", :value => "3 000"}
					]
		
		$entry_data.length.times { |x|
			$labels[x] = Gtk::Label.new 
			$labels[x].justify = Gtk::Justification::RIGHT
			$labels[x].set_markup("<span font_desc='12' weight='bold' background='#18a' color='#fff'>#{$entry_data[x][:title]}</span>")
       		$fixed_felles.put $labels[x], $entry_data[x][:x], $entry_data[x][:y] - 20
			$entries[x] = Gtk::Entry.new
			$entries[x].text = ($entry_data[x][:value])
			$entries[x].set_size_request($entry_data[x][:w], $entry_data[x][:h])
			$fixed_felles.put $entries[x] , $entry_data[x][:x], $entry_data[x][:y]
		}

		$buttons = []
		$buttons[0] = Gtk::Button.new( :label => " ok ".encode!("utf-8") )
		$buttons[0].set_size_request(50, 50)
		$buttons[0] .signal_connect( "clicked" ) { |w| 
			require './class_fakturagenerator.rb' 
			data = {:mottaker => [$entries[0].text, $entries[1].text, $entries[2].text, $entries[3].text], :fnr => $entries[4].text, \
					:dato_sendt => $entries[5].text, :forfallsdato => $entries[6].text, :beskrivelse => [$entries[8].text, $entries[9].text, $entries[10].text], \
					:antall => $entries[7].text, :sum => $entries[11].text, :mva => $entries[12].text, :total => $entries[13].text}
			
			Thread.new FakturaGenerator.new(data)

			
		}
		
		$fixed_felles.put $buttons[0] , 530, 500






		@@mulige_mottakere 	  = []
		@@mulige_mottakere[0] = [ "Eidsvoll kommune" , "postboks 90", "2080 EIDSVOLL" ]
		@@mulige_mottakere[1] = [ "Karoline Amb".upcase , "Storhamargata 34 a".upcase, "2317 Hamar".upcase ]
		@@mulige_mottakere[2] = [ "Gaute Ormåsen".upcase , "Sannergt 26".upcase, "0557 OSLO".upcase ]
		@@mulige_mottakere[3] = [ "Solfaktor Holding".upcase , "Att: Airbuzz".upcase, "Rosenkrantz gate 9".upcase, "0159 OSLO" ]
		@@mulige_mottakere[4] = [ "Per Erik Høsøien".upcase, "Langbergvegen 42", "2335 Stange"]
		$cb_lagrede_mottakere = Gtk::ComboBoxText.new
		$cb_lagrede_mottakere.signal_connect( "changed" ) { |w,e| 
			$entries[0].text = @@mulige_mottakere[w.active][0] #.gsub("¥".encode("utf-8"), "")
			$entries[1].text = @@mulige_mottakere[w.active][1] if @@mulige_mottakere[w.active][1]
			$entries[2].text = @@mulige_mottakere[w.active][2] if @@mulige_mottakere[w.active][2]
			$entries[3].text = @@mulige_mottakere[w.active][3] if @@mulige_mottakere[w.active][3]
			$entries[4].text = @@mulige_mottakere[w.active][4] if @@mulige_mottakere[w.active][4]
			}
        5.times {|x| $cb_lagrede_mottakere.append_text @@mulige_mottakere[x].join(",") }
        $cb_lagrede_mottakere.active = 0
		$cb_lagrede_mottakere.width_request = 100
		#cb_machine[0].modify_font($fontBeskrivelse)
        $fixed_felles.put $cb_lagrede_mottakere, 10, 500


		

		show_all
	end

end	












Gtk.init
	
      $myApp = FakturaGeneratorInput.new
      
	

#Glib::Timeout.add(250) {
      
 #     }
    

Gtk.main
