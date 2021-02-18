require "./settings.rb"
class Tree
	
	###############
	attr_accessor :x,
				:y,
				:sp,
				:age, 
				:mysize,
				:tag, 
				:mother,
				:crd,
				:ba,
				:kabu,
				:sprout,
				:zombie,
				:ds3,
				:ds6_10
# Newborn tags: Change if the initial data has >10000 trees
	@@tag = 10001
	@@sprout=10001
	def initialize( _x, _y, _sp, _age, _mysize, _tag, _mother,_sprout)
		@settings = Settings.new
		@x = _x
		@y = _y
		@sp = _sp
		@age = _age
		@mysize = _mysize
		@mother = _mother
		@crd=0.0
		@ds3=0
		@ds6_10=0
		@ba=0.0
		@kabu=0.0
		@zombie=100
		if _tag != 0 then
			@tag = _tag
			
		else
			@tag = @@tag
			@@tag += 1
		end
		if _sprout != "newsprout" then
			@sprout=_sprout
			
		else
			@sprout = @@sprout
			@@sprout += 1
		end

	end

	def grow(si50)
		if @sp==POPLUS then
			gro=@settings.spdata( @sp ,"heiwa", "growth1" )+
			@settings.spdata( @sp ,"heiwa", "growth2" )*si50
			#p gro
		else
			gro=@settings.spdata( @sp ,"heiwa", "growth1" ) +
			@settings.spdata( @sp ,"heiwa", "growth2" )*@mysize+
			@settings.spdata(@sp,"heiwa","growth3")*@kabu+
			@settings.spdata(@sp,"heiwa","growth4")*@crd

		end
		if gro>=0&&@age>=2 then
			@mysize+=gro
		end
		@age += 1
	end
	def seizon_bp(xx)
		if xx>1 then
			para1=0.8192
			paralam=0.007346
			parak=1.324243
			return Math::exp(-paralam*(xx+1)**parak)/Math::exp(-paralam*xx**parak) 	
		
		end
	end

	def is_dead(fire_or_not,fire_intense,ba,year)
		seisi=rand(0.0..1.0)
		fire_or= fire_or_not ? "fire" : "heiwa"
		
		if fire_or_not
			seizonritu=1.0/(1.0+Math::exp(-
			@settings.spdata(@sp,fire_or,"death1")-
			@settings.spdata(@sp,fire_or,"death2")*@mysize-
			@settings.spdata(@sp,fire_or,"death3")*fire_intense-
			@settings.spdata(@sp,fire_or,"death4")*fire_intense*@mysize
			))
		else
			if age<2 then
				seizonritu=@settings.spdata(@sp,"heiwa","death5")
				#p [@sp,seizonritu]
				
			else
				if @sp==POPLUS then
					seizonritu=(1.0/(1.0+Math::exp(-
						@settings.spdata(@sp,fire_or,"death1")-
						@settings.spdata(@sp,fire_or,"death2")*@mysize-
						@settings.spdata(@sp,fire_or,"death3")*@ba-
						@settings.spdata(@sp,fire_or,"death4")*year)))**0.2
					if @age>100 then
						seizonritu=0.0
						#https://academic.oup.com/forestry/article/84/1/61/599262?login=true
					end
				elsif @sp==BETULA then
					seizonritu=seizon_bp(@age)
					#p [@age,seizonritu]
				elsif @sp==LARIX then

					# seizonritu=(1.0/(1.0+Math::exp(-
					# @settings.spdata(@sp,fire_or,"death1")-
					# @settings.spdata(@sp,fire_or,"death2")*@mysize-
					# @settings.spdata(@sp,fire_or,"death3")*@kabu-
					# @settings.spdata(@sp,fire_or,"death4")*@crd)))**
					# (@settings.spdata(@sp,fire_or,"death6")/3.0)
					# seizon=1.6
					# seizon3=-1.0
					# seizon7_9=0.5
					seizon=@settings.spdata(@sp,fire_or,"death1")
					seizon3=@settings.spdata(@sp,fire_or,"death2")
					seizon7_9=@settings.spdata(@sp,fire_or,"death3")
					
					seizonritu=	1.0/(1.0+Math::exp(-seizon-@ds3*seizon3-@ds6_10*seizon7_9))
					if @age>500 then
						seizonritu=0.0
					end
					#p [seizonritu,@crd,@sp]
				end
			end	
		end
		return seisi>seizonritu
	end

	def record
		return [ @x, @y, @sp, @age, @mysize, @tag, @mother,@crd,@kabu,@sprout ] 
	end

	##############################
	#### for debug
	def show_status
		print @tag, ": ", @sp, "@ (", @x, ",", @y, ")-", @mysize, "\n"
	end
end