require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./map.rb"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","data/output.dat")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )

forest=Forest.new(
	[
	[5.0,5.0,3,10,10.5,0,0],#[x,y,sp,age,mysize,tag,mother,spnum]
	[2.5,3.4,2,0,1,0,1],
	[8.0,3.0,2,0,1,0,1],
	[15.0,3.0,2,0,2.3,0,2]
	]
)
p forest

# forest.popluscount
# forest.get_counter_2d
forest.fire_evoke

forest.reset_counter
forest.yearly_activities
forest.kakunin
#p forest
