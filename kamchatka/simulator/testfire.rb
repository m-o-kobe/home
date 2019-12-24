require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./fire.rb"
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","data/output.dat")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )

forest=Forest.new(
	[
	[0.0,2.0,3,10,10,0,1],#[x,y,sp,age,mysize,tag,mother,spnum]
	[0.0,3.4,3,0,1,0,1],
	[8.0,3.0,3,0,1,0,1],
	[15.0,3.0,3,0,1,0,1]
	]
)

# fire=Fire.new(0,0,20,20)
# fire.fire_evoke
# p fire
#forest.fire_ask
#p forest.fire_layer
p forest
forest.fire_evoke


forest.tree_death
p forest
forest.firedeath
p "sinu"
p forest



# p "Feuer!"
# p forest
# forest.zombie_year
# p forest
# forest.zombie_year
# p forest
# tree=Tree.new(
# 	0.0,0.0,3,10,10,0,0,1
#  )
# p tree
# p fire.ask(tree)
# tizu=PoplusCount.new(0,0,20,20,5)
# p tizu.dist(tree,1,1)
#p forest.trees
