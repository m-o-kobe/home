require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./poplus_regene.rb"
require"./betula_regene.rb"
srand 1234
fileio = Fileio.new( "../../../kamchatka/setting/setting.csv",
	"../../../kamchatka/setting/init_fire0302.csv","data/output.dat","data/output.dat","data/fire.csv")
tmp=Settings.new()

# hash = Hash.new { |h,k| h[k] = {} }

# hash["a"]["b"] = 1
# p hash["a"]["b"]



tmp.load_file( fileio.read_settings )

# forest=Forest.new(
# 	[
# 	[5.0,5.0,3,10,10.5,0,2],#[x,y,sp,age,mysize,tag,mother,spnum]
# 	[2.5,3.4,2,0,1,0,1],
# 	[2.0,3.0,2,0,1,0,1],
# 	[1.0,3.0,3,0,2.3,0,2],
# 	[3.0,3.0,1,0,1,0,1],
# 	[1.0,3.0,1,0,2.3,0,2],
# 	[3.0,3.0,2,0,2.3,0,2],
# 	[5.0,3.0,3,0,2.3,0,2],
# 	[2.0,3.0,1,0,2.3,0,2],
# 	[6.0,3.0,1,0,2.3,0,2]

# ]
# )
forest=Forest.new(fileio.read_init,fileio.read_fire)
forest

#forest.popluscount
# forest.get_counter_2d
#forest.fire_evoke
counttest=PoplusCount.new(0,0,90,100,5)
counttest.pcount(forest.trees)
a,b,c,d=counttest.get_count_2d
p a
CSV.open('testmap.csv','w') do |test|
	a.each do |buf|
		test<<buf
	end
end


#a,b,c,d=counttest.b_count(forest.trees,0,0)
#  a,b=counttest.count_sprout([1,2],forest.trees,"heiwa")
#  p a
#  p b

#p forest
#forest.kakunin
# p  counttest.betula_kousin(
# 	a,
# 	b,d
# 	2.5)


#counttest.make_betula_sprout
# forest.reset_counter
# forest.yearly_activities
# forest.kakunin
#p forest
