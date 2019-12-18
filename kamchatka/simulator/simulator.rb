require "./fileio.rb"
require "./settings.rb"
require "./forest.rb"


class Simulator
	def initialize( setting_file, initial_file, output_file,stat_file)
		@fileio = Fileio.new( setting_file, initial_file, output_file,stat_file )
		@settings = Settings.new
		#settingはsetting.rbの中で定義されているクラス
		@settings.load_file( @fileio.read_settings )
        #load_fileはsettings.rbの中で定義されているメソッド
		@forest = Forest.new( @fileio.read_init)
		#Forestはforest.rbの中で定義されているクラス
	end
	def run
		for year in 1..@settings.duration
			print "Year: ", year, "\n"
			@forest.yearly_activities#年変動を計算
			@fileio.record_forest( @forest.records )#output_fileに1年分ずつ出力
			@fileio.record_stat(@forest.stat_records)
		end
	end
end
