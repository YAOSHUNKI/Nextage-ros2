Environments to be installed
-----------------------
- Ubuntu 20.04
- Python 3.10
- CUDA 12.2
- Pytorch
- MuJoCo 210
- gym 
- mujoco-py
- ROS1


Preliminary  (If you are new to Docker)
-----------------------
1. Install Docker: https://www.digitalocean.com/community/tutorials/how-to-install-and-use-docker-on-ubuntu-20-04
2. Install nvidia-tool-kit: https://qiita.com/Hiroaki-K4/items/c1be8adba18b9f0b4cef


Main procedure
-----------------------
- In terminal, 
3. sh build.sh
4. export DISPLAY=:0.0
6. xhost local:root
7. sh run.sh
8. Let's start your docker life!! Run sample codes
  - python sample_code/pytorch_sample.py


If you get errors, check below
-----------------------
- Got permission denied while trying to connect to the Docker daemon socket at unix:///var/run/docker.sock: 
1. sudo usermod -aG docker ${USER}
2. su - ${USER}
