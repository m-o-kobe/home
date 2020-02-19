require "./settings.rb"
require "./tree.rb"
class Fire_layer
#森林火災の強度を返すクラス
    def initialize
        @settings=Settings.new
        @x_max=@settings.plot_x
        @y_max=@settings.plot_y

    end
    def load_file(fire_array)
        xmax=fire_array.size
        ymax=fire_array[1].size
        if @x_max==xmax && @y_max==ymax then
            @@fire_layer=Array.new
            @@fire_layer=fire_array
        else
            p "error: fire_layer to plot no size ga attenaiyo"
        end
    end
    def fire_intensity(x,y)
        return @@fire_layer[x.to_i][y.to_i].to_f
    end    
end