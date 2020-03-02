require "./simulator.rb"
require 'timeout'
#↓実行例
# ruby kamcha.rb ../../../kamchatka/setting/setting.csv data/init.csv data/output.csv data/stat.csv data/fireat.csv data/fire.csvruby kamcha.rb ../../../kamchatka/setting/setting.csv data/init.csv data/output.csv data/stat.csv data/fireat.csv data/fire.csv


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
  Timeout.timeout(600){
    #puts"start"
 simulator.run
  }
rescue Timeout::Error
  puts "timeout"
end


#.runはsimulator.rbの中で定義されているメソッド