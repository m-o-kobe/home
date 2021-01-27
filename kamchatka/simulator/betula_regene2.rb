require "./settings.rb"
require "./tree2.rb"
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
        @menseki=(@x_max-@x_min)*(@y_max-@y_min)
        @heiwakazu=@settings.spdata(BETULA,"heiwa","kanyu1")   
        #@heiwakazu=0.101
        @hougaritu=@settings.spdata(BETULA,"heiwa","kanyu2")
#        @hougaritu=334.0/(171.0+334.0)

        #https://www.jstage.jst.go.jp/article/esj/ESJ51/0/ESJ51_0_339/_article/-char/ja/
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

    def count_sprout(sp_num,oya,fire_or)
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
            juv=@settings.spdata(BETULA,fire_or,"kanyu8")+
                parent_num*@settings.spdata(BETULA,fire_or,"kanyu9")+
                fire*@settings.spdata(BETULA,fire_or,"kanyu10")+
                parent_dbh*@settings.spdata(BETULA,fire_or,"kanyu11")+
                parent_dbh*fire*@settings.spdata(BETULA,fire_or,"kanyu12")
                
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
    def make_sprout(trees,fire_or_not)
        sprout_zahyou=Array.new
        if fire_or_not then
            fire_or= "fire"
            for i in 0..@x_size-1 do
                for j in 0..@y_size-1 do
                    oya, oyakazu, oyasize,sp_num= b_count(trees,i,j)
                    fire=@fire_layer.fire_intensity((i+0.5)*@step,(j+0.5)*@step)
                    sprout_kazu=@settings.spdata(BETULA,fire_or,"kanyu1")+
                        oyasize*@settings.spdata(BETULA,fire_or,"kanyu2")+
                        oyakazu*@settings.spdata(BETULA,fire_or,"kanyu3")+
                        fire*@settings.spdata(BETULA,fire_or,"kanyu4")+
                        oyasize*oyakazu*@settings.spdata(BETULA,fire_or,"kanyu5")+
                        oyasize*fire*@settings.spdata(BETULA,fire_or,"kanyu6")+
                        oyakazu*fire*@settings.spdata(BETULA,fire_or,"kanyu7")
                    if sprout_kazu>0 then
                        if oyakazu>0 then
                            oya_info,juv_sum=count_sprout(sp_num,oya,fire_or)
                            sprout_zahyou.concat kabudati_kousin(oya_info,juv_sum,sprout_kazu)
                        else
                            sprout_zahyou.concat dokuritu_kousin(sprout_kazu,i,j)
                        end
                    end
                end
            end
        else
            sprout_zahyou=kousin_heiwa(trees)
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
    def shousu(a)
        a_sei=a.to_i
        a_shou=a-a_sei.to_f
        a_sei=rand(0.0..1.0) > a_shou ? a_sei : a_sei+1
        return a_sei
    end
    def kousin_heiwa(trees)
        sprout_zahyou=Array.new
        sinki_kazu=@heiwakazu*@menseki
        sprout_kazu=sinki_kazu*@hougaritu
        dokuritu_kazu=sinki_kazu-sprout_kazu
        oya, oyakazu, oyasize,sp_num = b_count_all(trees)
        sprout_kazu=shousu(sprout_kazu)
        dokuritu_kazu=shousu(dokuritu_kazu)
        if oyakazu>0 then
            sprout_zahyou.concat kabudati_kousin_all(oya,sprout_kazu)
            sprout_zahyou.concat dokuritu_kousin_all(dokuritu_kazu)
        else
            sprout_zahyou.concat dokuritu_kousin_all(dokuritu_kazu+sprout_kazu)
        end
        return sprout_zahyou
    end
    
    def b_count_all(trees)
        oya=Array.new
        sum_size=0
        sp_num=Array.new
        trees.each do |tree|
            if tree.mysize>0.0 && 
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
    def kabudati_kousin_all(oya_info,sprout_kazu)
        sprout_zahyou=Array.new
            for k in 1..sprout_kazu
                oyagi=oya_info.sample
                kyori=rand(0.0..0.05)
                kaku=rand(0.0..2.0)*Math::PI
                
                sprout_zahyou.push [
                    oyagi.x+kyori*Math.sin(kaku),
                    oyagi.y+kyori*Math.cos(kaku),
                    oyagi.tag,
                    oyagi.sprout
                ]
            end
        return sprout_zahyou
    end
    def dokuritu_kousin_all(kazu)
        juv_zahyou=Array.new
        for k in 1..kazu
            juv_zahyou.push [
                rand(0.0..1.0)*@step*@x_size,
                rand(0.0..1.0)*@step*@y_size,
                0,
                "newsprout"
            ]    
        end
        return juv_zahyou
    end
    def kabudati_kousin(oya_info,juv_sum,sprout_kazu)
        sprout_zahyou=Array.new
        seigen=Hash.new
        oya_info.each do |oya|
            kousinhonsuu=sprout_kazu*oya.juv/juv_sum
            kousin_sei=kousinhonsuu.to_i
            kousin_shou=kousinhonsuu-kousin_sei.to_f
            kousin_sei = rand(0.0..1.0) > kousin_shou ? kousin_sei : kousin_sei+1
            for k in 1..kousin_sei
                oyagi=oya.trees.sample
                kyori=rand(0.0..0.05)
                kaku=rand(0.0..2.0)*Math::PI
                if seigen[oyagi.sprout].nil? then
                    seigen[oyagi.sprout]=1
                else
                    seigen[oyagi.sprout]+=1
                end
                if seigen[oyagi.sprout]<20 then
                    sprout_zahyou.push [
                        oyagi.x+kyori*Math.sin(kaku),
                        oyagi.y+kyori*Math.cos(kaku),
                        oyagi.tag,
                        oyagi.sprout
                    ]
    
                end
            end
        end
        return sprout_zahyou
    end

end
