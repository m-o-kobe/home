require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./map.rb"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","data/output.dat")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )

forest=Forest.new(
	[
	[5.0,5.0,3,10,10.5,0,1],#[x,y,sp,age,mysize,tag,mother,spnum]
	[2.5,3.4,3,0,1,0,1],
	[8.0,3.0,3,0,1,0,1],
	[15.0,3.0,3,0,2.3,0,1]
	]
)
for i in 1..0
	p i
end
# tree=Tree.new(
# 	8,7.5,3,10,10,0,0,1
# )
# p tree
# tizu=PoplusCount.new(0,0,20,20,5)
# p tizu.dist(tree,1,1)
#p forest.trees
forest.popluscount
p forest.get_counter_2d
p forest.make_poplussprout

