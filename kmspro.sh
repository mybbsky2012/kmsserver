#!/bin/bash

#====================================================
#	System Request: Debian/Ubuntu/Mint/CentOS/Redhat/Fedora
#	Author: dylanbai8 
#	Update: mybbsky
#	Dscription: KMS服务一键安装脚本 & KMSSERVER ONEKEY INSTALL 
#	Open Source: https://github.com/dylanbai8/kmspro
#	New Open Source: https://github.com/mybbsky2012/kmsserver
#	Official document: https://v0v.bid
#====================================================

# 定义脚本变量
PATH=/bin:/sbin:/usr/bin:/usr/sbin:/usr/local/bin:/usr/local/sbin:~/bin
export PATH
STAT=2

# Debian系列操作系统安装KMS
do_debian(){
apt-get install gcc git make -y
rm -rf /usr/local/kms
mkdir /usr/local/kms
cd /usr/local/kms
git clone https://github.com/Wind4/vlmcsd.git
cd vlmcsd
make
cd bin
mv vlmcsd /usr/local/kms/kms
cd /usr/local/kms/
rm -rf ./vlmcsd/
mv kms vlmcsd
echo "KMS服务安装成功！"
echo "KMS SERVICE INSTALL OK！"
echo "默认端口 1688"
echo "Port is 1688"
}

# Centos系列操作系统安装KMS
do_centos(){
yum install gcc git make -y
rm -rf /usr/local/kms
mkdir /usr/local/kms
cd /usr/local/kms
git clone https://github.com/Wind4/vlmcsd.git
cd vlmcsd
make
cd bin
mv vlmcsd /usr/local/kms/kms
cd /usr/local/kms/
rm -rf ./vlmcsd/
mv kms vlmcsd
echo "KMS服务安装成功！"
echo "KMS SERVICE INSTALL OK！"
echo "默认端口 1688"
echo "Port is 1688"
echo "Centos请自行开放1688端口"
echo "Centos Firewall Allow Port  1688"
}

# 检测KMS运行状态
check_running(){
PID=`ps -ef | grep -v grep | grep -i "vlmcsd" | awk '{print $2}'`
		if [ ! -z $PID ]; then
		STAT=0
	else
		STAT=1
	fi
}

# 重启KMS服务
do_restart(){
	check_running
	if [ $STAT = 0 ]; then
		echo "KMS服务已经运行 正在重新启动 ..."
		kill $PID
	elif [ $STAT = 1 ]; then
		echo "KMS服务未运行 正在启动 ..."
	fi
	/usr/local/kms/vlmcsd
	check_running
	if [ $STAT = 0 ]; then
		local_ip=`curl -4 ip.sb`
		echo "KMS服务 启动成功"
		echo "KMS SERVER START OK"
		echo "[Windows一句命令激活] 命令提示符(管理员)：slmgr /skms ${local_ip} && slmgr /ato"
		echo "WINDOWS ACTIVE CMD ：slmgr /skms ${local_ip} && slmgr /ato "
		echo "谢谢使用本安装脚本！"
		echo "thank's for use script！"
	elif [ $STAT = 1 ]; then
		echo "KMS服务 启动失败"
		echo "KMS SERVER START FAILED"
	fi
}

# 停止KMS服务
do_stop(){
	check_running
	if [ $STAT = 0 ]; then
			echo "正在停止 KMS服务 ..."
			echo "STOP to KMS SERVICE ..."
		kill $PID
		check_running
		if [ $STAT = 0 ]; then
			echo "停止 KMS服务 失败"
			echo "STOP to KMS SERVICE FAILED..."
		elif [ $STAT = 1 ]; then
			echo "停止 KMS服务 成功"
			echo "STOP KMS SERVICE OK..."
			fi
		elif [ $STAT = 1 ]; then
				echo "KMS服务 未运行 取消操作"
				echo "KMS SERVICE Not Running,Cancel the Operation ..."
		fi
}

# 检测KMS服务是否运行
do_status(){
	check_running
	if [ $STAT = 0 ]; then
				echo "KMS服务 正在运行"
				echo "KMS SERVICE Running"
				echo "默认监听端口 1688 请注意防火墙开放此端口"
				echo "Default Port is 1688,Firewall Allow Port  1688"
		elif [ $STAT = 1 ]; then
				echo "KMS服务 未运行"
				echo "KMS SERVICE Not Running"
		fi
}

# 启动KMS服务
do_start(){
	check_running
	if [ $STAT = 0 ]; then
				echo "KMS服务 已运行 取消操作"
				echo "KMS SERVICE Running,Cancel the Operation ..."
				echo "默认端口 1688"
				echo "Default Port is 1688"
		exit 0;
		elif [ $STAT = 1 ]; then
				echo "正在启动 KMS服务 ..."
				echo "Starting KMS SERVICE ..."
	/usr/local/kms/vlmcsd
	fi
		check_running
		if [ $STAT = 0 ]; then
				local_ip=`curl -4 ip.sb`
				echo "KMS服务 启动成功"
				echo "KMS SERVER START OK"
				echo "[Windows一句命令激活] 命令提示符(管理员)：slmgr /skms ${local_ip} && slmgr /ato"
				echo "WINDOWS ACTIVE CMD ：slmgr /skms ${local_ip} && slmgr /ato "
				echo "谢谢使用本安装脚本！"
				echo "thank's for use script！"
		elif [ $STAT = 1 ]; then
				echo "KMS服务 启动失败"
				echo "START to KMS SERVICE FAILED..."
		fi
}

# 添加开机自启动服务
do_auto(){
	echo "/usr/local/kms/vlmcsd" >> /etc/rc.local
	chmod +x /etc/rc.local
	echo "已添加 开机自启动 KMS服务"
	echo "Have been added to the automatic mode..."
	echo "谢谢使用本安装脚本！"
	echo "thank's for use script！"
}

# 卸载KMS服务
do_uninstall(){
	do_stop
	rm -rf /usr/local/kms
	sed -i '/vlmcsd/'d /etc/rc.local
	echo "KMS服务 已卸载"
	echo "KMS SERVICE UNINSTALLED！"
}

# 脚本菜单
case "$1" in
	debian|centos|start|stop|auto|restart|status|uninstall)
	do_$1
	;;
	*)
	echo "缺少参数: debian | centos | start | stop | auto | restart | status | uninstall "
	echo "Not parameter: debian | centos | start | stop | auto | restart | status | uninstall "
	echo "请访问：https://github.com/mybbsky2012/kmsserver"
	echo "Help to url：https://github.com/mybbsky2012/kmsserver"
	;;
esac

# 原脚本来自：https://v0v.bid
#from to ：https://v0v.bid
# 更新脚本来自 https://github.com/mybbsky2012/kmsserver
# update to url https://github.com/mybbsky2012/kmsserver