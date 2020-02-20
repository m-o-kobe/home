require "./settings.rb"
require "./tree.rb"
require "./fire_layer"

class PoplusCount
    def initialize(xmin,ymin,xmax,ymax,step)
        @settings = Settings.new
        @x_max=xmax
        @y_max=ymax
        @x_min=xmin
        @y_min=ymin
        @step=step
        @x_size=(@x_max-@x_min)/@step
        @y_size=(@y_max-@y_min)/@step
#        @counter=Array.new(@x_size).map{Array.new(@y_size,0)}
        @counter_05=Array.new(@x_size).map{Array.new(@y_size,0)}
        @counter_10=Array.new(@x_size).map{Array.new(@y_size,0)}
        @counter_15=Array.new(@x_size).map{Array.new(@y_size,0)}
        @counter_20=Array.new(@x_size).map{Array.new(@y_size,0)}
        @fire_layer=Fire_layer.new        
    end
 
    def pcount(trees)
        for i in 0..@x_size-1
            for j in 0..@y_size-1
                trees.each do |obj|
                    if obj.sp==POPLUS then
                        _dist=dist(obj,i,j)
                        if _dist<5.0
                            @counter_05[i][j]+=obj.mysize
                        elsif _dist<10.0
                            @counter_10[i][j]+=obj.mysize
                        elsif _dist<15.0
                            @counter_15[i][j]+=obj.mysize
                        elsif _dist<20.0
                            @counter_20[i][j]+=obj.mysize
                        end
    
                    end
                end
            end
        end
    end
    
    def reset
        for i in 0..@x_size-1 do
            for j in 0..@y_size-1 do
                @counter_05[i][j]=0.0
                @counter_10[i][j]=0.0
                @counter_15[i][j]=0.0
                @counter_20[i][j]=0.0

            end
        end
    end
    def get_count_2d
        return @counter_05
        return @counter_10
    end
    def get_count(x,y)
        return @counter[x][y]
    end
    def dist( tree_a, plot_x,plot_y )
        x=@step*(plot_x+0.5)
        y=@step*(plot_y+0.5)

		return Math::sqrt((tree_a.x - x)**2 + (tree_a.y - y)**2)#木aと木bの距離。sqは上で定義されている
	end
    def make_poplus_sprout
        #l=0
        sprout_zahyou=Array.new
        for i in 0..@x_size-1 do
            for j in 0..@y_size-1 do
                sprout_kazu=@settings.spdata(POPLUS,"fire1_intercept")+
                @counter_05[i][j]*@settings.spdata(POPLUS,"fire1_05")+
                @counter_10[i][j]*@settings.spdata(POPLUS,"fire1_10")+
                @counter_15[i][j]*@settings.spdata(POPLUS,"fire1_15")+
                @counter_20[i][j]*@settings.spdata(POPLUS,"fire1_20")
                
                sprout_kazu=sprout_kazu.to_i
                #p sprout_kazu
                for k in 1..sprout_kazu
                    # sprout_zahyou[l]=[
                    #     @step*i+rand(0.0..@step),
                    #     @step*j+rand(0.0..@step)
                    # ]
                    sprout_zahyou.push [
                        @step*i+rand(0.0..@step),
                        @step*j+rand(0.0..@step)
                    ]

                    # l += 1
                end
            end
        end
        return sprout_zahyou
    end
end