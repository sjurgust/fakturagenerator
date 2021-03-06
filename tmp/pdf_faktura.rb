#coding: iso-8859-1
require 'prawn'

$avsender = 
[ "AVSENDER", "SJUR ANDREAS LUNDSTEIN" , "R�RSVEGEN 30, 2380 BRUMUNDDAL", "ORGNR:", "986 934 332", "MOBIL", "+47 91 37 19 28", "E-POST", "sjurandreaslundstein@gmail.com",  "KONTONUMMER", "2050 25 54272" ]
$headers = ["MOTTAKER", "DATO SENDT", "FORFALLSDATO", "ANTALL", "BESKRIVELSE", "BEL�P", "SUM", "MVA", "TOTAL"]
$valuta = "NKR"


$beskrivelse = 
[ "PIANO/AKKOMP MED GAUTE", "med reisekostnader", "Eidsvoll 22. august 2013"]
$beskrivelse = 
[ "PIANO/SYNTH P� SOMMERSHOW", "TINGNES juli 2013"]
$beskrivelse = 
[ "PIANO-BACKING med Anlegg", "i vielse i HamarDomen", "7. september 2013"]
$beskrivelse = 
[ "PIANO-BACKING", "p� Bj�rge Nordre, Veldre", "12. september 2013"]
$beskrivelse = 
[ "PIANO/SYNTH for H�s�iens", "p� H�sbj�r, Furnes", "5. september 2013"]


$fnr = 20143
$data = {:dato_sendt => "17.09.2013", :forfallsdato => "01.10.2013", :antall => "1", :belop => "4 000", :sum => "4 000", :mva => "0", :total => "4 000"}
# 		  dato_sendt      forfall      antall  belop  sum     mva   total
#$datas = [ "17.09.2013", "01.10.2013", "1", "4 000", "4 000", "0", "4 000"}

$mottaker = 
[ "Eidsvoll kommune" , "postboks 90", "2080 Eidsvoll" ]
$mottaker = 
[ "Karoline Amb".upcase , "Storhamargata 34 a".upcase, "2317 Hamar".upcase ]
$mottaker = 
[ "Solfaktor Holding".upcase , "Att: Airbuzz".upcase, "Rosenkrantz gate 9".upcase, "0159 OSLO" ]
$mottaker = 
[ "Gaute Orm�sen".upcase , "Sannergt 26".upcase, "0557 OSLO".upcase ]
$mottaker = 
[ "Per Erik H�s�ien".upcase, "Langbergvegen 42", "2335 Stange"]

$faktura_filnavn = "#{Time.now.strftime("%Y-%m-%d")}_Sjur_#{$mottaker[0].split(" ").first}_fnr_#{$fnr}.pdf".gsub(" ", "")

	#diverse variabler
	bgimgfile = "./Old_paper.jpg"
	oransj = "ff4400"
	svart = "000000"
	foL = "./fonts/Existence-Light.ttf"
	foB = "./fonts/AxeHandel.ttf"
	foM = "./fonts/myriad-web-pro.ttf"

module Kernel
  def with(object, &block)
    object.instance_eval &block
  end
end




Prawn::Document.generate($faktura_filnavn, :compression => false, :background => bgimgfile, :margin => 100, :page_size => [600,400]) do |pdf|
with pdf do

	#pdf.encrypt_document :user_password => 'rask', :owner_password => 'bar'
	


	#avs = "d:/MyDocs/okonomi/avsenderpng_.png" 
    #image avs, :at => [-50,290], :width => 443
 
	# toppen/avsender
	bounding_box([50, 200], :width => 500, :height => 150) do
		#transparent(0.5) { stroke_bounds }
		
		stroke_color "ffffff"
		fill_color "000000"
		#transparent(0.5) { fill_and_stroke_rounded_rectangle [-20,160], 180, 100, 10}

		fill_color svart # font color
		font foL
		draw_text $avsender[0], :size => 10, :at => [-84,230] #avsender
		font foM
		draw_text $avsender[1], :size => 18, :at => [-84,215]
		font foB #adresse
		draw_text $avsender[2], :size => 14, :at => [-38.5,201]
		#orgnr-tittel
		fill_color oransj
		draw_text $avsender[3], :size => 14, :at => [10,185]
		font foB
		fill_color svart
		draw_text $avsender[4], :size => 17, :at => [55.5,185]
		#mobil
		fill_color oransj
		draw_text $avsender[5], :size => 14, :at => [150,215]
		fill_color svart
		draw_text $avsender[6], :size => 17.7, :at => [185,215]
		#e-post
		fill_color oransj
		draw_text $avsender[7], :size => 14, :at => [150,200]
		fill_color svart
		draw_text $avsender[8], :size => 17.7, :at => [190,200]		
		#kontonr
		fill_color oransj
		draw_text $avsender[9], :size => 14, :at => [150, 185]
		fill_color svart
		draw_text $avsender[10], :size => 17.7, :at => [230, 185]				
	end	
	
 
 
	# ordet faktura p� venstresiden
	  font foM
	  fill_color oransj
	  x = 300
	  y = 300
	  width = 150
	  height = 200
	  angle = -90
	  rotate(angle, :origin => [x, y]) do
		draw_text "faktura", :at => [367,-70], :size => 85
	  end
  
	#fakturanummer med boks
	bounding_box([-70, -40	], :width => 200, :height => 150) do
		transparent(0.0) { stroke_bounds }
		
		[:round].each_with_index do |cap, i|
			self.cap_style = cap
			self.line_width = 30
			self.fill_color "000000"
			self.stroke_color "ffffff"
			self.stroke_horizontal_line 0, 50, :at => 125
		end
		
		move_cursor_to 138
		font foL
		text "FakturaNr", :size => 10
		font foB
		text "#{$fnr}", :size => 20
	end
	
	# mottaker med boks
	bounding_box([40, 200], :width => 500, :height => 150) do
		#transparent(0.5) { stroke_bounds }
		
		[:round].each_with_index do |cap, i|
			self.cap_style = cap
			self.line_width = 0
			self.fill_color "ffffff"
			self.stroke_color "ffffff"
			transparent(0.5) { fill_rounded_rectangle [-20,160], 180, 100, 10}
		end
		

		fill_color "000000" # font color
		font foL
		draw_text $headers[0], :size => 10, :at => [-10,145]
		font foB
		$mottaker.each_with_index {|c,i|
			draw_text c, :size => 17, :at => [-10,125 - (18*i)]
		}
	end	
	
	#headers, fakturalinjer/beskrivelse, datoer, belop
	bounding_box([200, 200], :width => 200, :height => 450) do
		#transparent(0.5) { stroke_bounds }
		
		fill_color "000000"
		stroke_color "ffffff"
		#transparent(0.5) { rounded_rectangle [-100,230], 200, 200, 10}

		
		font foL
		text $headers[1], :size => 10, :align => :right
		font foB
		text $data[:dato_sendt], :size => 12, :align => :right
		font foL
		text $headers[2], :size => 10, :align => :right
		font foB
		text $data[:forfallsdato], :size => 12, :align => :right
		move_cursor_to 310
		font foL
		draw_text $headers[3], :size => 10, :at => [-170,325]
		draw_text $headers[4], :size => 10, :at => [-110,325]
		draw_text $headers[5], :size => 10, :at => [172, 325]
		draw_text $headers[6], :size => 10, :at => [120,302.5]
		draw_text $headers[7], :size => 10, :at => [120,284]
		draw_text $headers[8], :size => 10, :at => [120,265]
		font foB
		text $data[:sum], :size => 12, :align => :right
		text "\n" 
		text $data[:mva], :size => 12, :align => :right
		text "\n" 
		text $data[:total], :size => 12, :align => :right
		font foL
		draw_text $valuta, :size => 10, :at => [203,265.5]
		#selve fakturalinjene
		font foB
		draw_text "1", :size => 10, :at => [-156,304]
		draw_text $beskrivelse[0], :size => 10, :at => [-109,304]
		draw_text $beskrivelse[1], :size => 10, :at => [-109,294]
		draw_text $beskrivelse[2], :size => 10, :at => [-109,284]
	end
 
	#2 streker under svaret
	[:round].each_with_index do |cap, i|
			self.cap_style = cap
			self.line_width = 1
			self.fill_color "000000"
			self.stroke_color oransj
			self.stroke_horizontal_line 280, 430, :at => 6
			self.stroke_horizontal_line 280, 430, :at => 10
		end
	
	
end  
  
end




#File.open(im, 'rb') {|file| file.read }
#pdf.add_image_from_file(im, 0, 0, width = 200, height = 100, link = nil)

#skriv pdf'en til en fil
#File.open("faktura.pdf", "wb") { |f| f.write pdf.render }
#pdf.save_as("faktura.pdf")

#start forxit reader og �pne pdf
%x{"C:\\Program Files (x86)\\Foxit Software\\Foxit Reader\\Foxit Reader.exe " #{$faktura_filnavn}}