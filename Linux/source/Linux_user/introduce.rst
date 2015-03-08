===========
概述
===========

用户类型
===========

广义上分 Linux系统下的用户账户（简称用户）有两种，普通用户账户和超级用户账户（或管理员账户）。普通用户在系统上的
任务是进行普通工作，管理员在系统上的任务是对普通用户和整个系统进行管理。管理员账户对系统具有绝对的控制
权，能够对系统进行一切操作，如操作不当很容易对系统造成损坏。因此即使系统只有一个用户使用，也应该在管理员
账户之外建立一个普通用户账户，在用户进行普通工作的时候以普通用户账户登录系统。

具体细化分为：

1、超级用户 (UID 为0的)

2、普通用户 (UID在 500 - 60000)

3、伪用户 (UID 1-499)


伪用户特点
=============

1、伪用户与系统和程序服务相关

 * bin、daemon、shutdown、halt等，任何Linux系统都有这些伪用户
 * mail、news、games、apache、ftp、mysql、sshd等，与Linux 系统的进程相关
 
2、伪用户通常不需要或者无法登陆系统

3、伪用户可以没有宿主目录

UID的理解
=============

UID 是用户的ID 值，在系统中每个用户的UID的值是唯一的，更确切的说每个用户都要对应一个唯一的UID ，系统管理员应该确保这一规则。系统用户的UID的值从0开始，是一个正整数，至于最大值可以在/etc/login.defs 可以查到，一般Linux发行版约定为60000； 
在Linux 中，root的UID是0，拥有系统最高权限。

UID 在系统唯一特性，做为系统管理员应该确保这一标准，UID 的唯一性关系到系统的安全，应该值得我们关注！比如我在/etc/passwd 中把beinan的UID 改为0后，你设想会发生什么呢？beinan这个用户会被确认为root用户。beinan这个帐号可以进行所有root的操作；
UID 是确认用户权限的标识，用户登录系统所处的角色是通过UID 来实现的，而非用户名，切记；把几个用户共用一个UID 是危险的，比如我们上面所谈到的，把普通用户的UID 改为0，和root共用一个UID ，这事实上就造成了系统管理权限的混乱。如果我们想用root权限，
可以通过su或sudo来实现；切不可随意让一个用户和root分享同一个UID ；

UID是唯一性，只是要求管理员所做的，其实我们修改/etc/passwd 文件，可以修改任何用户的UID的值为0，一般情况下，每个Linux的发行版都会预留一定的UID和GID给系统虚拟用户占用，虚拟用户一般是系统安装时就有的，是为了完成系统任务所必须的用户，
但虚拟用户是不能登录系统的，比如ftp、nobody、adm、rpm、bin、shutdown等；
在Fedora 系统会把前499 个UID和GID 预留出来，我们添加新用户时的UID 从500开始的，GID也是从500开始，至于其它系统，有的系统可能会把前999UID和GID预留出来；以各个系统中/etc/login.defs 中的 UID_MIN 的最小值为准；
Fedora 系统 login.defs的UID_MIN是500，而UID_MAX 值为60000，也就是说我们通过adduser默认添加的用户的UID的值是500到60000之间；而Slackware 通过adduser不指定UID来添加用户，默认UID 是从1000开始。
 



用户组
============

组是用户的集合。在 Linux中组有两种类型：私有组和标准
组。当创建一个新用户时，若没有指定他所属于的组，Linux就建立一个和该用户同名的私有组。此私有组中只包含这
个用户自己。标准组可以容纳多个用户，若使用标准组，在创建一个新的用户时就应该指定他所属于的组。

从另一方面讲，同一个用户可以同属于多个组，例如某单位有领导组和技术组等，Tom是该单位的技术主管，所以他既
应该属于领导组又应该属于技术组。当一个用户属于多个组时，其登录后所属的组称为主组，其他的组称为附加组


GID的理解
=============

GID和UID类似，是一个正整数或0，GID从0开始，GID为0的组让系统付予给root用户组；系统会预留一些较靠前的GID给系统虚拟用户 （也被称为伪装用户）之用；每个系统预留的GID都有所不同，比如Fedora 预留了500个，我们添加新用户组时，用户组是从500开始的；而Slackware 是把前100个GID预留，新添加的用户组是从100开始；查看系统添加用户组默认的GID范围应该查看 /etc/login.defs 中的 GID_MIN 和GID_MAX 值；
我们可以对照/etc/passwd和/etc/group 两个文件；我们会发现有默认用户组之说；我们在 /etc/passwd 中的每条用户记录会发现用户默认的GID ；在/etc/group中，我们也会发现每个用户组下有多少个用户；在创建目录和文件时，会使用默认的用户组。

我们还是举个例子；

比如我把linuxsir 加为root用户组，在/etc/passwd 和/etc/group 中的记录相关记录为：

linuxsir用户在 /etc/passwd 中的记录；我们在这条记录中看到，linuxsir用户默认的GID为502；而502的GID 在/etc/group中查到是linuxsir用户组；

linuxsir:x:505:502:linuxsir open,linuxsir office,13898667715:/home/linuxsir:/bin/bash

linuxsir 用户在 /etc/group 中的相关记录；在这里，我们看到linuxsir用户组的GID 为502，而linuxsir 用户归属为root、beinan用户组；
root:x:0:root,linuxsir
beinan:x:500:linuxsir
linuxsir:x:502:linuxsir 
我们用linuxsir 来创建一个目录，以观察linuxsir用户创建目录的权限归属；
[linuxsir@localhost ~]$ mkdir testdir
[linuxsir@localhost ~]$ ls -lh
总用量 4.0K
drwxrwxr-x 2 linuxsir linuxsir 4.0K 10月 17 11:42 testdir
通过我们用linuxsir 来创建目录时发现，testdir的权限归属仍然是linuxsir用户和linuxsir用户组的；而没有归属root和beinan用户组，明白了吧；

但值得注意的是，判断用户的访问权限时，默认的GID 并不是最重要的，只要一个目录让同组用户可以访问的权限，那么同组用户就可以拥有该目录的访问权，在这时用户的默认GID 并不是最重要的；
