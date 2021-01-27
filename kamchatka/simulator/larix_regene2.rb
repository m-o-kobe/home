require "./settings.rb"
require "./tree2.rb"
require "./fire_layer"

class LarixRegene
    def initialize(xmin,ymin,xmax,ymax,step)
        @settings = Settings.new
        @x_max=xmax
        @y_max=ymax
        @x_min=xmin
        @y_min=ymin
        @step=step
        @x_size=@x_max-@x_min
        @y_size=@y_max-@y_min
        @menseki=(@x_max-@x_min)*(@y_max-@y_min)
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
   
    def dist( tree_a, plot_x,plot_y )
        x=@step*(plot_x+0.5)
        y=@step*(plot_y+0.5)
        b_x=((@x_max/2.0-x)+tree_a.x) % @x_max
        b_y=((@y_max/2.0-y)+tree_a.y) % @y_max
        return Math::sqrt((@x_max/2.0 - b_x)**2 + (@y_max/2.0 - b_y)**2)
	end
    def shousu(a)
        a_sei=a.to_i
        a_shou=a-a_sei.to_f
        a_sei=rand(0.0..1.0) > a_shou ? a_sei : a_sei+1
        return a_sei
    end

    def make_sprout(trees,fire_or_not)
        fire_or= fire_or_not ? "fire" : "heiwa"
 #       lcount(trees)
        sprout_zahyou=Array.new
        sprout_kazu=@settings.spdata(LARIX,fire_or,"kanyu1")*@menseki
        sprout_kazu=shousu(sprout_kazu)
        for k in 1..sprout_kazu
            sprout_zahyou.push [
                rand(0.0..@x_size),
                rand(0.0..@y_size)
            ]
        end
        return sprout_zahyou
    end
end