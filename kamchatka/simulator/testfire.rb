require"./settings.rb"
require"./forest.rb"
require"./fileio.rb"
require"./fire.rb"
require"./fire_layer.rb"
fileio = Fileio.new("data/testset.csv",
	"data/init.csv",
	"data/output.csv",
	"data/output.csv",
	"data/fire.csv")
tmp=Settings.new()
tmp.load_file( fileio.read_settings)
fir=Fire_layer.new()
fir.load_file(fileio.read_fire)
p fir.fire_intensity(50,10)

fire=Array.new(90).map{Array.new(100,0)}
for x in 0..89 do
	for y in 0..99 do
		fire[x][y]=fir.fire_intensity(x,y)
	end
end 
CSV.open('testfire.csv','w') do |test|
	fire.each do |buf|
		test<<buf
	end
end

# forest=Forest.new(
# 	[
# 	[0.0,2.0,3,10,10,0,1],#[x,y,sp,age,mysize,tag,mother,spnum]
# 	[0.0,3.4,3,0,1,0,1],
# 	[8.0,3.0,3,0,1,0,1],
# 	[5.0,3.0,3,0,1,0,1]
# 	]
# )

# fire=Fire.new(0,0,20,20)
# fire.fire_evoke
# p fire
#forest.fire_ask
#p forest.fire_layer
