require "./settings.rb"
require "./tree.rb"
require "./fire_layer"

class LarixRegene
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
 
    #↓はPopulus tremulaとLarix cajanderiまとめたほうがいい？処理時間かかってるかも
    def lcount(trees)
        reset

        for i in 0..@x_size-1
            for j in 0..@y_size-1
                trees.each do |obj|
                    if obj.sp==LARIX then
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
    #↓あまり意味はない。あえて言うならテスト用
    def get_count_2d
        return @counter_05, @counter_10, @counter_15,@counter_20
        
    end
    #↓作ってはみたが使ってない
    def get_count(x,y)
        return @counter[x][y]
    end
    # def dist( tree_a, plot_x,plot_y )
    #     x=@step*(plot_x+0.5)
    #     y=@step*(plot_y+0.5)

	# 	return Math::sqrt((tree_a.x - x)**2 + (tree_a.y - y)**2)#木aと木bの距離。sqは上で定義されている
    # end
    def dist( tree_a, plot_x,plot_y )
        x=@step*(plot_x+0.5)
        y=@step*(plot_y+0.5)
        b_x=((@x_max/2.0-x)+tree_a.x) % @x_max
        b_y=((@y_max/2.0-y)+tree_a.y) % @y_max
        return Math::sqrt((@x_max/2.0 - b_x)**2 + (@y_max/2.0 - b_y)**2)
	end

    def make_sprout(trees,fire_or_not)
        fire_or= fire_or_not ? "fire" : "heiwa"
        pcount(trees)
        sprout_zahyou=Array.new
        for i in 0..@x_size-1 do
            for j in 0..@y_size-1 do
                sprout_kazu=@counter_05[i][j]*@settings.spdata(LARIX,fire_or,"kanyu1")+
                @counter_10[i][j]*@settings.spdata(LARIX,fire_or,"kanyu2")+
                @counter_15[i][j]*@settings.spdata(LARIX,fire_or,"kanyu3")+
                @counter_20[i][j]*@settings.spdata(LARIX,fire_or,"kanyu4")
                #@settings.spdata(LARIX,fire_or,"fire1")
                sprout_sei=sprout_kazu.to_i
                sprout_shou=sprout_kazu-sprout_sei.to_f
                sprout_sei = rand(0.0..1.0) > sprout_shou ? sprout_sei : sprout_sei+1
                for k in 1..sprout_kazu
                    sprout_zahyou.push [
                        @step*i+rand(0.0..@step),
                        @step*j+rand(0.0..@step)
                    ]
                end
            end
        end
        return sprout_zahyou
    end
end