require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./map.rb"
require"./betula_regene.rb"
srand 1234
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

#forest.popluscount
# forest.get_counter_2d
#forest.fire_evoke
fir=Fire_layer.new()
fir.load_file(fileio.read_fire)
counttest=BetulaSprout.new(0,0,15,15,5)
#a,b,c,d=counttest.b_count(forest.trees,0,0)
# a,b=counttest.count_betula_sprout([1,2],forest.trees)
# p a
# p b
p counttest.make_betula_sprout(forest.trees)
# p  counttest.betula_kousin(
# 	a,
# 	b,
# 	2.5)


#counttest.make_betula_sprout
# forest.reset_counter
# forest.yearly_activities
# forest.kakunin
#p forest
