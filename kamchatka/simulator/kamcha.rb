require "./simulator.rb"
require 'timeout'
#↓実行例 日付変える
# ruby kamcha.rb ../../../kamchatka/setting/setting.csv ../../../kamchatka/setting/init_fire0302.csv ../../../kamchatka/output/output0405.csv ../../../kamchatka/output/stat0405.csv data/fire.csv
#ruby kamcha.rb ../../../kamchatka/setting/setting201006.csv ../../../kamchatka/setting/init_fire0302.csv ../../../kamchatka/output/output1014.csv ../../../kamchatka/output/stat1014.csv data/fire.csv
#ruby kamcha.rb ../../../kamchatka/setting/setting201006.csv ../../../kamchatka/setting/init_fire0302.csv ../../../kamchatka/output/output1014.csv ../../../kamchatka/output/stat1014.csv data/fire.csv



#火災時実行
#ruby kamcha.rb ../../../kamchatka/setting/set_ctr_fire1218.csv ../../../kamchatka/setting/init_ctr1216.csv ../../../kamchatka/output/output1218.csv ../../../kamchatka/output/stat1218.csv ../../../kamchatka/setting/fire_layer1to50.csv
#ruby kamcha.rb ../../../kamchatka/setting/set_ctr_fire1218.csv ../../../kamchatka/setting/init_ctr1216.csv ../../../kamchatka/output/output1218_41to90.csv ../../../kamchatka/output/stat1218_41to90.csv ../../../kamchatka/setting/fire_layer41to90.csv
#ruby kamcha.rb ../../../kamchatka/setting/set_ctr_fire0118.csv ../../../kamchatka/setting/init_fire_bp0118.csv ../../../kamchatka/output/output0118.csv ../../../kamchatka/output/stat0118.csv data/fire.csv
#ruby kamcha.rb ../../../kamchatka/setting/set_int_fire0118.csv ../../../kamchatka/setting/init_int_bp0118.csv ../../../kamchatka/output/output0118_intbp.csv ../../../kamchatka/output/stat0118_intbp.csv data/fire.csv

######################
# Fix random numbers: for development purpose
Encoding.default_external = 'utf-8'

#ARGVはコマンドライン引数の取得
if ARGV.size < 5
  STDERR.print "Usage: ruby #{$0} setting_filename initial_filename output_filename stat_filename fire_file\n"
  #settingのプロットサイズは5の倍数にしてね
	exit
end

simulator = Simulator.new( ARGV[0], ARGV[1], ARGV[2],ARGV[3],ARGV[4])

#.newで作成したobjectに対してinitializeメソッドを呼び出し
begin
  Timeout.timeout(999999){
    #puts"start"
  simulator.run
  }
rescue Timeout::Error
  puts "timeout"
end


#.runはsimulator.rbの中で定義されているメソッド