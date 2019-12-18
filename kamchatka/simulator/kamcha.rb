require "./simulator.rb"
require 'timeout'
######################
# Fix random numbers: for development purpose
Encoding.default_external = 'utf-8'

#ARGVはコマンドライン引数の取得
if ARGV.size < 4
	STDERR.print "Usage: ruby #{$0} setting_filename initial_filename output_filename stat_filename\n"
	exit
end

simulator = Simulator.new( ARGV[0], ARGV[1], ARGV[2],ARGV[3])

#.newで作成したobjectに対してinitializeメソッドを呼び出し
begin
  Timeout.timeout(600){
 simulator.run
  }
rescue Timeout::Error
  puts "timeout"
end


#.runはsimulator.rbの中で定義されているメソッド