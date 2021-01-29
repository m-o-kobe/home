require "./fileio.rb"
require "./settings.rb"
require "./forest.rb"


class Simulator
	def initialize( setting_file, initial_file, output_file,stat_file,fire_file)
		@fileio = Fileio.new( setting_file, initial_file, output_file,stat_file,fire_file )
		@settings = Settings.new
		#settingはsetting.rbの中で定義されているクラス
		@settings.load_file( @fileio.read_settings )
        #load_fileはsettings.rbの中で定義されているメソッド
		@forest = Forest.new( @fileio.read_init,@fileio.read_fire)
		#Forestはforest.rbの中で定義されているクラス
	end
	def run(i)
		#for i in 1..40 do
			for year in 1..@settings.duration
				print " ", year
				@forest.yearly_activities#年変動を計算
				@fileio.record_forest2( @forest.records ,i)#output_fileに1年分ずつ出力
				@fileio.record_stat(@forest.stat_records)
			end	
		#end
	end
end

for i in 97..100 do
	print i.to_s,"kaime" , "\n"
	simulator = Simulator.new( "../../../kamchatka/setting/set_0122_fire_2.csv",
		"../../../kamchatka/setting/init_int0120.csv",
		"../../../kamchatka/output/pp3/output0127ctr_pp"+i.to_s+".csv",
		"../../../kamchatka/output/stat0127ctr_fire_pp.csv",
		"../../../kamchatka/setting/fire_layer41to90.csv")
	
	#.newで作成したobjectに対してinitializeメソッドを呼び出し
	
	simulator.run(i)
	
end