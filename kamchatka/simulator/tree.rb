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
				:sprout
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
		#tagは木の一本ずつに振ってある番号
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
		gro=@settings.spdata( @sp , "growth1" ) +@settings.spdata( @sp , "growth2" )*@mysize+@settings.spdata(@sp,"growth3")*@kabu+@settings.spdata(@sp,"growth4")*@crd
		if gro>=0&&@age>=5 then
			@mysize+=gro
		end
		@age += 1
	end

	def is_dead
		seisi=rand(0.0..1.0)
		if @age<5&&@sp==3 then
			seizonritu=0.122
		else
			seizonritu=(1.0/(1.0+Math::exp(-@settings.spdata(@sp,"death11")-@settings.spdata(@sp,"death12")*@mysize-@settings.spdata(@sp,"death13")*@kabu-@settings.spdata(@sp,"death14")*@crd)))**(1.0/3.0)
		end

		return seisi>seizonritu
	end
	
	def fire_dead
		seisi=rand(0.0..1.0)
		seizonritu=1.0/(1.0+Math::exp(-@settings.spdata(@sp,"death21")-@settings.spdata(@sp,"death22")*@mysize-@settings.spdata(@sp,"death23")*@kabu-@settings.spdata(@sp,"death24")*@crd))
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

