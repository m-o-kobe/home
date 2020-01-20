$targetspp="pt"#ここで樹種を変える"pt"or"bp"or"lc"
plot="ctr"
#$cal="grow"#"da"or"grow"
limlim=9
infile1 = File.open("../../../kamchatka/fire_poplus.csv", "r")
infile2 = File.open("../../../kamchatka/map.csv", "r")

$xmax=90.0#プロットサイズ
	$ymax=100.0
	$xmin=0.0
	$ymin=0.0

$xmid=$xmin+($xmax-$xmin)/2
$ymid=$ymin+($ymax-$ymin)/2
class Tree #クラスTreeを定義
	attr_accessor :num, :x, :y, :spp, :dbh01, :dbh04, :hgt, :sprout, :edge_x,:edge_y,:dgrw,:death,:sc#インスタンス変数を読み書きするためのアクセサメソッドを定義
	def initialize( line ) #オブジェクト作成時必ず実行される処理.()内をlineに読み込む
		buf = line.chop.split(",")#lineの最後の文字を消し(chop),","を区切り文字とした配列をbufに読み込み
		
		@num = buf[0].to_i#配列の1列目を整数型に変換して@numに格納。@numはインスタンス変数
		@x   = buf[1].to_f#浮動小数点型。後は同上
		@y   = buf[2].to_f
		@spp = buf[3]
		@dbh01=buf[4].to_f
		@dbh04=buf[5].to_f
		@hgt = buf[6].to_f
		@sprout=buf[7].to_i
		@crd=Hash.new(0)
		@sc=0
		if @x>$xmid
			@edge_x=$xmax-@x
		else
			@edge_x=@x-$xmin
		end
		if @y>$ymid
			@edge_y=$ymax-@y
		else
			@edge_y=@y-$ymin
		end

	end
	
	def get_crd( order )
		return @crd[order]
	end
	
	def set_crd( order, value )
		return @crd[order]=value
	end
end
def dgrw(dbh04,dbh01)#dgrwは成長量
		return (dbh04-dbh01)/3
end

def sq (_flt)
	return _flt * _flt
end
def dist( tree_a, tree_b )
	return Math::sqrt(sq(tree_a.x+2.5 - tree_b.x) + sq(tree_a.y+2.5 - tree_b.y))#木aと木bの距離。sqは上で定義されている
end
def edge_effect( a, x, y )#エッジ効果は林縁部にかかる効果
	if  y > x	# yがxより大きかったらxとyを入れ替えるためのif　よって常にx>y
		_tmp = x
		x = y
		y = _tmp
	end
	if y<0
		print x
		print y
	end
	#####################
	if( x >=a && y >=a )
		return 1.0
	else
		if( x >=a && y < a )
			return( Math::PI*sq(a) - sq(a)*Math::acos(y/a) + y*Math::sqrt( sq(a)-sq(y) ) ) / (sq(a)*Math::PI)
		else
			if( x*x+y*y < a * a )
				return ( Math::PI*sq(a)/4 + x*y+ x*Math::sqrt( sq(a)-sq(x) )/2 + y*Math::sqrt( sq(a) -sq(y) )/2 + sq(a)*Math::asin(x/a)/2 + sq(a)*Math::asin(y/a)/2 ) / ( sq(a) * Math::PI )
			else
				return ( sq(a) * Math::PI - sq(a)*Math::acos(x/a) + x*Math::sqrt( sq(a)-sq(x) ) -sq(a)*Math::acos(y/a) + y*Math::sqrt( sq(a) -sq(y) ) )/ (sq(a) * Math::PI )
			end
		end
	end
end
def death(dbh04)
	if dbh04<=0.001
		return 0
	else
		return 1
	end
end	
def plotout(target)
	if target.x<=$xmax&&target.x>=$xmin&&target.y<=$ymax&&target.y>=$ymin
		return true
	end
end
def dorg(target)
	if $cal=="grow"
		if target.dbh04>=0.001&&target.dbh01>=0.001&&target.num!=$jogai&&plotout(target)
			return true
		end
	elsif $cal=="da"
		if target.dbh01>=0.001&&plotout(target)
			return true
		end
	end
end
############## read file
trees = Array.new#treesを配列として定義
infile1.each do |line|#1行目で読み込んだinfileの1行目だけ取り除いてTreeに入れ込む処理？
	if line =~/^#/
	else
		trees.push( Tree.new(line) )
	end
end
maps = Array.new#treesを配列として定義
infile2.each do |line|#1行目で読み込んだinfileの1行目だけ取り除いてTreeに入れ込む処理？
	if line =~/^#/
	else
		maps.push( Tree.new(line) )
	end
end
sel_trees=Array.new
############### Calculate
sel_trees=trees.select{|item|plotout(item)}
#p(sel_trees[0])
maps.each do|target|
	crdcal=Array.new(4,0)
	trees.each do | obj |#treesのデータがobjに格納された上で以下の処理を繰り返す

		
			_dist =dist(target, obj)#targetとobjの距離を_distで返す
			for lim_dist in [5.0,10.0,15.0,20.0] do
				if _dist<lim_dist&&_dist >=(lim_dist-5.0)#もしtargetとobjectの距離が0~9なら(lim_distより)
					if target.sprout==obj.sprout&&target.sprout!=0
						if _dist<=0.01
							#target.sc+=obj.dbh01/0.01
							target.sc+=obj.dbh01
							break
						else
							target.sc+=obj.dbh01
							#target.sc+=obj.dbh01/_dist
							break
						end
					else
						if _dist<=0.01
							crdcal[lim_dist/5-1]+=obj.dbh01
							break
						else
							crdcal[lim_dist/5-1]+=obj.dbh01
							break
						end
					end
				end
		end
    end
	    
    for lim_dist in [5.0,10.0,15.0,20.0] do
		area_ratio=(sq(lim_dist)*edge_effect(lim_dist, target.edge_x, target.edge_y)-sq(lim_dist-5.0)*edge_effect(lim_dist-5.0, target.edge_x, target.edge_y))/(sq(lim_dist)-sq(lim_dist-5.0))
		target.set_crd(lim_dist,crdcal[lim_dist/5-1]/area_ratio)
		
	end
	# target.dgrw=(dgrw(target.dbh04,target.dbh01))
	# target.death=(death(target.dbh04))
	target.sc=target.sc/area_ratio
end

Result=["x","y","Crd5","Crd10","Crd15","crd20"]

Result.push("crd")
#pp(sel_trees)
require "csv"
file_out = File.open('../../../kamchatka/crd/poplus_map.csv','w') #出力ファイル名変えたいならここ
file_out.print Result.join(","), "\n"	
maps.each do |target|
	#file_out.print target.num, ","
	file_out.print target.x, ","
	file_out.print target.y, ","
	# file_out.print target.spp,","
	# file_out.print target.dbh01,","
	# file_out.print target.dbh04,","
	# file_out.print target.hgt,","
	# #file_out.print target.sprout,","
	#file_out.print target.sc,","
	# if $cal=="grow" then
	# 	file_out.print target.dgrw,","
	# elsif $cal=="da"
	# 	file_out.print target.death,","
	# end
	crd=0
    for j in [5.0,10.0,15.0,20.0]
		file_out.print target.get_crd(j),","
		crd+=target.get_crd(j)
	end
	file_out.print crd,"\n"
	
end
#p(sel_trees[0])