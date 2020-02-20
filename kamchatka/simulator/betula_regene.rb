require "./settings.rb"
require "./tree.rb"
require "./fire_layer"
class OyakabuBetula
    attr_accessor :trees, 
    :parent_honsu,
    :ave_dbh,
    :fire,
    :juv,
    :parent
    def initialize(bp_parents,parent_num,parent_dbh,fire,juv,parent)
        @sp_num=bp_parents
        @parent_honsu=parent_num
        @ave_dbh=parent_dbh
        @fire=fire
        @juv=juv
        @trees=parent
        #bp_parents,parent_num,parent_dbh,fire,juv,parent
    end
end
class BetulaSprout
    def initialize(xmin,ymin,xmax,ymax,step)
        @settings = Settings.new
        @x_max=xmax
        @y_max=ymax
        @x_min=xmin
        @y_min=ymin
        @step=step
        @x_size=(@x_max-@x_min)/@step
        @y_size=(@y_max-@y_min)/@step
        @fire_layer=Fire_layer.new        
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
                     tree.sp==BETULA then
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
            kousinhonsuu=sprout_kazu*oya.juv/juv_sum
            kousin_sei=kousinhonsuu.to_i
            kousin_shou=kousinhonsuu-kousin_sei.to_f
            kousin_sei = rand(0.0..1.0) > kousin_shou ? kousin_sei : kousin_sei+1
            for k in 1..kousin_sei
                oyagi=oya.trees.sample
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
    def count_betula_sprout(sp_num,oya,fire_or)
        oya_info=Array.new
        oya_info=Array.new
        juv_sum=0.0
        sp_num.each do |bp_parents|
            parent_num=0
            parent_dbh=0.0
            parent_x=0.0
            parent_y=0.0
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
            juv=parent_dbh*@settings.spdata(2,fire_or,"kanyu5")+
            parent_num*@settings.spdata(2,fire_or,"kanyu6")+
            fire*@settings.spdata(2,fire_or,"kanyu7")+
            @settings.spdata(2,fire_or,"kanyu8")

            juv_sum+=juv
            oya_info.push OyakabuBetula.new(
                bp_parents,
                parent_num,
                parent_dbh,
                fire,
                juv,
                parent)
        end
        return oya_info,juv_sum
    end
    def make_betula_sprout(trees,fire_or_not)
        sprout_zahyou=Array.new
        fire_or= fire_or_not ? "fire" : "heiwa"
        for i in 0..@x_size-1 do
            for j in 0..@y_size-1 do
                oya, oyakazu, oyasize,sp_num= b_count(trees,i,j)
                fire=@fire_layer.fire_intensity((i+0.5)*@step,(j+0.5)*@step)
                 sprout_kazu=@settings.spdata(2,fire_or,"kanyu1")+
                oyasize*@settings.spdata(2,fire_or,"kanyu2")+
                oyakazu*@settings.spdata(2,fire_or,"kanyu3")+
                fire*@settings.spdata(2,fire_or,"kanyu4")
                if sprout_kazu>0 then
                    if oyakazu>0 then
                        oya_info,juv_sum=count_betula_sprout(sp_num,oya,fire_or)
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
    # def rand(x)
    #     return (x.first+x.last)/2
    # end
end