require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
require 'timeout'
puts "start"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","data/output.csv")
tmp=Settings.new
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[2.0,1.0,2,0,10,0,1],#[x,y,sp,age,mysize,tag,mother,spnum]
	[1.0,3.0,2,0,1,0,2]
	])
p forest
begin
  Timeout.timeout(30){
	forest.reset_counter
	forest.firesinki
	forest.kakunin
  }
rescue Timeout::Error
  puts "timeout"
end
p forest

