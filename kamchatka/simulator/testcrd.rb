require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","data/output.dat")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[2.0,1.0,2,10,10,0,1],#[x,y,sp,age,mysize,tag,mother,spnum]
	[1.0,3.0,2,0,1,0,1]
	])
	p forest
	forest.reset_counter
	forest.crdcal
	forest.trees_grow
	p forest
