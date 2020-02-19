require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./map.rb"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","data/output.dat","data/fire.csv")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )

forest=Forest.new(
	[
	[5.0,5.0,2,10,10.5,0,2],#[x,y,sp,age,mysize,tag,mother,spnum]
	[2.5,3.4,2,0,1,0,1],
	[2.0,3.0,2,0,1,0,1],
	[1.0,3.0,2,0,2.3,0,2]
	]
)
#p forest

#forest.popluscount
# forest.get_counter_2d
#forest.fire_evoke
fir=Fire_layer.new()
fir.load_file(fileio.read_fire)
counttest=PoplusCount.new(0,0,15,15,5)
a,b,c,d=counttest.b_count(forest.trees,0,0)
#a,b=counttest.betula_sprout_count([1,2],forest.trees)
p d
#counttest.make_betula_sprout
# forest.reset_counter
# forest.yearly_activities
# forest.kakunin
#p forest
