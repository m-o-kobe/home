require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./poplus_regene.rb"
require"./betula_regene.rb"
srand 1234
fileio = Fileio.new( "data/setting_test.csv","data/init.csv","data/output.dat","data/output.dat","data/fire.csv")
tmp=Settings.new()

# hash = Hash.new { |h,k| h[k] = {} }

# hash["a"]["b"] = 1
# p hash["a"]["b"]



tmp.load_file( fileio.read_settings )

forest=Forest.new(
	[
	[5.0,5.0,3,10,10.5,0,2],#[x,y,sp,age,mysize,tag,mother,spnum]
	[2.5,3.4,2,0,1,0,1],
	[2.0,3.0,2,0,1,0,1],
	[1.0,3.0,3,0,2.3,0,2],
	[3.0,3.0,1,0,1,0,1],
	[1.0,3.0,1,0,2.3,0,2],
	[3.0,3.0,2,0,2.3,0,2],
	[5.0,3.0,3,0,2.3,0,2],
	[2.0,3.0,1,0,2.3,0,2],
	[6.0,3.0,1,0,2.3,0,2]

]
)

#forest.popluscount
# forest.get_counter_2d
#forest.fire_evoke
fir=Fire_layer.new()
fir.load_file(fileio.read_fire)
#counttest=BetulaSprout.new(0,0,15,15,5)
#a,b,c,d=counttest.b_count(forest.trees,0,0)
#  a,b=counttest.count_sprout([1,2],forest.trees,"heiwa")
#  p a
#  p b
#p counttest.make_sprout(forest.trees,false)
forest.yearly_activities
forest.yearly_activities
forest.yearly_activities
forest.yearly_activities
forest.yearly_activities

#p forest
forest.kakunin
# p  counttest.betula_kousin(
# 	a,
# 	b,d
# 	2.5)


#counttest.make_betula_sprout
# forest.reset_counter
# forest.yearly_activities
# forest.kakunin
#p forest
