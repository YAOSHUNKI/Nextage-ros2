## 開発用PCのセットアップ

新規のubuntu PCを導入するときに以下の手順通りでPCを設定してください。

### Debian バイナリパッケージからのインストール<!--installing-from-the-debian-binary-package-->

Debian バイナリパッケージからソフトウェアのインストールを行います。

#### ROS および HIROソフトウェアのインストール<!--installing-the-ros-and-hiro-nextage-open-software-->

ROS Melodic および HIROのパッケージをインストールします。
ROSのWiki ([http://wiki.ros.org/melodic/Installation/Ubuntu#Ubuntu_install_of_ROS_Melodic](http://wiki.ros.org/melodic/Installation/Ubuntu#Ubuntu_install_of_ROS_Melodic)) を確認し、ROSをインストールしてください。次にターミナルで次のコマンドを実行し、HIROのパッケージをインストールしてください。

```
$ sudo apt install -y ros-melodic-rtmros-hironx
```

インストールの最後に setup.bash を読み込み、ROS の環境を設定します。

```
$ source /opt/ros/melodic/setup.bash
```

これは新しくターミナルを立ち上げて ROS を使用する前に毎回必要になります。
下記のように .bashrc ファイルに設定を加えて
ターミナル起動時に setup.bash を自動で実行し ROS 環境になるようにしておくと便利です。

```
$ echo "source /opt/ros/melodic/setup.bash" >> ~/.bashrc
```

- 注意: **上記コマンドの `>>` を `>` にしてしまうと元々あった .bashrc 内の設定が消えてしまうのでご注意ください。**


#### NEXTAGE OPEN ソフトウェアのみのインストール<!--installing-nextage-open-software-only-->

ROS Melodic が既にインストールされていて NEXTAGE OPEN のソフトウェアのみをインストールする必要がある場合は次の1行だけ実行してください。

```
$ sudo apt-get update && sudo apt-get install ros-melodic-rtmros-hironx
```

### ネットワーク設定<!--network-settings-->
コントローラのIPアドレスは192.168.128.10です。開発用PCのIPアドレスを適切な値に変更してください。

#### ホスト名の設定（オプション）<!--host-name-setting-optional-->

デフォルトの NEXTAGE OPEN のソフトウェアでは QNX コンピュータのホスト名を通信の際に使います。
ホスト名の設定をオペレーティングシステム上で行っておくと便利です。

- 次の行を `/etc/hosts` に追加

```
# For accessing QNX for NEXTAGE Open
192.168.128.10 nextage
```

- IP アドレスはユーザの環境により上記のものとは異なる場合があります。
- `ping` コマンドによりホスト"nextage"から応答があることを確認してください。
- シミュレータを利用するために上記の設定を変更する必要はありません。
- `192.168.128.x` セグメントを使用するネットワークアプリケーションを使用している場合を除き、この設定はネットワークの使用には有害ではありません。

- 既知の OpenRTM の問題  [https://github.com/start-jsk/rtmros_hironx/issues/33](https://github.com/start-jsk/rtmros_hironx/issues/33) を回避するためネットワーク接続に `eth0` が使用されていることを確認してください。


### ワークスペースのセットアップ<!--workspace-setup-->

<!--NEXTAGE OPEN のプログラムコードを作成・ビルドする必要がない場合は
本項目のインストール手順は不要です。-->

下記のセットアップ手順ではワークスペース名を `catkin_ws` (catkin workspace) としていますが、
他の名前・フォルダ名でも問題ありません。
ここで、rtmros_nextage_fillie_open.tar.bz2はカワダロボティクスが提供するrosパッケージです。
rtmros_nextage_fillie_open.tar.bz2はサポートサイトよりダウンロードし、ホームディレクトリ( `~/` )に置いて以下手順を実行してください。

```
$ mkdir -p ~/catkin_ws/src
$ cd ~/catkin_ws/src
$ catkin_init_workspace
$ tar jxvf ~/rtmros_nextage_fillie_open.tar.bz2 -C ~/catkin_ws/src
$ cd ~/catkin_ws
$ catkin_make
$ source ~/catkin_ws/devel/setup.bash
```

ターミナルを開くたびに `source ~/catkin_ws/devel/setup.bash`
を実行したくない場合は .bashrc に設定します。

```
$ echo "source ~/catkin_ws/devel/setup.bash" >> ~/.bashrc
```

- 注意: **上記コマンドの `>>` を `>` にしてしまうと元々あった .bashrc 内の設定が消えてしまうのでご注意ください。**

### DiagnosisUIのセットアップ<!--DiagnosisUI-setup-->
DiagnosisUIをサポートサイトからダウンロードし、ホームディレクトリ( ~/ )に置いて以下手順を実行してください。

```
$ chmod 744 DiagnosisUI
$ sudo apt-get install -y libqt4-dev
```

またDiagnosisUIのデスクトップショートカットを利用したい場合は、サポートサイトからダウンロードしデスクトップ上に置いて以下の手順を実行してください。

```
$ chmod 744 Link¥ to¥ DiagnosisUI.desktop
```

### カメラのセットアップ<!--Camera-setup-->
IDS社製 uEye カメラを使用するため、IDS Software Suiteをインストールしてください。インストール方法はIDS社のWebサイトをご確認ください。  
  
動作確認済みバージョン : 4.95.2  
  
rtmros_nextage_fillie_openではueye_camを利用しています。[https://wiki.ros.org/ueye_cam](https://wiki.ros.org/ueye_cam) に記載の手順でビルドを行ってください。
ueye_cam の動作確認は、以下のバージョンで実施しています。

動作確認済みバージョン : 1.0.17

バージョンの切り替えは以下のコマンドで実施できます。

```
$ cd ueye_cam
$ git checkout 1.0.17
```
<!-- EOF -->
