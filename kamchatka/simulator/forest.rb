require "./settings.rb"
require "./tree.rb"
require "./poplus_regene.rb"
require "./betula_regene.rb"
require "./fire.rb"

class Forest
	attr_accessor :trees,:pcount,:fire_layer
	@@num_count=Hash.new
	@@death_count=Hash.new
	@@sinki_count=Hash.new
	@@zombie_count=Hash.new
	
	def initialize( init_array,fire_gyouretu )
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
		end
		@pcount=PoplusCount.new(0,0,@settings.plot_x,@settings.plot_y,5)
		@b_regene=BetulaSprout.new(0,0,@settings.plot_x,@settings.plot_y,5)
		@fire_layer=Fire_layer.new()
		@fire_layer.load_file(fire_gyouretu)
		
	end
	def popluscount
		@pcount.reset
		@pcount.count(@trees)
	end
	# def get_counter_2d
	# 	@pcount.get_count_2d
	# end
	# def get_counter
	# 	@pcount.get_count
	# end
	# def make_poplussprout
	# 	@pcount.make_sprout
	# end
	def fire_ask
		@trees.each do |tree|
			p @fire_layer.ask(tree)
		end
	end


	def yearly_activities#成長量･新規･枯死計算
		@year += 1
		reset_counter

		crdcal
#		@pcount.count(@trees)
		if @year%@settings.firefreq==1 then
			fire
			crdcal
		else
			tree_death
			trees_newborn
			crdcal
		end
		trees_grow
		zombie_year
	end
	def reset_counter
		for spp in 1..@settings.num_sp do
			@@num_count[spp]=0
			@@death_count[spp]=0
			@@sinki_count[spp]=0
			@@zombie_count[spp]=0
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
#		fire_evoke
		firedeath
		firesinki
	end
	def zombie_year
		sinu=Array.new
		@trees.each do |tree|
			if tree.zombie<99 then
				tree.zombie-=1
				if tree.zombie<1 then
					sinu.push(tree)
				end
			end
		end
		@trees=@trees-sinu
		for spp in 1..@settings.num_sp do
			@@death_count[spp]+=sinu.count{|item| item.sp==spp}			
		end
	end
	def firedeath
		@trees.each do |tree|
			if tree.is_dead(true,@fire_layer.fire_intensity(tree.x,tree.y)) then
				if tree.zombie>99 then
					tree.zombie=1
					@@zombie_count[tree.sp] += 1
				end
			end
		end
	end
	def kakunin
		puts @@num_count
		puts @@death_count
		puts @@sinki_count
		puts @@zombie_count
	end
	def poplus_regeneration(tf)
		sprout=Array.new
		sprout=@pcount.make_sprout(@trees,tf)
		sprout.each do |spzahyou|
			@@sinki_count[POPLUS] = @@sinki_count[POPLUS] + 1
			@trees.push(Tree.new(
				spzahyou[0],
				spzahyou[1],
				POPLUS,#sp
				0,#age
				0.0,#size
				0,#@tag
				0,#motherのタグ
				0
				))
		end
	end
	def larix_regeneration(tf)
		sprout=Array.new
		sprout=@pcount.make_sprout(@trees,tf)
		sprout.each do |spzahyou|
			@@sinki_count[POPLUS]=@@sinki_count[POPLUS]+1
			@trees.push(Tree.new(
				spzahyou[0],
				spzahyou[1],
				POPLUS,#sp
				0,#age
				0.0,#size
				0,#@tag
				0,#motherのタグ
				0
				))
		end
	end

	def betula_regeneration(tf)
		sprout=Array.new
		sprout=@b_regene.make_sprout(@trees,tf)
		sprout.each do |spzahyou|
			@@sinki_count[BETULA]=@@sinki_count[BETULA]+1
			@trees.push(Tree.new(
				spzahyou[0] % @settings.plot_x,
				spzahyou[1] % @settings.plot_y,
				BETULA,#sp
				0,#age
				0.0,#size
				0,#@tag
				spzahyou[2],#motherのタグ
				spzahyou[3]#sprout_tag
				))
		end
	end

	def firesinki
		#親の元配置を加味した分布も入れる
		for spp in 1..@settings.num_sp do
			if spp==POPLUS then
				poplus_regeneration(true)
			elsif spp==BETULA then
				betula_regeneration(true)
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
	

	def trees_newborn
		for spp in 1..@settings.num_sp do
			if spp==POPLUS then
				poplus_regeneration(false)
			elsif spp==BETULA then
				betula_regeneration(false)
			elsif spp==LARIX then
				larix_regeneration(false)
			end
		end
	end

	def tree_death
		@trees.each do |tree|
			if tree.zombie>99 then
				if tree.is_dead(false,0) then
					tree.zombie=0
				end
			end
		end

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