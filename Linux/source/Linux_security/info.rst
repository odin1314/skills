=====================
Linux 敏感信息获取
=====================


**1、操作系统版本**

	cat /etc/issue

	cat /etc/issue.net

	cat /etc/lsb-release

	cat /etc/redhat-release

	cat /proc/version
   
**2、内核版本**

	uname -a

	cat /proc/version

	ls /boot |grep vmlinuz

	dmesg |grep linux

	uname -mrs
	
**3、系统架构**

	uname -m

	arch

**4、查看系统初始化文件**

	cat /etc/profile

	cat /etc/bashrc

	cat ~/.bashrc

	cat ~/.bash_profile

	cat ~/.bash_logout

	cat ~/.bash_history

	cat ~/.mysql_history

	cat ~/.nano_history

	cat ~/.php_history
	
	
**5、运行进程信息**

	ps aux 

	ps -ef
	

**6、查看具有root权限的进程**

	ps aux |grep root

	ps -ef |grep root

**7、查看安装了哪些程序**

	dpkg -l

	rpm -qa

	ls -alh /usr/bin

	ls -alh /sbin

	ls -al /var/cache/yum

	ls -al /var/cache/apt/archives
	
**8、 重要配置文件**

	cat /etc/syslog.conf

	cat /etc/my.cnf

	cat /etc/mysql/my.cnf

	cat /etc/apache2/apache2.conf

	cat /etc/lighttpd.conf

	cat /etc/ssh/sshd_config

	cat /etc/passwd

	cat /etc/shadow

	cat /etc/group

	cat /etc/network/interfaces

	cat /etc/sysconfig/network

	cat /etc/sysconfig/network-scripts/ifcfg-ethx

	cat /etc/resolv.conf
	
**9、查看系统工作计划**

	crontab -l

	ls -alh /var/spool/cron

	ls -al /etc |grep cron

	ls -al /etc/cron*

	cat /etc/cron*

	cat /etc/at.allow

	cat /etc/at.deny

	cat /etc/cron.allow

	cat /etc/cron.deny

	cat /etc/crontab

**10、查看系统外连限制**

       cat /etc/host.deny

	cat /etc/host.allow

	iptables -L

	netstat -antlp

	netstat -aunlp

	chkconfig --list

	route -n

	arp -e
	
**12、查看包含密码的文件**

	grep -i user

	grep -i pass
	
**13、/etc 下敏感文件**

	ls -aRl /etc/ |awk '{if($1~/..w......./){print $9}}' &>/dev/null  #用户可写

	ls -aRl /etc/ |awk '{if($1~/.....w..../){print $9}}' &>/dev/null  #用户组可写

	ls -aRl /etc/ |awk '{if($1~/........w./){print $9}}' &>/dev/null  #other可写
	
**14、系统磁盘布局**

	cat /etc/fstab

	cat /etc/mstab

	df -h
	 
**15、查看系统日志**

	more /var/log/apache2/xxx.log

	more /var/log/auth.log

	more /var/log/messages

	more /var/log/lastlog

	more /var/lg/secure

	more /var/log/syslog
	 
**16、查找特殊标志位的文件或目录**

	find / -type f -perm -4100 
  
	find / -type f -perm -u=s 

	find / -type f or type d -perm 2000

	find / -type f or type d -perm -g=s

	find / -type d -perm 1000 
	
	find / -perm -222 -type d 

	find / -perm -o+w -tye d 

	find / -perm -o+x -type d 
	

