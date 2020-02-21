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
	[2.5,3.4,3,0,1,0,1],
	[2.0,3.0,3,0,1,0,1],
	[1.0,3.0,3,0,2.3,0,2]
	]
)
#forest.popluscount
#forest.get_counter_2d
#forest.fire_evoke
fir=Fire_layer.new()
fir.load_file(fileio.read_fire)
counttest=PoplusCount.new(0,0,15,15,5)
counttest.pcount(forest.trees)
p counttest.get_count_2d
#p counttest.make_poplus_sprout(false)