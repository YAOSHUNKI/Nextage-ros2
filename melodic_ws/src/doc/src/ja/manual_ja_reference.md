# ロボットハードウェアの概要

## ロボット諸元<!--robot-specifications-->

詳しくはカワダロボティクスのサイト内にある NEXTAGE 製品仕様や取扱説明書を参照してください。

- Kawada Robotics NEXTAGE Fillie - 製品仕様
  - メーカサイト
    - [https://nextage.kawadarobot.co.jp/fillie/open](https://nextage.kawadarobot.co.jp/fillie/open)
  - 自由度: 15軸
    - 腕6軸 x 2 : 肩 Yaw-Pitch，肘 Pitch，手首 Roll-Pitch-Yaw
    - 首2軸 : 首 Yaw-Pitch
    - 腰1軸 : 腰 Yaw
  - 最大可搬質量
    - 片腕 : 2.0 kg
    - 両腕 : 4.0 kg
  - カメラ
    - 頭部: ステレオカメラ
    - ハンドカメラ（オプション）

## 座標系<!--coordinate-system-->

NEXTAGE OPEN の座標系は下の図のようになっています。

ベース座標は腰基部中心に設定されています。

- ベース座標
  - X軸: 正 - 前方 / 負 - 後方
  - Y軸: 正 - 左側 / 負 - 右側
  - Z軸: 正 - 上方 / 負 - 下方

![Nextage Open - Coordinate Sys / Base WAIST](../images/nxfo_images/nxo_base-coordinate-sys.png)

各フレームの座標系は次のようになっています。

- 各座標軸と色表記
  - X軸: Red
  - Y軸: Green
  - Z軸: Blue

![Nextage Open - Coordinate Sys / All Frames](../images/nxfo_images/nxo_frame-coodinate-sys.png)


# コンピュータとソフトウェアの概要<!--computer-and-software-overview-->


カワダロボティクスの NEXTAGE OPEN ロボットシステムには次の2つのコンピュータがあります。

### 制御用コンピュータ<!--computer-for-control-->

- コントローラ（QNXコンピュータ）
  - ロボットを制御するコンピュータ
  - QNX: 実時間オペレーティングシステム
  - ソフトウェアのインストール・改変は不可
  - 保守・アップデートは可能

### 開発用コンピュータ<!--computer-for-dev-->

- 開発用コンピュータ要求仕様
  - 2.3GHz以上かつ2コア以上のプロセッサ  
  (Intel Core i5-5300Uで動作確認済み)
  - 8GB 以上のメモリ
  - 20GB 以上のディスク空き容量
  - Ubuntu 18.04
    - Ubuntu 18.04の標準サポートは2023年5月で終了します。必要に応じてセキュリティ対策などを実施してください。 
  - ROS Melodic
  - USB × 2 以上
    - ロボット搭載カメラ用 × 1（USB 3.0 Type A）
    - その他用途 × 1 以上（規格は問わない）
  - Ethernet / WLAN 合計で 2 ポート以上
    - QNXコンピュータにイーサネット経由で接続(ロボット所有者のみ)

## ソフトウェアの概要<!--overview-of-the-software-->

下に NEXTAGE OPEN の QNX と Ubuntu のソフトウェアコンポーネント構成図を示します。
ユーザーは ROS と RTM(hrpsys) のどちらを利用してもロボットを制御するソフトウェアをプログラムすることができます。

![Software Components Diagram](https://docs.google.com/drawings/d/1ZfQg4EHrGAC7fvHEWLVQxxjBbdmWLu9tMwqmFhb1eQo/pub?w=960&amp;h=720)


## API の概要<!--summary-of-api-->

NEXTAGE OPEN で使用する API をシステムの観点で大別すると RTM と ROS の2種があり、
ROS API でも ROS インタフェース と MoveIt! インタフェースに分けることができます。

- RTM API on hrpsys
- ROS API
  - ROS インタフェース
  - MoveIt! インタフェース

それぞれの API が Python や C++ などのプログラミング言語で利用することができます。

下図にそれら API の構成図を示します。

![API Diagram](../images/nxo_images/nxo_api_diagram.png)

# 保守・管理<!--Maintenance and management-->

## Ubuntuソフトウェアのアップデート<!--Updating Ubuntu Software-->

Ubuntu 上の全てのソフトウェアをアップデートする場合は次のコマンドを実行してください。

```
$ sudo apt-get update && sudo apt-get dist-upgrade
```

NEXTAGE OPEN のソフトウェアのみをアップデートする場合は次のコマンドを実行してください。

```
$ sudo apt-get update && sudo apt-get install ros-melodic-rtmros-hironx
```

<!-- TODO github URL確定-->
カワダロボティクスが提供するrosパッケージ(rtmros_nextage_fillie_open.tar.bz2)をサポートサイトよりダウンロードし、
catkinのワークススペースに展開してcatkin_makeしてください。

```
$ tar jxvf rtmros_nextage_fillie_open.tar.bz2 -C ~/catkin_ws/src
$ cd ~/catkin_ws; catkin_make
```

<!-- ## QNX での作業 -->

<!-- ### QNX GUIツール - NextageOpenSupervisor -->

<!-- QNX に関する日常的な作業のうち次のものは -->
<!-- カワダロボティクスから提供されている GUI ツール NextageOpenSupervisor を用いて操作することができます。 -->

<!-- - コントロールボックス（QNXコンピュータ）のシャットダウン処理 -->
<!-- - アップデート -->

<!-- このツールは UIコンピュータ（Ubuntuコンピュータ/ビジョンPC）に -->
<!-- nxouser アカウントでログオンするとデスクトップ上にアイコンがあります。 -->

<!-- ### QNXのコマンド操作 -->

<!-- 本作業は QNX にログオンできることを前提としたものです。 -->
<!-- 次のコマンドで QNX にSSH接続とログオンを行います。 -->

<!-- ``` -->
<!-- YOURHOST$ ssh -l %QNX_YOUR_USER% %IPADDR_YOUR_QNX% -->
<!-- ``` -->

<!-- ##### QNX シャットダウンコマンド -->

<!-- ``` -->
<!-- QNX$ su -c '/opt/grx/bin/shutdown.sh' -->
<!-- ``` -->

<!-- ##### QNX リブートコマンド -->

<!-- ``` -->
<!-- QNX$ su -c '/bin/shutdown' -->
<!-- ``` -->

<!-- ### ログファイルの定期メンテナンス -->

<!-- ### QNXのログファイル -->

<!-- QNX のログファイルは `/opt/jsk/var/log` にあります。 -->

<!-- - Nameserver.log -->
<!-- - Modelloader.log -->
<!-- - rtcd.log -->

<!-- これらのログファイルは自動的に生成されますが，自動的には削除されません。 -->

<!-- ### ログファイルの圧縮・削除 -->

<!-- ディスクスペースにおいてログファイルはすぐに何ギガバイトにもなってしまします。 -->
<!-- これらのログファイルは自動的に削除される仕組みにはなっておりませんので， -->
<!-- 時おり `/opt/jsk/var/log` 下のログファイルを削除することをお勧めします。 -->

<!-- ログファイルの削除はスクリプトの実行もしくはリモートログインによる手動操作で行うことができます。 -->

<!-- ##### スクリプト操作によるログファイルの圧縮 -->

<!-- ``` -->
<!-- # Remove all raw .log files to free disk space. Same .zip file will be kept in the log folder. -->

<!-- $ rosrun hironx_ros_bridge qnx_fetch_log.sh nextage qnx_nxo_user archive -->
<!-- ``` -->

<!-- ##### 手動でのログファイルの削除 -->

<!-- QNX コンピュータログオンできる場合においては SSH 接続をして， -->
<!-- ディレクトリ `/opt/jsk/var/log` 下にあるログファイルを削除することができます。 -->

<!-- ##### ディスク空き容量の確認 -->

<!-- QNX コンピュータログオンできる場合においては SSH 接続をして， -->
<!-- ディスクの空き容量を確認することができます。 -->

<!-- ``` -->
<!-- QNX$ df -h -->
<!-- ``` -->

<!-- ディスク空き容量の例 -->
<!-- ``` -->
<!-- /dev/hd0t179 7.8G 7.1G 725M 92% / -->
<!-- /dev/hd0t178 229G 22G 207G 10% /opt/ -->
<!-- /dev/hd0 466G 466G 0 100% -->
<!-- ``` -->


<!-- ### QNXでのインストールやソフトウェア利用 -->

<!-- HIRO / NEXTAGE OPEN ソフトウェアはすべて公開されていますが， -->
<!-- それは HIRO / NEXTAGE OPEN でダウンロードしてただ実行するだけで済むということを意味していません。 -->
<!-- それらのソフトウェアは QNX オペレーティングシステム上で動いているコントローラボックスで -->
<!-- ビルド・コンパイルする必要があります。 -->
<!-- QNX 上ででコンパイルするには，地域のベンダーから購入できる開発者ライセンスが必要です。 -->

<!-- QNX に必要なソフトウェアをインストールする方法も開示されていません。 -->
<!-- QNX は開発者ライセンス以外にも，その運用者は運用認定が必要もしくは十分に運用に精通している必要がある商用ソフトウェアです。 -->
<!-- また，QNX では頑強なパッケージングインフラストラクチャ（ROSのようなもの）がないため， -->
<!-- インストール作業は非常に長い手作業となる可能性があり，エラーが発生しやすくなります。 -->

<!-- しかし，次のような場合には QNX 内での作業が必要となります。 -->

<!-- - 以前のクローズドソースの GRX コントローラに戻す必要があるとき -->
<!-- - デバッグ時に Ubuntu ソフトウェアの API で見られるログだけでは原因が不明な場合に QNX 上のログファイルを見るとき -->

<!-- このような場合には製造元またはソフトウェアサービスプロバイダからログオンアカウント情報を入手することができます。 -->


<!-- EOF -->
