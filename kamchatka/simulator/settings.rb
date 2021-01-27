########## 種の持つパラメータ
def params
	return [
		"growth1",#定数
		"growth2",#dbhに比例
		"growth3",#kabuに比例
		"growth4",#crdに比例

		# "death11",#定数
		# "death12",#dbhに比例
		# "death13",#kabuに比例
		# "death14",#crdに比例

		# "death21",#定数,山火事
		# "death22",#dbhに比例,山火事
		# "death23",#kabuに比例,山火事
		# "death24",#crdに比例,山火事
		"death1",
		"death2",
		"death3",
		"death4",
		"death5",
		"death6",
		"kanyu1",#1個体あたりの加入数
		"kanyu2",#ランダム散布割合(⇔親木の周りに分布)
		"kanyu3",#山火事の時の1個体あたり加入数
		"kanyu4",#親木の周りに分布するときの距離
		"kanyu5",
		"kanyu6",
		"kanyu7",
		"kanyu8",
		"kanyu9",
		"kanyu10",
		"kanyu11",
		"kanyu12"
		# "kanyu11",#dsを計算する距離限界、親木の周りに分布する場合
		# "kanyu12",#定数、親木の周りに分布
		# "kanyu13",#dsに比例、親木の周りに分布

		# "kanyu21",#dsを計算する距離限界、ランダム
		# "kanyu22",#定数、ランダム
		# "kanyu23",#dsに比例、ランダム
		# "dist_lim",

		# "fire1_05",
		# "fire1_10",
		# "fire1_15",
		# "fire1_20",
		# "fire1_dbh",
		# "fire1_num",
		# "fire1_fire",
		# "fire1_intercept"

		]
end
def fire_or_heiwa
	return [
		"fire",#定数
		"heiwa"
		]
end

LARIX=1
BETULA=2
POPLUS=3

class Settings
	@@duration = 0
	@@num_sp = 0
	@@plot_x = 0
	@@plot_y = 0
	@@s_year=0
	@@si50 = 0
	@@spdata = Hash.new#hash:配列に追加
	@@fire_year = Array.new
	def load_file( setting_array )
		_setdata = Hash.new#ハッシュ(連想配列)_setdataを作成
		setting_array.each do | _buf |#setting_arrayを_bufという変数に入れて1行ずつ実行
			_setdata[ _buf[0] ] = _buf[1].to_s #_setdata[引数]=1行目の内容になる。例_setdata[plot_x]=10000
			#ここで作られた配列は種ごとのgrowth", "death", "rep", "disp", "juvdeathとplotの広さ、
		end
		if _setdata[ "duration" ] != nil
			@@duration = _setdata[ "duration" ].to_i
		end
		if _setdata[ "firefreq" ] != nil
			@@firefreq = _setdata[ "firefreq" ].to_i
		end

		if _setdata[ "num_sp" ] != nil
			@@num_sp = _setdata[ "num_sp" ].to_i
		end

		if _setdata[ "plot_x" ] != nil
			@@plot_x = _setdata[ "plot_x" ].to_f
		end

		if _setdata[ "plot_y" ] != nil
			@@plot_y = _setdata[ "plot_y" ].to_f
		end
		if _setdata[ "s_year" ] != nil
			@@s_year = _setdata[ "s_year" ].to_i
		end
		if _setdata[ "fire_year" ] != nil
			@@fire_year = _setdata[ "fire_year" ].split(",")
			@@fire_year.map!{|x| x.to_i}
		end
		if _setdata[ "si50" ] != nil
			@@si50 = _setdata[ "si50" ].to_i
		end


		# if _setdata[ "fire_r_min" ] != nil
		# 	@@fire_r_min = _setdata[ "fire_r_min" ]
		# end
		# if _setdata[ "fire_r_max" ] != nil
		# 	@@fire_r_max = _setdata[ "fire_r_max" ]
		# end
		for i in 1..@@num_sp do
			@@spdata[i] = Hash.new{|h,k| h[k] = {}}
			params.each do | _target |
				fire_or_heiwa.each do |fh|
					keyword = "sp_" + i.to_s + "_" + fh +"_" + _target
					if _setdata[ keyword ] != nil
						@@spdata[i][fh][_target] = _setdata[ keyword ].to_f
					end	
				end
			end
		end

	end
	def duration
		return @@duration
	end
	def firefreq
		return @@firefreq
	end

	def num_sp
		return @@num_sp
	end

	def plot_x
		return @@plot_x
	end

	def plot_y
		return @@plot_y
	end
	def s_year
		return @@s_year
	end
	def fire_year
		return @@fire_year
	end
	def si50
		return @@si50
	end

	# def fire_r_min
	# 	return @@fire_r_min
	# end
	# def fire_r_max
	# 	return @@fire_r_max
	# end
	def spdata(i,fh,key)
		
		#p [i,fh,key]
		return @@spdata[i][fh][key]
	end
end
