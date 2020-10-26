require "./simulator.rb"
require 'timeout'
#↓実行例 日付変える
# ruby kamcha.rb ../../../kamchatka/setting/setting.csv ../../../kamchatka/setting/init_fire0302.csv ../../../kamchatka/output/output0405.csv ../../../kamchatka/output/stat0405.csv data/fire.csv
#ruby kamcha.rb ../../../kamchatka/setting/setting201006.csv ../../../kamchatka/setting/init_fire0302.csv ../../../kamchatka/output/output1014.csv ../../../kamchatka/output/stat1014.csv data/fire.csv

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
  Timeout.timeout(999999999){
    #puts"start"
  simulator.run
  }
rescue Timeout::Error
  puts "timeout"
end


#.runはsimulator.rbの中で定義されているメソッド