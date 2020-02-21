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
				:kabu,
				:sprout,
				:zombie
# Newborn tags: Change if the initial data has >10000 trees
	@@tag = 10001
	@@sprout=10001

	def initialize( _x, _y, _sp, _age, _mysize, _tag, _mother,_sprout )
		@settings = Settings.new
		@x = _x
		@y = _y
		@sp = _sp
		@age = _age
		@mysize = _mysize
		@mother = _mother
		@crd=0.0
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

	def grow
		gro=@settings.spdata( @sp ,"heiwa", "growth1" ) +
			@settings.spdata( @sp ,"heiwa", "growth2" )*@mysize+
			@settings.spdata(@sp,"heiwa","growth3")*@kabu+
			@settings.spdata(@sp,"heiwa","growth4")*@crd
		if gro>=0&&@age>=5 then
			@mysize+=gro
		end
		@age += 1
	end

	def is_dead(fire_or_not,fire_intense)
		seisi=rand(0.0..1.0)
		fire_or= fire_or_not ? "fire" : "heiwa"
		if fire_or_not
			seizonritu=1.0/(1.0+Math::exp(-@settings.spdata(@sp,fire_or,"death1")-
			@settings.spdata(@sp,fire_or,"death2")*@mysize-
			@settings.spdata(@sp,fire_or,"death3")*fire_intense
			))
		else
			if @age<5 && @sp==POPLUS then
				seizonritu=@settings.spdata(POPLUS,"heiwa","death5")
			else
				seizonritu=(1.0/(1.0+Math::exp(-@settings.spdata(@sp,fire_or,"death1")-
				@settings.spdata(@sp,fire_or,"death2")*@mysize-
				@settings.spdata(@sp,fire_or,"death3")*@kabu-
				@settings.spdata(@sp,fire_or,"death4")*@crd)))**(1.0/3.0)
				
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

