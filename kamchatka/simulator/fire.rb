require "./settings.rb"
require "./tree.rb"

class Fire
    def initialize(xmin,ymin,xmax,ymax)
        @settings = Settings.new
        @x_max=xmax
        @y_max=ymax
        @x_min=xmin
        @y_min=ymin
        @fire_r_min=@settings.fire_r_min
        @fire_r_max=@settings.fire_r_max
    end
    def fire_evoke
        # @fire_x=rand(@x_min.to_f..@x_max.to_f)
        # @fire_y=rand(@y_min.to_f..@y_max.to_f)
        # @fire_r=rand(@fire_r_min.to_f..@fire_r_max.to_f)
        @fire_x=0.0
        @fire_y=0.0
        @fire_r=5.0
    end
    def ask(tree)
#        p dist(tree,@fire_x,@fire_y)
        return dist(tree,@fire_x,@fire_y)<@fire_r
        
    end
    def dist( tree_a,x,y)
        return Math::sqrt((tree_a.x - x)**2 + (tree_a.y - y)**2)
	end
end