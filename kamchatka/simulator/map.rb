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
        
        #@lim=@settings.spdata(3,"dist_lim")
        
    end
 
    def pcount(trees)
        for i in 0..@x_size-1
            for j in 0..@y_size-1
                trees.each do |obj|
                    if obj.sp==3 then
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
                sprout_kazu=@settings.spdata(3,"fire1_intercept")+
                @counter_05[i][j]*@settings.spdata(3,"fire1_05")+
                @counter_10[i][j]*@settings.spdata(3,"fire1_10")+
                @counter_15[i][j]*@settings.spdata(3,"fire1_15")+
                @counter_20[i][j]*@settings.spdata(3,"fire1_20")
                
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
    def b_count(trees,i,j)
        oya=Array.new
        sum_size=0
        sp_num=Array.new
        trees.each do |tree|
            if  tree.x>@step*i &&
                     tree.x<=@step*(i+1) &&
                     tree.y>@step*j &&
                     tree.y<=@step*(j+1)&&
                     tree.mysize>0.0 &&
                     tree.sp==2 then
                oya.push(tree)
                sum_size+=tree.mysize
                sp_num.push(tree.sprout)                
            end    
        end
        oyanum=oya.length
        ave_size= oyanum==0 ? 0 : sum_size / oyanum
        sp_num=sp_num.uniq
        return oya, oyanum, ave_size, sp_num
    end
    def betula_kousin(oya_info,juv_sum,sprout_kazu)
        sprout_zahyou=Array.new
        oya_info.each do |oya|
            kousinhonsuu=sprout_kazu*oya[4]/juv_sum
            kousin_sei=kousinhonsuu.to_i
            kousin_shou=kousinhonsuu-kousin_sei.to_f
            kousin_sei = rand(0.0..1.0) > kousin_shou ? kousin_sei : kousin_sei+1
            for k in 1..kousin_sei
                oyagi=oya[5].sample
                kyori=rand(0.0..0.05)
                kaku=rand(0.0..2.0)*Math::PI
                sprout_zahyou.push [
                    oyagi.x+kyori*Math.sin(kaku),
                    oyagi.y+kyori*Math.cos(kaku),
                    oyagi.tag,
                    oyagi.sprout
                ]
            end
        end
        return sprout_zahyou
    end
    def count_betula_sprout(sp_num,oya)
        oya_info=Array.new
        juv_sum=0.0
        # sp_goto_oya=Array.new
        sp_num.each do |bp_parents|
            parent_num=0
            parent_dbh=0.0
            parent_x=0.0
            parent_y=0.0
  #          sp_oya=Array.new
            #sp_oya.push(bp_parents)
   #         sp_oya_=Array.new
            parent=oya.select{|tree| tree.sprout==bp_parents}
            parent.each do |tree|
                    parent_x+=tree.x
                    parent_y+=tree.y
                    parent_num+=1
                    parent_dbh+=tree.mysize
            end
            parent_dbh=parent_dbh/parent_num
            parent_x=parent_x/parent_num
            parent_y=parent_y/parent_num
            fire=@fire_layer.fire_intensity(parent_x,parent_y)
            juv=parent_dbh*0.5+parent_num*0.5*fire+0.5
            juv_sum+=juv
            oya_info.push([bp_parents,parent_num,parent_dbh,fire,juv,parent])
            # sp_goto_oya.push(sp_oya)
            #oya_infoの値の順はなるべく変えない。変えるときはbetula_kousinも変える必要がある
        end
        return oya_info,juv_sum#,sp_goto_oya
    end
    def make_betula_sprout(trees)
        sprout_zahyou=Array.new
        for i in 0..@x_size-1 do
            for j in 0..@y_size-1 do
                oya, oyakazu, oyasize,sp_num= b_count(trees,i,j)
                fire=@fire_layer.fire_intensity((i+0.5)*@step,(j+0.5)*@step)
                # sprout_kazu=@settings.spdata(2,"fire1_intercept")+
                # @counter_05[i][j]*@settings.spdata(2,"fire1_size")+
                # @counter_10[i][j]*@settings.spdata(2,"fire1_num")+
                # @counter_10[i][j]*@settings.spdata(2,"fire1_num")
                sprout_kazu=0.0+
                oyasize*0.5+
                oyakazu*0.5+
                fire*0.5
                if sprout_kazu>0 then
                    if oyakazu>0 then
                        oya_info,juv_sum=count_betula_sprout(sp_num,oya)
#                        juv_zahyou=betula_kousin(oya_info,juv_sum,sprout_kazu)
                        sprout_zahyou.concat betula_kousin(oya_info,juv_sum,sprout_kazu)
                    else
                        sprout_zahyou.concat dokuritu_kousin(sprout_kazu,i,j)
                    end
                end
            end
        end
        return sprout_zahyou
    end
    def dokuritu_kousin(sprout_kazu,i,j)
        kousin_sei=sprout_kazu.to_i
        kousin_shou=sprout_kazu-kousin_sei.to_f
        kousin_sei = rand(0.0..1.0) > kousin_shou ? kousin_sei : kousin_sei+1
        juv_zahyou=Array.new
       

        for k in 1..kousin_sei
            juv_zahyou.push [
                (i+rand(0.0..1.0))*@step,
                (j+rand(0.0..1.0))*@step,
                0,
                "newsprout"
            ]    
        end
        return juv_zahyou
    end
end