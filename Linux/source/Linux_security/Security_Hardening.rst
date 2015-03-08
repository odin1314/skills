========================
Linux 安全加固思路
========================


物理系统的安全性
===================

**1.1 启动安全性**

安全建议：

配置BIOS，禁用从CD/DVD、外部设备、软驱启动。下一步，启用BIOS密码，同时启用GRUB的密码保护，这样可以限制对系统的物理访问。通过设置GRUB密码来保护Linux服务器，防止他人非法进入单用户模式损害系统


**1.2 移动存储安全性**

安全建议：禁止USB驱动
     
**1.3 禁止组合键重启设备**

安全建议：

修改/etc/inittab

#ca::ctrlaltdel:/sbin/shutdown -t3 -r now
      

打补丁补漏洞
===============

安全建议：

查看系统、web、数据库是否有已知漏洞，及时修补

            
主机对外通信安全性
========================
    
**3.1 禁止不安全的通信协议**


安全建议：如果不是特别需要，则禁止以下不安全运维协议：telnet、ftp 建议使用ssh协议

  
**3.2 开启主机防火墙**

安全建议：

如有必要，则开启iptables，设置白名单
   
**3.3 隐藏通信协议的banner**

安全建议：隐藏、或者伪造协议原先的banner
       
**3.4 ssh 协议安全加固**

安全建议：

1)隐藏|伪造banner

2)使用PROTOCOL 2版

3)不允许root登录(可以通过普通用户登录然后 su -)

4)不允许空口令登录

5)sshd_config中配置：

HostbasedAuthentication no、IgnoreRhosts yes、RhostsRSAAuthentication no

6)禁止端口转发

7)对于安全性特别重要的设备，启用公钥认证而非口令认证

8)对于重要的设备，ssh的密钥长度可以设置长一些

9)如果需要限制用户登录
          
**3.5 主机监听端口信息核查**

安全建议：执行:netstat –anlp 

观察是否有异常端口在监听

**3.6 屏蔽ICMP和Broadcast请求**

安全建议：修改/etc/sysctl.conf,增加

net.ipv4.icmp_echo_ignore_all = 1

net.ipv4.icmp_echo_ignore_broadcasts = 1

保存退出，执行sysctl –p
    
系统账户密码安全性
==============================
    
**4.1 删除不必要的账户和用户组**

安全建议：检查/etc/passwd 和/etc/group 删除多余的账户(组)

**4.2 删除空口令账户**

安全建议:

cat /etc/shadow | awk -F: '($2==""){print $1}' 

删除有空口令的账户或者重新设置密码

    
**4.3 检查系统密码策略**

安全建议：
查看系统默认密码安全策略，酌情增加密码强度设置

cat /etc/login.defs|grep PASS查看密码策略设置

#vi /etc/login.defs修改配置文件

PASS_MAX_DAYS 90 #新建用户的密码最长使用天数

PASS_MIN_DAYS 0 #新建用户的密码最短使用天数

PASS_WARN_AGE 7 #新建用户的密码到期提前提醒天数

PASS_MIN_LEN 9 #最小密码长度9



**4.4 检查系统账户中是否有采取额外认证的账户**

安全建议

执行：grep '^+:' /etc/passwd

如果有返回结果，说明相应的账户采用了额外认证

如果采用了额外认证，则需确认这种认证是否安全

**4.5 核查系统是否有采用额外认证方式**

安全建议：

执行：grep '^passwd' /etc/nsswitch.conf  | grep 'nis'   --表示nis认证

grep '^passwd' /etc/nsswitch.conf  | grep 'ldap'  --表示ldap认证

如果采用了额外认证，则需确认这种认证是否安全

**4.6 账户信息文件的安全性**

安全建议：

检查passwd shadow group 等账户文件权限设置是否异常

**4.7 核查系统中UID为0的用户**

安全建议：

执行：cat /etc/passwd|awk -F: '{if($3==0){print $1}}'

观察是否有除了默认的root之外的用户


**4.8 核查系统中GID为0的组成员**

安全建议：

执行：cat /etc/group|awk -F: '{if($3==0){print $4}}'

观察是否GID为0的组有非root成员


**4.9 限制能用su 命令获取root权限的用户列表 **  

安全建议：

编辑/etc/pam.d/su

增加：auth required /lib/security/pam_wheel.so group=wheel

表示只允许wheel组的用户通过su 切换到root权限

然后将允许的用户加入到wheel 组中

usermod -G wheel test100

如果是禁止非root用户使用su，一个一劳永逸的办法就是chmod 700 su


**4.10 限制能使用sudo 命令的用户**

安全建议：

grep -v '^#' /etc/sudoers | grep -v '^[ \t]*$' | grep -v '^[ \t]*Default' | grep = 查找sudoers添加的用户
        
编辑/etc/sudoers
        
删除无关用户

如：删除wenjian ALL=(root) ALL，则表示不允许wenjian这个用户使用sudo命令
    
**4.11 对于登陆次数超过一定次数就锁定账户一段时间**

安全建议：
                
编辑/etc/pam.d/login,增加

auth      required  pam_tally2.so   deny=3  lock_time=300 even_deny_root root_unlock_time=1

各参数解释

even_deny_root	也限制root用户；

deny	设置普通用户和root用户连续错误登陆的最大次数，超过最大次数，则锁定该用户 

lock_time	设定普通用户锁定后，多少时间后解锁，单位是秒；

root_unlock_time	设定root用户锁定后，多少时间后解锁，单位是秒

此处使用的是 pam_tally2 模块，如果不支持 pam_tally2 可以使用 pam_tally 模块。另外，不同的pam版本，设置可能有所不同，具体使用方法，可以参照相关模块的使用规则。

注：本例是以PAM1.0为参考

bash安全加固
=====================

**5.1 查看当前shell环境所有的alias，观察是否异常**
        
安全建议:
        
当前shell环境执行：alias 命令，观察输出结果是否有非法添加的alias
        
**5.2 核查bash初始化脚本，检查内容是否有非法添加设置**
          
安全建议:
             
检查：/etc/profile
                   
/etc/bash.bashrc
                   
/etc/bash_completion
                  
\~/.bashrc
                   
\~/.bash_profile
                   
\~/.bash_login
                   
\~/.bash_logout
                 
              
核查是否有非法添加内容

可参考设置：

ln -s /dev/null ~.bash_history

chattr +a ~/.bash_profile

chattr +a ~/.bash_login

chattr +a ~/.profile

chattr +a ~/.bash_logout

chattr +a ~/.bashrc

readonly HISTFILE
readonly HISTFILESIZE
readonly HISTSIZE
readonly HISTCMD
readonly HISTCONTROL
readonly HISTIGNORE

unset HISTFILE

unset HISTFILESIZE

unset HISTSIZE

unset HISTCMD

unset HISTCONTROL

unset HISTIGNORE

禁掉系统中所有其他shell，一般包括csh,tcsh,ksh。

          
**5.3核查 bash中umask设置的值**
         
安全建议：
             
检查：/etc/profile
                  
/etc/bash.bashrc
                   
/etc/bash_completion
                   
~/.bashrc
                   
~/.bash_login
                   
~/.bash_profile
          
中umask的设置，正确的设置一般为022

**5.4 减少bash中历史命令数目，或者禁止历史命令记录**
          
安全建议：设置环境变量

HISTFILE=/dev/null
                                 
HISTSIZE=0
          
**5.5 查看bash是否有bash破壳漏洞**

安全建议：

1)bash –version 

当你的GNU Bash 版本小于等于4.3，则存在此漏洞


2)执行env x='() { :;}; echo shellshocked' bash -c "test"

如果出现图上的回显内容，则说明存在此漏洞
                    
如果存在此漏洞，请升级bash


**5.6设置环境变量TMOUT值，设置自动注销时间**
            
安全建议：
                    
export TMOUT=120
                    
表示如果用户登录主机2分钟内没有操作，则自动注销用户登录
            
   
核查进程运行的权限
=======================
    
安全建议：

核查系统以后root权限运行的进行并予以确认

ps –U root 

非系统核心进程禁止以root权限运行

敏感文件核查
===================

安全建议

1)核查有SUID权限的文件，并仔细确认是否异常

find / -type f -perm 4100 2>/dev/null

2)核查系统主要配置文件权限、属主、内容是否有异常

这些配置文件主要有：

/etc/passwd 
  
/etc/shadow
  
/etc/group
  
/etc/profile
  
/etc/fstab
  
/etc/xinet.d/*
  
/etc/sudoers
  
/etc/contab
  
/etc/xinetd.conf
  
/etc/inetd.conf

以上文件的用户和组都是root，除了shadow默认的600权限一以外，其他全是644，请注意核查是否异常

3)核查自启动服务的配置文件

主要有

/etc/init.d/rc

/etc/init.d/rcS

/sbin/shutdown

/sbin/sulogin

/etc/init.d/* 

对于以上这些文件的核查请使用亚信安全核查脚本./Security_check.sh

5）与计划任务有关文件核查

主要有

/etc/cron.d/*

/etc/crontab

/etc/cron.daily

/etc/cron.hourly

/etc/cron.monthly

/etc/cron.weekly


以上这些文件只有root具有可写权限

请确保没有非法加入的计划任务


6）系统其他敏感文件异常核查

使用unix-privesc-check-1.4 或者rkhunter工具扫一扫



日志安全性
=====================

安全建议：

系统主要日志有：

/var/log/message – 记录系统日志或当前活动日志，只有root可读写，其他用户无读写权限

/var/log/auth.log – 身份认证日志。只有root可读写，其他用户无读写权限

/var/log/kern.log – 内核日志。只有root可读写，其他用户无读写权限

/var/log/cron.log – Crond 日志 (cron 任务). 只有root可读写，其他用户无读写权限

/var/log/mail.log – 邮件服务器日志。只有root可读写，其他用户无读写权限

/var/log/boot.log – 系统启动日志。只有root可读写，其他用户无读写权限

/var/log/secure – 认证日志。只有root可读写，其他用户无读写权限

/var/log/utmp or /var/log/wtmp :登录日志。只有root可读写，其他用户无读写权限

/var/log/yum.log: Yum 日志。只有root可读写，其他用户无读写权限


定期核查日志内容，观察是否有异常
  

备份
=========

安全建议:

重要文档定期备份
      
维护主机的安全性
======================

安全建议：

平时运维用户的客户机也要保证安全性


1)用主流杀软扫一遍

2)使用的运维软件如putty、winscp、CRT尽量不要保存密码

每次使用输入。如果要保存，也一定要保证保存密码相关文件的安全性


主动防御(portspoof)
======================

简介
-------

portspoof 主动防御的艺术

Portspoof程序旨在通过在原本封闭的端口上模拟仿真合法的服务签名，加强操作系统的安全性。它本来就是一个轻便、快速、便携、安全的附件，可以添加到任何防火墙系统或安全基础设施上。

这款程序的基本目的就是，让端口扫描软件(Nmap/Unicornscan/等)进程运行缓慢，让输出结果非常难以解读，从而使攻击侦察阶段成为一项难度大又麻烦的任务。

我发觉这个小程序背后的概念很有意思：不是用防火墙堵住所有端口，而是欺骗真实端口，因而让针对你的服务器/计算机运行端口扫描的那些家伙无功而返。

Portspoof程序的主要目的是，通过攻击者对你系统进行侦察的过程中减缓攻击者攻击速度，并阻止攻击者保持低调的一系列技巧，加强操作系统的安全性。

默认情况下，攻击者的侦察阶段应该很费时，而且很容易被你的入侵检测系统所发现。

这种方法纯粹基 于主动(进攻性)防御理念。


特点

 * 快速：多线程(默认情况下10个线程处理新的入站连接)。

 * 轻便：所需的系统资源数量极少。

 * 便携：可以在Linux和BSD(直到版本0.3)上运行。

 * 灵活：你可以轻松使用防火墙规则，定义将被欺骗的端口。

 * 对付流行的端口扫描工具很有效。

 * 超过8000多个假签名可以骗倒端口扫描工具!

 * 采用开源技术。


安装与配置
-------------












思考
-----------


