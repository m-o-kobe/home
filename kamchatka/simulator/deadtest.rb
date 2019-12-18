require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","stat")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[1,1,1,0,10.0,0],
	[1,3,4,0,1.0,0]
	])
	p forest
	forest.reset_counter
	forest.crdcal
	forest.tree_death
	forest.stat_records
	p forest
