require 'vrlib'
	
class ListviewLandscape < VR::ListView
	@@instance_collector = []
	attr_accessor :cols, :rowcount, :colnames, :coltypes, :data_input, :sel_values, :row_pntr
		
	
	
	
	def self.all_offspring
		@@instance_collector
	end

	def initialize(colnames=[])
		@sel_values = []
	    @@instance_collector << self
  		@rowcount = 0
  		@colnames = colnames
		@coltypes = Array.new(@colnames.count, String)
		# fet snarvei
		@cols = Hash[@colnames.zip @coltypes]
		@cols = @cols.merge(:dato_sendt_int => String)
		
	  	
	  	# @cols[:check] = TrueClass
		super(@cols)
		signal_connect( "key-press-event" )  { |w, e|			
				#fanger tastetrykk
				#p e.keyval
				if e.keyval == 65535 then 
					model.remove(@row_pntr)
				end
				}

		col_sort_column_id(:fnr => id(:fnr), :mottaker_id => id(:mottaker_id), :dato_sendt => id(:dato_sendt_int))				
		#col_sort_column_id(:artist => id(:last_name), :song => id(:song), :first_name=> id(:first_name))
		#col_sort_column_id(:last_name => id(:last_name), :popular => id(:popular), :buy=> id(:buy))
		#col_sort_column_id(:quantity => id(:quantity), :price => id(:price), :check => id(:check), :date => id(:date))

		#col_title(:check => ' ', :tittel =>' ' ) #, :sted_og_fylke => "Sted, Fylke")
		
		#ren_width(:job_id => 50, :status => 100)
		
		
		ren_xalign(:mottaker_id => 0.5, :total => 1, :sum => 1, :mva => 0.5, :belop => 1) 
		ren_editable(false)
		col_visible(:dato_sendt_int => false)
		ren_width(:dato_sendt_int => 0)
		renderer(:mottaker_id).edited_callback = Proc.new { | model_col, iter |
				#p iter.to_s.to_i # = iter[id(model_col)]
				@sel_values << self[path.to_s.to_i, 1].to_s
				$myApp._freshen_lv_mottaker if @sel_values.length>0
				ren_editable(false)
				#quick_message("iter:"+iter.to_s)
				}
		renderer(:fnr).edited_callback = Proc.new { | model_col, iter |
				#p iter.to_s.to_i # = iter[id(model_col)]
				ren_editable(false)
				#quick_message("iter:"+iter.to_s)
				}		
	

		signal_connect("row-activated") { |view, path, column|
			#puts self[path.to_s.to_i, 1]
			#$lottoapp_instance.update_lotto_stack($XMLSTI+$LOTTOXMLFILNAVN)
			@sel_values << self[path.to_s.to_i, 1].to_s
			$myApp._freshen_lv_mottaker if @sel_values.length>0
			
		}

	end		
	def _set_editable(what=true)
			ren_editable(what)
	end
	def _les_kolonne_data(colnr=nil)
		returndata = []
		if colnr || ( colnr < @cols.count+1 ) then
			each_row{ |r|
				returndata << model.get_value(r, colnr)
				} end 
		return returndata
	end
	def _les_rad_data(rownr=nil)
		returndata = {}
		if rownr then
			each_row{ |r|
				if r.to_s.to_i == rownr then
					@cols.each_with_index {|c,i|
					returndata[c[0].to_sym] = model.get_value(r, i)
				} end }
		else
			
			@cols.each {|c|
					returndata[c[0].to_sym] = @row_pntr[c[0].to_sym]
				}
		end				
		return returndata
	end
	def _skriv_rad_data(rownr=nil)

	end	
	def _all_data
		#konvert fra string til integerdato
		#Date.strptime("{02.10.2013}", "{%d.%m.%Y}").to_time.to_i.to_s
		returndata = []
			each_row{ |r|
				values = [] 
				@colnames.count.times { |i|
					values << model.get_value(r, i) }
					returndata << Hash[@colnames.zip values] 
				}
		return returndata
	end	
	def add_new_rows(data_input=[], clear=true)
		model.clear if clear #tommer eksisterende rekker/rows
		@rowcount = 0 if clear
		$row_pntr = {}
		@data_input = data_input
		#fyller pa med data gitt kay/value
	
		data_input.each do |onerowdata|
			onerowdata = onerowdata.merge(:dato_sendt_int => Date.strptime("{#{onerowdata[:dato_sendt]}}", "{%d.%m.%Y}").to_time.to_i.to_s)
					#if k.to_s.downcase.include?("dato") then v=Time.at(v).strftime("{%d.%m.%Y}")
					#konvert fra integerdato til tring Time.at(1380664800).strftime("{%d.%m.%Y}")
			@row_pntr = add_row( onerowdata )
			@rowcount +=1	
		end	
	end


end



