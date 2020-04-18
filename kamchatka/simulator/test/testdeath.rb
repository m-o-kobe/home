require"./settings.rb"
require"./simulator.rb"
require"./forest.rb"
require"./fileio.rb"
require"./tree.rb"
#testsetをsettingに利用
fileio = Fileio.new( "data/testset.csv","data/init.csv","data/output.dat","stat.csv")
tmp=Settings.new()
tmp.load_file( fileio.read_settings )

tree=Tree.new(1,1,3,1,1,0,0,0)
p(tree)
# _x, _y, _sp, _age, _mysize, _tag, _mother
tree.crd=1
tree.kabu=1
tree.is_dead
p(tree)