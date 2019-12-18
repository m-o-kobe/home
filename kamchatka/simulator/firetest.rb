require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","output.dat")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[1,1,2,0,10.0,0,1],
	[1,3,2,0,5.1,0,2]
	])
	p forest
	forest.reset_counter
	forest.crdcal
	forest.fire
	forest.kakunin
	p forest
