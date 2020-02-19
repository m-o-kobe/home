require "csv"

########### 初期ファイルの列順
INIT_X 		= 0
INIT_Y 		= 1
INIT_SP 	= 2
INIT_AGE	= 3
INIT_SIZE	= 4
INIT_TAG	= 5
INIT_SPROUT =6

class Fileio

	def initialize( settings_file, initial_file, out_file,stat_file,fire_layer)
		@setfile 	= CSV.open( settings_file, "r" )#settingファイルを読み込みモード
		@initfile 	= CSV.open( initial_file, "r" )
	 	@outfile	= File.open( out_file, "w" )#outputファイルに書き込みモード
		@statfile=File.open(stat_file,"w")
		@firefile=CSV.open(fire_layer,"r")
	end

	def read_init
		return @initfile.read.delete_if{|x| x[0]=~/^#/}.collect{|x| [ 
			x[ INIT_X ].to_f, 
			x[ INIT_Y ].to_f, 
			x[ INIT_SP ].to_i,
			x[ INIT_AGE ].to_i,
			x[ INIT_SIZE ].to_f,
			x[ INIT_TAG ].to_i,
			x[INIT_SPROUT].to_i
			]}
		#x[0]が#で始まっていたら削除.x[init_x]などを整数型に変える処理
	end
	def read_fire
		return @firefile.read
	end

	def read_settings
		
		return @setfile.read.delete_if{|x| x.size!=2|| x[0]=~/^#/}

	end

	def close_init
		@initfile.close
	end

	def close_settings
		@setfile.close
	end

	def record_forest( buf_array )
		buf_array.each do | _dat |
			@outfile.print _dat.join(", "),"\n"
		end
	end
	def record_stat(buf_array)
		buf_array.each do | _dat |
			@statfile.print _dat.join(", "),"\n"
		end
	end
	def close_out
		@outfile.close
	end
end

