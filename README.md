# home
樹木の成長・繁殖・死亡および森林火災を再現するシミュレータです

# できること
樹木に対し、1年ごとに成長・新規個体加入・死亡を計算させ、設定した年数まで繰り返す。成長量・新規加入率や新規個体加入場所・死亡率を決定するパラメータは樹種ごとに設定される。また、火災時は通常と異なる死亡・および新規加入のパラメータを適用する。火災が発生する年についてはsetting_fileから、火災強度についてはfire_fileから変更できる。
![フローチャート](https://github.com/m-o-kobe/forest/blob/master/zu1.png "サンプル")


# 使い方
kamchatka/simulatorのディレクトリのファイルを使う。
'ruby kamcha.rb setting_file initial_file output_file stat_file fire_file'
のようにコマンドラインに打ち込み、使用します。

### initial_file
森林の初期状態のcsvファイル。
各列にx座標、y座標、樹種ナンバー、樹齢、個体のサイズ(DBH)、個体ナンバー、萌芽ナンバー(萌芽ナンバーは萌芽樹種の)の順で登録する。以下のファイルをテスト用として使用していたので参考にしてほしい。
kamchatka/simulator/data/init.csv

### setting_fie
シミュレートの設定を登録するcsvファイル。
森林のサイズ(最大のx座標・y座標)、シミュレートする年数、火災の起こる頻度および各樹種の成長量・新規加入率や新規個体加入場所・死亡率を決定するパラメータを設定する。

### output_file
シミュレート結果の詳細情報をアウトプットするcsvファイル。各年・各個体の位置情報とサイズが記録される


### stat_file
シミュレート結果のおおまかな情報をアウトプットするcsvファイル。各年の個体数・新規個体加入数・死亡数を記録する。

### fire_file
各1m×1mプロット位置における火災強度のファイル。実データからRのspatstatパッケージ、density関数を用いて計算したものを用いている。setting_fileで指定したプロットサイズに合わせておく。以下のファイルをテスト用として使用していた。
kamchatka/simulator/data/fire.csv

火災をシミュレートし、立木位置図として可視化した例
##### 火災前
![火災前](https://github.com/m-o-kobe/forest/blob/master/zu2.jpg "サンプル")
##### 火災後
![火災後](https://github.com/m-o-kobe/forest/blob/master/zu3.jpg "サンプル")

#License
Copyright 2020 Shigeaki Hasegawa & Momoko Okabe

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <http://www.gnu.org/licenses/>.
