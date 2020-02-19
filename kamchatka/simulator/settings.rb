########## 種の持つパラメータ
def params
	return [
		"growth1",#定数
		"growth2",#dbhに比例
		"growth3",#kabuに比例
		"growth4",#crdに比例

		"death11",#定数
		"death12",#dbhに比例
		"death13",#kabuに比例
		"death14",#crdに比例

		"death21",#定数,山火事
		"death22",#dbhに比例,山火事
		"death23",#kabuに比例,山火事
		"death24",#crdに比例,山火事
		
		"kanyu1",#1個体あたりの加入数
		"kanyu2",#ランダム散布割合(⇔親木の周りに分布)
		"kanyu3",#山火事の時の1個体あたり加入数
		"kanyu4",#親木の周りに分布するときの距離

		"kanyu11",#dsを計算する距離限界、親木の周りに分布する場合
		"kanyu12",#定数、親木の周りに分布
		"kanyu13",#dsに比例、親木の周りに分布

		"kanyu21",#dsを計算する距離限界、ランダム
		"kanyu22",#定数、ランダム
		"kanyu23",#dsに比例、ランダム
		"dist_lim",

		"fire1_05",
		"fire1_10",
		"fire1_15",
		"fire1_20",
		"fire1_dbh",
		"fire1_num",
		"fire1_fire",
		"fire1_intercept"

		]
end

class Settings
	@@duration = 0
	@@num_sp = 0
	@@plot_x = 0
	@@plot_y = 0
	@@spdata = Hash.new#hash:配列に追加



	def load_file( setting_array )
		_setdata = Hash.new#ハッシュ(連想配列)_setdataを作成
		setting_array.each do | _buf |#setting_arrayを_bufという変数に入れて1行ずつ実行
			_setdata[ _buf[0] ] = _buf[1].to_f#_setdata[引数]=1行目の内容になる。例_setdata[plot_x]=10000
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
			@@plot_x = _setdata[ "plot_x" ]
		end

		if _setdata[ "plot_y" ] != nil
			@@plot_y = _setdata[ "plot_y" ]
		end
		if _setdata[ "fire_r_min" ] != nil
			@@fire_r_min = _setdata[ "fire_r_min" ]
		end
		if _setdata[ "fire_r_max" ] != nil
			@@fire_r_max = _setdata[ "fire_r_max" ]
		end
		


		for i in 1..@@num_sp do#種数だけ実行
		#種ごとにsp_i_targetができて値が格納される（iは数字、targetはgrowth", "death", "rep", "disp", "juvdeath）
			@@spdata[i] = Hash.new
			params.each do | _target |
				keyword = "sp_" + i.to_s + "_" + _target
				if _setdata[ keyword ] != nil
						@@spdata[i][_target] = _setdata[ keyword ]
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
	def fire_r_min
		return @@fire_r_min
	end
	def fire_r_max
		return @@fire_r_max
	end

	def spdata(i,key)
		return @@spdata[i][key]
	end
end
