require "./settings.rb"
require "./tree.rb"
require "./map.rb"

class Forest
	attr_accessor :trees,:pcount
	@@num_count=Hash.new
	@@death_count=Hash.new
	@@sinki_count=Hash.new
	
	def initialize( init_array )
		@year = 0
		@settings = Settings.new
		@trees = Array.new
		init_array.each do | buf |
		@trees.push(  Tree.new( 
			buf[0],
			buf[1],
			buf[2],
			buf[3],
			buf[4],
			buf[5],
			0,
			buf[6]
			) )#Treeクラスはtree.rbで定義
#		@plotmap=Array.new(@settings.plot_x/5).map{Array.new(@settings.plot_y/5)}
		@pcount=PoplusCount.new(0,0,@settings.plot_x,@settings.plot_y,5)
		end
		
	end
	def popluscount(trees)
	#	@pcount.reset
		@pcount.count(trees)
	end
	def get_counter_2d
		@pcount.get_count_2d
	end
	def get_counter(x,y)
		@pcount.get_count
	end
	def make_poplussprout
		@pcount.make_sprout
	end


	def yearly_activities#成長量･新規･枯死計算
		@year += 1
		reset_counter
		crdcal
		if @year%@settings.firefreq==0 then
			fire
			crdcal
		else
			trees_newborn
			tree_death
		end
		trees_grow
	end
	def reset_counter
		for spp in 1..@settings.num_sp do
			@@num_count[spp]=0
			@@death_count[spp]=0
			@@sinki_count[spp]=0
		end
	end
	
	def stat_records
		buf=Array.new
		buf.push([@year]+["num"]+[@@num_count.values])
		buf.push([@year]+["death"]+[@@death_count.values])
		buf.push([@year]+["sinki"]+[@@sinki_count.values])

		return buf
	end
	
	def fire
		firedeath
		firesinki
	end
	def firedeath
		sinu=@trees.select{
			|tree| tree.fire_dead
		}
		for spp in 1..@settings.num_sp do
			@@death_count[spp]+=sinu.count{|item| item.sp==spp}
		end
		@trees=@trees-sinu

	end
	def kakunin
		puts @@num_count
		puts @@death_count
		puts @@sinki_count
	end
	def firesinki
		for spp in 1..@settings.num_sp do
			oyagi=Array.new
			oyagi=oyagiselect(spp)
			oyakazu=oyagi.count
			kanyuusuu=(oyakazu*@settings.spdata(spp,"kanyu3")).to_i
			@@sinki_count[spp]+=kanyuusuu
			for i in 1..kanyuusuu do
				
					for j in 1..1000 do
						oya=rand(oyakazu)-1
						#親木を選ぶ
						kyori=rand(0.0..1.0)*@settings.spdata(spp,"kanyu4")
						kaku=rand(0.0..2.0*Math::PI)
						kouhox=oyagi[oya].x+kyori*Math.sin(kaku)#@x
						kouhoy=oyagi[oya].y+kyori*Math.cos(kaku)#@y
						ds=0.0
						@trees.each do |obj|
							_dist =((kouhox-obj.x)**2.0+(kouhoy-obj.y)**2.0)**0.5
							if _dist<@settings.spdata(spp,"kanyu11")&&obj.sp!=spp
								if _dist==0.0
									ds+=obj.mysize/0.01
								else
									ds+=obj.mysize/_dist
								end
							end
						end
						kanyu=rand(0.0..1.0)
						kanyuritu=1.0/(1.0+Math::exp(-@settings.spdata(spp,"kanyu12")-ds*@settings.spdata(spp,"kanyu13")))
						if kanyu<kanyuritu
							@trees.push(Tree.new(
								kouhox,
								kouhoy,
								spp,
								0,#age
								0.0,#size
								0,#@tag
								oyagi[oya].tag,#motherのタグ
								oyagi[oya].sprout
								))
							break
						end
					end
				
			end
		end
	end

	def records
		buf = Array.new
		@trees.each do | tree |
			buf.push( [ @year ]+tree.record )
		end
		return buf
	end

	################
	# Internal routine

	def trees_grow
		@trees.each do | tree |
			tree.grow
			@@num_count[tree.sp]+=1
		end
	end
	
	def oyagiselect(sp)
		oyagi=Array.new
		oyagi=@trees.select{
				|tree| tree.sp==sp&&tree.mysize>5.0
			}
		return oyagi
	end

	def trees_newborn
		
		for spp in 1..@settings.num_sp do
			oyagi=Array.new
			oyagi=oyagiselect(spp)
			oyakazu=oyagi.count
			kanyuusuu=(oyakazu*@settings.spdata(spp,"kanyu1")).to_i
			@@sinki_count[spp]+=kanyuusuu
			for i in 1..kanyuusuu do
				if @settings.spdata(spp,"kanyu2")<=rand(0.0..1.0)#加入場所がランダムか親木の周りかの決定
					for j in 1..1000 do
						oya=rand(oyakazu)-1
						#親木を選ぶ
						kyori=rand(0.0..1.0)*@settings.spdata(spp,"kanyu4")
						kaku=rand(0.0..2.0*Math::PI)
						kouhox=oyagi[oya].x+kyori*Math.sin(kaku)#@x
						kouhoy=oyagi[oya].y+kyori*Math.cos(kaku)#@y
						ds=0.0
	
						@trees.each do |obj|
							_dist =((kouhox-obj.x)**2.0+(kouhoy-obj.y)**2.0)**0.5
							if _dist<@settings.spdata(spp,"kanyu11")&&obj.sp!=spp
								if _dist==0.0
									ds+=obj.mysize/0.01
								else
									ds+=obj.mysize/_dist
								end
							end
						end
						kanyu=rand(0.0..1.0)
						kanyuritu=1.0/(1.0+Math::exp(-@settings.spdata(spp,"kanyu12")-ds*@settings.spdata(spp,"kanyu13")))
						if kanyu<kanyuritu
							@trees.push(Tree.new(
								kouhox,
								kouhoy,
								spp,
								0,#age
								0.0,#size
								0,#@tag
								oyagi[oya].tag,#motherのタグ
								oyagi[oya].sprout
								))

							break
						end
					end
				else
					for j in 1..1000 do
						kouhox=rand(0.0..@settings.plot_x)
						kouhoy=rand(0.0..@settings.plot_y)#@y
						ds=0.0
	
						@trees.each do |obj|
							_dist =((kouhox-obj.x)**2.0+(kouhoy-obj.y)**2.0)**0.5
							if _dist<@settings.spdata(spp,"kanyu21")&&obj.sp!=spp
								if _dist==0.0
									ds+=obj.mysize/0.01
								else
									ds+=obj.mysize/_dist
								end
							end
						end
	
						kanyu=rand(0.0..1.0)
						kanyuritu=1.0/(1.0+Math::exp(-ds*@settings.spdata(spp,"kanyu22")-@settings.spdata(spp,"kanyu23")))
	
						if kanyu<kanyuritu
							@trees.push(Tree.new(
								kouhox,
								kouhoy,
								spp,
								0,#age
								0.0,#size
								0,#@tag
								oyagi[rand(oyakazu)-1].tag,#motherのタグ
								"newsprout"
								))

							break
						end
					end
				end
			end
		end
	end

	def tree_death
		sinu=@trees.select{
			|tree| tree.is_dead
		}
		for spp in 1..@settings.num_sp do
			@@death_count[spp]+=sinu.count{|item| item.sp==spp}
		end
		@trees=@trees-sinu
	end
	def crdcal
		@trees.each do |tar|
			tar.crd=0.0
			tar.kabu=0.0
			@trees.each do | obj |#treesのデータがobjに格納された上で以下の処理を繰り返す
				if obj.tag != tar.tag then#obj.num≠target.numberならば･･･
					_dist =dist(tar, obj)#targetとobjの距離を_distで返す
					if _dist<9.0
						if tar.sprout==obj.sprout&&tar.sprout!=0
							if _dist==0.0
								tar.kabu+=obj.mysize/0.01
							else
								tar.kabu+=obj.mysize/_dist
							end
						else
							if _dist==0.0
								tar.crd+=obj.mysize/0.01
							else
								tar.crd+=obj.mysize/_dist
							end
						end
					end
				end
			end
		end
	end
	
	def dist( tree_a, tree_b )
		return Math::sqrt(sq(tree_a.x - tree_b.x) + sq(tree_a.y - tree_b.y))#木aと木bの距離。sqは上で定義されている
	end
	
	def sq(_flt)
		return _flt * _flt
	end
	

end