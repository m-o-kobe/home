require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
fileio = Fileio.new( "../../../kamchatka/setting/set_0122_test.csv","data/init.csv","data/output.dat","output.dat","data/fire.csv")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )
forest=Forest.new([
	[2.0,1.0,3,10,10,1,1],#[x,y,sp,age,mysize,tag,mother,spnum]
	[1.0,3.0,3,10,0,2,2],
	[1.0,3.0,3,10,0,3,2]
	],
	fileio.read_fire
)

	forest.reset_counter

	forest.yearly_activities
	forest.yearly_activities
	forest.yearly_activities

	