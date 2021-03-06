=============
ssh 安全配置
=============


**1、sshd_confg 安全配置**

1)禁止root 登录

2)禁止空口令登录

3)禁止kndown host 登录

4)禁止端口转发

5)使用1024位公钥(默认是768)

6)只允许指定用户|用户组登录

7)禁止sshd_config中配置banner，或者伪造一个迷惑性的banner

8)配置pam.d中sshd，注释掉 对motd.so的引用

9)配置pam.d中的sshd注释掉对pam_nologin.so的引用,或者删除/etc/nologin

10)配置pam.d中的sshd，启用pam_access.so,进行复杂的访问控制



**2、ssh登录限制配置思路**

1)使用tcpwrapper

你可在 hosts.allow 中设：

sshd: 192.168.0.1

sshd: ALL: deny

只允许192.168.0.1 主机登录

2)iptables

iptables -I INPUT -p tcp --dport 22 -j DROP

iptables -I INPUT -p tcp --dport 22 -s 192.168.0.0/32 -j ACCEPT

(注：用 -I 命令，且顺序不能颠倒...)



3)使用pam模块

	修改 /etc/pam.d/sshd

	auth required pam_listfile.so item=user sense=allow file=/etc/sshusers onerr=fail

        将你要的用户写进/etc/sshusers ，如：

	echo "zhangsan" >> /etc/sshusers

	设定登录黑名单

	vi /etc/pam.d/sshd

	增加

	auth required /lib/security/pam_listfile.so item=user sense=deny file=/etc/sshd_user_deny_list onerr=succeed

	所有/etc/sshd_user_deny_list里面的用户被拒绝ssh登录

4)使用sshd_config配置文件

允许或者禁止某个用户(组)通过ssh登录

在/etc/ssh/sshd_conf添加

AllowUsers 用户名

或者

AllowGroups 组名

或者

DenyUsers 用户名


**3、ssh 暴力破解防护**

1)限制IP

iptables、tcpwraper都可以做

2)限制用户(组)

   sshd可做
    
   pam（黑名单、白名单）
   
3)只允许公钥登录


4)指定尝试密码次数

vi /etc/sshd_config

修必MaxAuthTries 3


**4、ssh 中间人攻击原理与防护**

1)原理

dh算法是这样的，A和B先共享p,q。然后A生成随机数a,计算E1=(p^a)modq发给B，B生成随机数b,计算E2=(p^b)modq发给A；A计算K=E2^a=(p^ab)modq,B计算K=E1^b=(p^ba)modq，就共享了K这个密钥吧，

C假设是中间人，他知道E1和E2,p,q

他也生成一个随机数c，计算Ec=(p^c)modq给A和B

这个时候E1，E2被截获没有发给对方，都在中间被C拦截住了

A收到Ec以为是E2,B收到Ec以为是E1

A计算Kac=Ec^a=p^ca,B计算Kbc=Ec^b=p^cb

C就可以中间人了

E1、E2、p、q这些信息全部用服务器公钥加密传输

2)防护

注意server端公钥指纹的变化



**5、公钥自动登录设置**

ssh-keygen 和ssh-copy-id实现ssh自动登录

本实验的前提是：两者都是linux系统，且一端是ssh-server(192.168.11.164)，一端是ssh-client(192.168.11.103)

在ssh-client执行如下操作

1)ssh-keygen -t rsa   ===>这条命令用来生成rsa密钥对（一个公钥，一个私钥，.pub结尾的是公钥，这里-t的参数就是指定使用的算法，主要有三种 rsa dsa 用于ssh2 ，rsa1用于ssh1，这里以ssh2为例实验）

在ssh-client当前用户的家目录下面的.ssh目录下面会出现两个文件id_rsa id_rsa.pub

2)ssh-copy-id -i id_rsa.pub root@192.168.11.164

出现如下：

root@192.168.11.164's password: 

Now try logging into the machine, with "ssh 'root@192.168.11.164'", and check in:

  .ssh/authorized_keys

to make sure we haven't added extra keys that you weren't expecting.

这样当你在当前的ssh-client用户环境中去以root身份登录192.168.11.164这台机器的时候，会不用输入密码而自动登录的

当你登录到192.168.11.164这台机器后，你会发现在root会用的~/.ssh目录下面有一个名为authorized_keys的文件，这个文件存储有ssh-client发送的公钥信息

当然你也可以选择以不同用户身份自动登录进入ssh-server，只要将对应的公钥信息拷贝至相应的用户的.ssh/authorized_keys文件中即可

3、ssh-copy-id应注意的小地方

Default public key: ssh-copy-id uses ~/.ssh/identity.pub as the default public key file (i.e when no value is passed to option -i). Instead, I wish it uses id_dsa.pub, or id_rsa.pub, or identity.pub as default keys. i.e If any one of them exist, it should copy that to the remote-host. If two or three of them exist, it should copy identity.pub as default. 
The agent has no identities: When the ssh-agent is running and the ssh-add -L returns “The agent has no identities” (i.e no keys are added to the ssh-agent), the ssh-copy-id will still copy the message “The agent has no identities” to the remote-host’s authorized_keys entry. 
Duplicate entry in authorized_keys: I wish ssh-copy-id validates duplicate entry on the remote-host’s authorized_keys. If you execute ssh-copy-id multiple times on the local-host, it will keep appending the same key on the remote-host’s authorized_keys file without checking for duplicates. Even with duplicate entries everything works as expected. But, I would like to have my authorized_keys file clutter free.




