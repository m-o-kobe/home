require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./poplus_regene.rb"
require"./betula_regene.rb"
require"./tree.rb"

fileio = Fileio.new( "data/setting_test.csv","../../../kamchatka/setting/init_fire0302.csv",
	"data/output.dat",
	"data/output.dat",
	"data/fire.csv")
tmp=Settings.new()

# hash = Hash.new { |h,k| h[k] = {} }

# hash["a"]["b"] = 1
# p hash["a"]["b"]
tmp.load_file( fileio.read_settings)

# forest=Forest.new(
# 	[
# 	[0.01,0.01,2,10,10.5,0,2],#[x,y,sp,age,mysize,tag,mother,spnum]
# 	[0.01,0.02,2,0,1,0,1],
# 	[0.01,0.03,2,0,1,0,1],
# 	[0.03,0.01,2,0,2.3,0,2]
# 	],
# 	fileio.read_fire
# )
forest=Forest.new(
	fileio.read_init,
	fileio.read_fire
)

counttest=PoplusCount.new(0,0,90,100,5)
counttest.pcount(forest.trees)
count05=Array.new(18).map{Array.new(20,0)}
#p forest
for x in 0..17 do
	for y in 0..19 do
		count05[x][y]=counttest.get_count(x,y)
	end
end 
CSV.open('../../../test0405_20.csv','w') do |test|
	count05.each do |buf|
		test<<buf
	end
end
