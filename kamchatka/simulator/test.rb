require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
fileio = Fileio.new( "data/setting_test.csv","data/init.csv","data/output.dat","output.dat","data/fire.csv")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[2.0,1.0,1,10,10,1,1],#[x,y,sp,age,mysize,tag,mother,spnum]
	[1.0,3.0,1,10,1,2,2],
	[1.0,3.0,1,10,1,3,2]
	],
	fileio.read_fire
)
p forest
# forest=Forest.new(
# 	fileio.read_init,
# 	fileio.read_fire
# )
#	p forest
	forest.reset_counter
	#forest.crdcal

	#火災の時
	#forest.tree_death

	#平和な時
	# forest.tree_death
	# forest.trees_newborn
	forest.yearly_activities
	#forest.kakunin
	# forest.yearly_activities
	# forest.kakunin
	# forest.yearly_activities
	# forest.kakunin
	# forest.yearly_activities
	# forest.kakunin
	#↑num,death,sinki,zombie
	p forest

	