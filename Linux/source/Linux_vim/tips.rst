=========
技巧篇
=========

vim 常用技巧，值得去看


常用技巧
==========

1、如何去掉vim打开的文件中的^M

	:%s/\r/
         
         其他可以参考的方法

         tr -d \"\\r\" < src >dest 
　 
         tr -d \"\\015\" dest 

	cat filename1 | tr -d "^V^M" > newfile；
	
	sed -e "s/^V^M//" filename > 

	:%s/^M$//g 
        
         strings A>B 
	
	(windows \r\n  0d0a;linux \n 0a)

2、vim 跨文件复制

	1)用vim打开一个文件，例如：original.trace

	2)在普通模式下，输入：":sp"（不含引号）横向切分一个窗口，或者":vsp"纵向切分一个窗口，敲入命令后，你将看到两个窗口打开的是同一个文件

	3)在普通模式下，输入：":e new.trace"，在其中一个窗口里打开另一个文件

	4)切换到含有源文件（original.trace）的窗口，在普通模式下，把光标移到你需要复制内容的起始行，然后输入你想复制的行的数量（从光标所在行往下计算），在行数后面接着输入yy，这样就将内容复制到临时寄存器里 了（在 普通模式下ctrl+w，再按一下w，可以在两个窗口之间切换）

	5)切换到目标文件（new.trace）窗口，把光标移到你接收复制内容的起始行，按一下p，就完成复制了。 


3、3、修改文件的编码

	1)查看当前vim打开文件内容的编码

	:set fileencoding

	2)设置新编码

	:set fileencoding=utf-8

4、连续删除1，到n行

	:1,10d

5、vim连续注释多行

	:1,10s/^/#/g


6、取消连续多行的注释

	:1,10s/#/^/g

7、多行整体向右移动若干个tab

	:1,10>>

8、多行整体向←移动若干个tab

	:1,10<<

9、vim 插入的命令

	a	在光标之后插入

	i	在光标之前插入

	o	在下行插入

	O	在上行插入

10、定位到第一行

	gg

	:1

11、定位到最后一行

	G

	:$

12、删除文件所有内容
	:%d 

13、无插件Vim编程技巧

	http://coolshell.cn/articles/11312.html


14、vim 替换

vi/vim 中可以使用 ：s 命令来替换字符串。该命令有很多种不同细节使用方法，可以实现复杂的功能

:s/vivian/sky/ 替换当前行第一个 vivian 为 sky 
　 
:s/vivian/sky/g 替换当前行所有 vivian 为 sky 

:n,$s/vivian/sky/ 替换第 n 行开始到最后一行中每一行的第一个 vivian 为 sky 
　 
:n,$s/vivian/sky/g 替换第 n 行开始到最后一行中每一行所有 vivian 为 sky 

:s#vivian/#sky/# 替换当前行第一个 vivian/ 为 sky/ 

:%s+/oradata/apras/+/user01/apras1+ （使用+ 来 替换 / ）： /oradata/apras/替换成/user01/apras1/ 

:s/vivian/sky/ 替换当前行第一个 vivian 为 sky 

:s/vivian/sky/g 替换当前行所有 vivian 为 sky 

:%s/vivian/sky/ 替换每一行的第一个 vivian 为 sky 

:%s/vivian/sky/g  替换每一行中所有 vivian 为 sky 

s/vivian/sky/gc  替换当前行所有 vivian 为 sky ,在替换之前进行替换确认，c是confirm的缩写


