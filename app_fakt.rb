#coding: iso-8859-1
require 'gtk2'
require 'date'
require 'thread'
require './_class_xml_and_local_storage.rb'
require './_class_listviewportrait.rb'
require './_class_listviewlandscape.rb'

	$fb_big = Pango::FontDescription.new ("Verdana 12")		
	$fb_small = Pango::FontDescription.new ("Verdana 7")
	$fakturaer_xml_filnavn = "fakturaer15.xml"
	$fakturaer_xml_arkiv_filnavn = "fakturaer_arkiv_14.xml"
	$mottakere_xml_filnavn = "mottakere.xml"

class MyButton <  Gtk::Button
	def initialize(lbltxt)
	 	super
	 	label0 = children[0]
        text = 'lbltxt'
        #label0.modify_fg Gtk::STATE_NORMAL, Gdk::Color.parse("#e66")
        label0.modify_font($fb_big)
	end

end	
class VisFakturaer < Gtk::Window
	attr_accessor :fakturaer_xmldataobject, :mottakere_xmldataobject, :mottaker_array_index, :row, :valgt_mottaker

	$blank_linje = [{:fnr => "", :mottaker_id => "11", :beskrivelse_linje1 => "Piano-backing", :beskrivelse_linje2 => "", :beskrivelse_linje3 => "", :dato_sendt => (Date.today()).strftime("%d.%m.%Y"), :forfallsdato => (Date.today()+14).strftime("%d.%m.%Y"), :antall => "1", :belop => "0 000", :sum => "0 000", :mva => "0", :total => "0 000" }]
	def initialize

		super

		set_title "fakturaer lagret i bucket_sjur\\#{$fakturaer_xml_filnavn} - fakturamottakere lagret i bucket_sjur\\#{$mottakere_xml_filnavn}"
		set_size_request(1080,720)
		modify_bg Gtk::STATE_NORMAL, Gdk::Color.parse("#9aa")



		signal_connect ("destroy") { 
				Gtk.main_quit 
				p 'talas.....'
			}
		signal_connect( "key-press-event" )  { |w, e|			
				#fanger tastetrykk
				p e.keyval
				if e.keyval == 65531 then 
				end
				}

		@mottaker_array_index = 0

		#en fixed for a putte pa edit felt og knapper
		$fixed_felles = Gtk::Fixed.new
		add $fixed_felles
		
		# refresh button
		button_refresh = Gtk::Button.new( ".. les fra sky .." )
        button_refresh.signal_connect( "clicked" ) { |w| #callback( w ) 
			_update_lv_fakturaer()
			
		}
		# => $fixed_felles.put button_refresh, 500, 5

		button_test = Gtk::Button.new( "..test .." )
        button_test.signal_connect( "clicked" ) { |w| #callback( w ) 
			
			#p $lv_fakturaer.selection.selected[0]
			#p $lv_fakturaer.row_pntr[:fn]

		}
		#$fixed_felles.put button_test, 600, 5
		# pdf icon for å vise selve faktura-pdf'en
		img_path_pdf = "./PDF.png"
		ipix_pdf = Gdk::Pixbuf.new img_path_pdf
		img = Gtk::Image.new ipix_pdf
		eb_holding_img_for_pdf = Gtk::EventBox.new.add( resizeImage(img, 100, 100)	)
		eb_holding_img_for_pdf.set_visible_window(false) 
		$fixed_felles.put eb_holding_img_for_pdf, 730, 25

		eb_holding_img_for_pdf.signal_connect("enter_notify_event") {
				eb_holding_img_for_pdf.window.cursor = Gdk::Cursor.new(Gdk::Cursor::HAND1)
		}
		eb_holding_img_for_pdf.signal_connect("leave_notify_event") {
			eb_holding_img_for_pdf.window.cursor = Gdk::Cursor.new(Gdk::Cursor::ARROW)
		}
		eb_holding_img_for_pdf.signal_connect("button_press_event") { |w,e|
			require './_class_fakturagenerator.rb' 
			fakura_fnr_som_skal_vises = $lv_fakturaer.model.get_value($lv_fakturaer.model.get_iter($lv_fakturaer.cursor[0].to_s), 0)
			mottaker_nr_som_skal_vises = $lv_fakturaer.model.get_value($lv_fakturaer.model.get_iter($lv_fakturaer.cursor[0].to_s), 1)
			idf = 0
			@fakturaer_xmldataobject._linjer.count.times {|i|
				if @fakturaer_xmldataobject._linjer[i][:fnr] == fakura_fnr_som_skal_vises then idf = i end
			}
			idm = 11
			@mottakere_xmldataobject._linjer.count.times {|i|
				if @mottakere_xmldataobject._linjer[i][:mottaker_id] == mottaker_nr_som_skal_vises then idm = i end
			}
			
			data = @mottakere_xmldataobject._linjer[idm].merge(@fakturaer_xmldataobject._linjer[idf])
			
			Thread.new {FakturaGenerator.new(data)}

			
		}			

		@fakturaer_xmldataobject = XmlAndLokalLagring.new $fakturaer_xml_filnavn, ["fakturaer", "faktura"]
		#fakturaer_object._leggtil_linjer([{:fnr => "20143", :mottaker_id => "14", :beskrivelse_linje1 => "Piano-backing", :beskrivelse_linje2 => "på Bjørge Nordre, Veldre", :beskrivelse_linje3 => "12. september 2013", :dato_sendt => "17.09.2013", :forfallsdato => "01.10.2013", :antall => "1", :belop => "4 000", :sum => "4 000", :mva => "0", :total => "4 000" }])
		#@fakturaer_xmldataobject._linjer=
		@fakturaer_xmldataobject._hent_linjer_fra_lokal_lagring_og_vis

		@mottakere_xmldataobject = XmlAndLokalLagring.new $mottakere_xml_filnavn, ["mottakere", "mottaker"]
		@mottakere_xmldataobject._hent_linjer_fra_lokal_lagring_og_vis
		




		# bla i mottakere
		button_bla_i_mottakere = Gtk::Button.new( ">" )
		button_bla_i_mottakere.set_size_request(30, 80)
        button_bla_i_mottakere.signal_connect( "clicked" ) { |w| #callback( w ) 
			_bla_i_mottakere()
			}
		$fixed_felles.put button_bla_i_mottakere, 180, 4
		# legg til mottaker button
		button_add_mottaker = Gtk::Button.new( " *ny mottaker" )
        button_add_mottaker.signal_connect( "clicked" ) { |w| #callback( w ) 
			_ny_blank_mottaker()
			_enable_save()
				}
		$fixed_felles.put button_add_mottaker, 222, 4
		# lagre mottaker button
		@button_save_mottaker = MyButton.new( " lagr " )

		#@button_save_mottaker.set_sensitive(false)
        @button_save_mottaker.signal_connect( "clicked" ) { |w| #callback( w ) 
        	if $oppretter_ny_mottaker then
	        	#@button_save_mottaker.set_sensitive(false)
	        	mottaker_linjer = [] 
	        	blanke_linjer = 4
	        	$lv_mottaker.each_row{ |r|
						mottaker_linjer << $lv_mottaker.model.get_value(r, 0) 
						blanke_linjer = blanke_linjer.pred if $lv_mottaker.model.get_value(r, 0)  != ''
						}
				if (blanke_linjer<3) then
					nye_linjer_som_skal_lagres = [{:mottaker_id => _nytt_mottaker_id, :linje1 => mottaker_linjer[0], :linje2 => mottaker_linjer[1], :linje3 => mottaker_linjer[2], :linje4 => mottaker_linjer[3], :siste_fnr => "0"}]
	        		@mottakere_xmldataobject._leggtil_linjer(nye_linjer_som_skal_lagres)
	        	else
	        		$lv_mottaker._update_header("mottaker (ikke lagret!)")
	        	end
	        	$oppretter_ny_mottaker = false
	        else
	        	ny_data = []
	        	$lv_mottaker.each_row{ |r|
						ny_data << $lv_mottaker.model.get_value(r, 0) 
					}
				@mottakere_xmldataobject._oppdater_linje(ny_data, @mottaker_array_index)
	        end
        	}
		$fixed_felles.put @button_save_mottaker, 222, 31

		# slett mottaker button
		button_slett_mottaker = Gtk::Button.new( " slett " )
		label0 = button_slett_mottaker.children[0]
        label0.modify_fg Gtk::STATE_NORMAL, Gdk::Color.parse("#e66")
        label0.modify_font($fb_small)
        button_slett_mottaker.signal_connect( "clicked" ) { |w| #callback( w ) 
        	@mottakere_xmldataobject._slett_linje(@mottaker_array_index)
        	_bla_i_mottakere()
        	}        	
        $fixed_felles.put button_slett_mottaker, 222, 58




		# legg til faktura button
		button_add_faktura = Gtk::Button.new( " *ny faktura" )
        button_add_faktura.signal_connect( "clicked" ) { |w| #callback( w ) 
			$blank_linje[0][0] = _nytt_fakturanummer_forslag
			$lv_fakturaer.add_new_rows($blank_linje, false)
			_freshen_lv_mottaker(2)
			$lv_fakturaer._set_editable()
				}
		$fixed_felles.put button_add_faktura, 220, 120
		# lagre faktura button
		button_save_faktura = Gtk::Button.new( "lagr alle" )
		button_save_faktura.set_width_request(160)
        button_save_faktura.signal_connect( "clicked" ) { |w| #callback( w ) 
			@fakturaer_xmldataobject._leggtil_linjer($lv_fakturaer._all_data, true)
			$lv_fakturaer._set_editable(false)
				}
		$fixed_felles.put button_save_faktura, 400, 120

		button_edit_faktura = Gtk::Button.new( " rediger " )
        button_edit_faktura.signal_connect( "clicked" ) { |w| #callback( w ) 
			$lv_fakturaer._set_editable()
				}
		$fixed_felles.put button_edit_faktura, 327, 120


		# summeringsfelt
		@summeringsfelt = Gtk::Entry.new 
		@summeringsfelt.set_width_request(77)
		@summeringsfelt.set_sensitive(false)
        @summeringsfelt.text = ''
        $fixed_felles.put ( @summeringsfelt ), 832, 122
		

		show_all
	end
	def _lag_lv_fakturaer
		$sw = Gtk::ScrolledWindow.new(hadjustment = nil, vadjustment = nil)
		$sw.set_size_request(960,400)
		$sw.set_shadow_type(Gtk::SHADOW_ETCHED_IN)
		$sw.set_hscrollbar_policy(Gtk::POLICY_NEVER)
		$fixed_felles.put $sw, 20, 150	
		$lv_fakturaer = ListviewLandscape.new @fakturaer_xmldataobject._linjer[0].keys
		#p @fakturaer_xmldataobject._linjer[0].keys
		$lv_fakturaer.add_new_rows(@fakturaer_xmldataobject._linjer)
		
        $sw.add $lv_fakturaer
		$fixed_felles.show_all
	end
	def _update_lv_fakturaer
		
		#p @fakturaer_xmldataobject._linjer[0].keys
		$lv_fakturaer.add_new_rows(@fakturaer_xmldataobject._linjer, true)
		
	end
	def _lag_lv_mottaker
		$lv_mottaker = ListviewPortrait.new [:mottaker]
		#nullvales = Array.new(1, "")
		nulldata = {:mottaker => ''}
		$lv_mottaker.add_new_rows([nulldata])
        $fixed_felles.put $lv_mottaker, 20, 6		
		$fixed_felles.show_all
	end
	def _freshen_lv_mottaker(metode=1, midval="22")
		
		valgt_linje = []
		metode == 1 ? mid = $lv_fakturaer.sel_values.last : mid = midval
		@mottakere_xmldataobject._linjer.each_with_index { |l,i|
			if l[:mottaker_id] == mid then 
			valgt_linje = l 
			@mottaker_array_index = i
			end
		}
		# p valgt_linje.inspect
		# system 'pause'

		$lv_mottaker.add_new_rows([{:mottaker=>valgt_linje[:linje1]},{:mottaker=>valgt_linje[:linje2]},{:mottaker=>valgt_linje[:linje3]},{:mottaker=>valgt_linje[:linje4]}]) if valgt_linje
		$lv_mottaker._update_header("mottaker (#{mid})")
	end
	def _delKSep_to_i(numstr)
		numstr.gsub(" ","").to_i
	end
	def _addKSep(numstr='0') #legger til mellomrom som tusen og million skillertegn
	    return numstr if numstr.index(' ')  # ikke gjor det om det allerede er gjort 
		numstr.insert( numstr.length - 3, ' ') if numstr.length > 3
	    numstr.insert( numstr.length - 7,' ') if numstr.length > 7
	  	return numstr
	end
	def _freshen_more
		a_summer = $lv_fakturaer._les_kolonne_data(11)
		i_summer = 0
		a_summer.count.times {|a|
			i_summer += _delKSep_to_i(a_summer[a]) }
		@summeringsfelt.text = _addKSep(i_summer.to_s)
		#summeringsfelt.text
				
	end
	def _ny_blank_mottaker
		#p valgt_linje.inspect
		$oppretter_ny_mottaker = true
		$lv_mottaker.add_new_rows([{:mottaker=>""},{:mottaker=>""},{:mottaker=>""},{:mottaker=>""}], true)
		$lv_mottaker.model.iter_first
		$lv_mottaker.set_cursor($lv_mottaker.cursor[0], $lv_mottaker.cols[0], true)
		$lv_mottaker._update_header("mottaker (#{_nytt_mottaker_id})")
	end	
	def _bla_i_mottakere
		@mottakere_xmldataobject._linjer.count-2 < @mottaker_array_index ? @mottaker_array_index = 0 : @mottaker_array_index += 1
		@valgt_mottaker = @mottakere_xmldataobject._linjer[@mottaker_array_index]
		#p $lv_fakturaer.model.set_value($lv_fakturaer.model.get_iter($lv_fakturaer.cursor), 1, valgt_linje[:mottaker_id])
		#p $lv_fakturaer.cursor[0].to_s
		$lv_fakturaer.model.set_value($lv_fakturaer.model.get_iter($lv_fakturaer.cursor[0].to_s), 1, @valgt_mottaker[:mottaker_id]) if $lv_fakturaer.selection
		#p $lv_fakturaer.selection
		#puts
		#p $lv_fakturaer.cursor[1].title

		# = ]
		#p$lv_fakturaer.rowcount
		
		$lv_mottaker.add_new_rows([{:mottaker=>valgt_mottaker[:linje1]},{:mottaker=>valgt_mottaker[:linje2]},{:mottaker=>valgt_mottaker[:linje3]},{:mottaker=>valgt_mottaker[:linje4]}]) if valgt_mottaker
		$lv_mottaker._update_header("mottaker (#{valgt_mottaker[:mottaker_id]})")
	end
	def _nytt_fakturanummer_forslag
		fakturanumre = []
		@fakturaer_xmldataobject._linjer.each {|l| fakturanumre << l[:fnr].to_i}
		p fakturaer_xmldataobject._linjer
		return (fakturanumre.max+1).to_s
	end
	def _nytt_mottaker_id
		mottaker_ider = []
		@mottakere_xmldataobject._linjer.each {|l| mottaker_ider << l[:mottaker_id].to_i}
		return (mottaker_ider.max+1).to_s
	end	
	def resizeImage(me, x, y)
        #print('Resizing Image to ('+str(x)+','+str(y)+')....')
        pixbuf = me.pixbuf.scale(x, y, Gdk::Pixbuf::InterpType::BILINEAR)
        me.set(pixbuf)	
    end
    def _enable_save
		@button_save_mottaker.set_sensitive(true)
    end
end	



Gtk.init
	$myApp = VisFakturaer.new
	$myApp._lag_lv_fakturaer()
	$myApp._lag_lv_mottaker()
	$myApp._freshen_more()
Gtk.main
