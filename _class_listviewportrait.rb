require 'vrlib'
	
class ListviewPortrait < VR::ListView
	@@instance_collector = []
	attr_accessor :rowcount, :rownames, :rowtypes, :values, :sel_values, :cols
		
	
	
	
	def self.all_offspring
		@@instance_collector
	end

	def initialize(rownames=[])
		@sel_values = []
	    @@instance_collector << self
  		@rowcount = 0
  		@rownames = rownames
		@rowtypes = Array.new(@rownames.count, String)
		# fet snarvei
		@cols = Hash[@rownames.zip @rowtypes]

	  	# @cols[:check] = TrueClass
		super(@cols)

		
		#col_sort_column_id(:last_name => id(:last_name), :popular => id(:popular), :buy=> id(:buy))
		#col_sort_column_id(:quantity => id(:quantity), :price => id(:price), :check => id(:check), :date => id(:date))

		#col_title(:check => ' ', :tittel =>' ' ) #, :sted_og_fylke => "Sted, Fylke")
		
		ren_width(:mottaker => 150)
		
		#ren_attr(:premie, :edit_inline => true)
		ren_editable(false)

		signal_connect("row-activated") { |view, path, column|
			#puts self[path.to_s.to_i, 0]
			#$lottoapp_instance.update_lotto_stack($XMLSTI+$LOTTOXMLFILNAVN)
			@sel_values << self[path.to_s.to_i, 1].to_s
			$myApp._enable_save() if @sel_values.length>0
			ren_editable(true)
		}
	end		
	def _update_header(txt)
		col_title(@rownames[0] => txt)
	end

	def add_new_rows(data_input=[], clear=true)
		model.clear if clear #tommer eksisterende rekker/rows
		@rowcount = 0 if clear
		$row = {}
		
		#fyller pa med data gitt kay/value
	
		data_input.each do |onerowdata|
			@row = add_row( onerowdata )
			@rowcount +=1	
		end	
	end


end



