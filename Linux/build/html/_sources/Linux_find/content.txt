==============
内容查找与过滤
==============

cut
=====

功能说明: 纵向切割出文本指定的部分并写到标准输出，显示文件或STDIN数据的指定列

使用 -d 指定区分列的定界符（默认为TAB）

使用 -f 指定要显示的列

$ cut -d: -f1 /etc/passwd (默认的分隔符是tab)

$ grep root /etc/passwd | cut -d: -f7



使用 -c 按字符切割
$ cut -c2-5 /usr/share/dict/words

-s : 不打印没有包含分界符的行 (默认的分解符为tab，可以使用-d参数修改)

-b<LIST> : 只列出<LIST>指定的字节

-c<LIST> : 只列出<LIST>指定的字符

1、cut -b-10 file #只列出每行的开头到第10个字节的内容

2、cut -b2-10  #列出每行第2到第10的字节的内容

3、cut -b2-10，15-20  #列出每行第2到第10的字节,15到20字节的内容

4、cut -c5- file  #列出每行第5个字符到最后的所有内容

5、cut -c5-10 file #列出每行第2到第10的字符的内容

6、cut -c5-10,15-20 file #列出每行5到10字符，15到20字符的内容

7、cut -f1,3,5 file  #列出每行1、3、5字段的内容

8、cut -f2-4 file  #列出每行2到4字段的内容

9、cut -f1,2-4,6 -d' ' -s file

10、cut命令-d不能和-c一起用

11、cut -b8 file  #列出每一行的第8个字节的内容


grep
=====

1、grep -R '10.1.198.85' /etc #-R表示目录递归

2、grep 'test' d*　　#显示所有以d开头的文件中包含 test的行

3、grep ‘test’ aa bb cc 　　 #显示在aa，bb，cc文件中包含test的行

4、grep magic /usr/src　　#显示/usr/src目录下的文件(不含子目录)包含magic的行

5、grep -r magic /usr/src　　#显示/usr/src目录下的文件(包含子目录)包含magic的行

6、grep -w pattern files ：只匹配整个单词，而不是字符串的一部分(如匹配’magic’，而不是’magical’)，

7、grep ‘[a-z]\{5\}’ aa #显示所有包含每行字符串至少有5个连续小写字符的字符串的行

8、grep -v -E 'grep|monitor' /etc/passwd #过滤掉含有grep或者monitor的行

9、-n 可以打印匹配行的行号 显示的结果后面为行号: xxxx (xxx为匹配行的内容)

10、-s 表示不打印错误信息，但是正常的匹配成功信息还是会打印的，而-q则是什么都不打印

grep 的其他参数

-i 表示不区分大小写

-v 表示匹配的但不显示

11、grep -c china  dict.txt  # 统计包含china的行数
    
ps -ef |grep -A2 -B2 wenjian #显示匹配行和匹配上的上2两行，下两行 

12、grep "*test"  example.txt #这里面的通配符*不能被grep正确处理，grep默认不识别通配符，只好加行-E选项

13、grep test example.txt
 
grep test <example.txt 

cat example.txt  | grep test 

#以上三个都是等效的,grep可以处理管道输入也可以处理标准输入

14、cat test.sh | grep -n 'echo'

	5:    echo "very good!"
;
	7:    echo "good!";

	9:    echo "pass!";

	11:    echo "no pass!";

#grep 过滤后输出的行号是原始内容的行号，没有发生改变
	
15、标准输入优于管道输入
sed -n '1,10p'<test.sh | grep -n 'echo' <testsh.sh

10:echo $total;

18:echo $total;

21:     echo "ok";

#哈哈，这个grep又接受管道输入，又有testsh.sh输入，那是不是2个都接收呢。刚才说了"<"运算符会优先，管道还没有发送数据前，grep绑定了testsh.sh输入，这样sed命令输出就被抛弃了。这里一定要小心使用

16、grep 使用 Basic regular expression (BR E) 书写匹配模式

egrep 使用 Extended regular expression (ER E) 书写匹配模式，等效于 grep -E

fgrep 不使用任何正则表达式书写匹配模式（以固定字符串对待），执行快速搜索，等效于 grep -F

17、grep -v '^#' myfile

18、grep '[a-z]\{5\}' myfile

19、egrep '[a-z]{5}' myfile

20、# 如果west被匹配，则es就被存储到内存中，并标记为1，然后搜索任意个字符（.*），
    
# 这些字符后面紧跟着另外一个es（\1），找到就显示该行。

grep 'w\(es\)t.*\1' myfile

egrep 'w(es)t.*\1' myfile

21、通过管道过滤ls输出的内容，只显示以 ~ 或 - 或 .bak 结尾的行

    ls | egrep '(~|-|\.bak)$'


tr
======

other
=======

1、cat -n text.sql

-n:由 1 开始对所有输出的行进行编号

2、cat -b text.sql

-b : 和 -n 相似，只不过对于空行不编号

3、cat -b -s text.sql

-s : 当遇到有连续两行以上的空行时，使用一个空行代替

4、cat file1 file2 > files 

将两个文件内容合并



Linux tail

tail 命令从指定点开始将 File 参数指定的文件写到标准输出。如果没有指定文件，则会使用标准输入
默认在标准输出上显示每个FILE的最后10行. 如果多于一个FILE,会一个接一个地显示, 并在每个文件显示的首部给出文件名. 如果没有FILE,或者FILE是-,那么就从标准输入上读取.

tail /etc/passwd 查看passwd文件后十行的内容

tail -2 /etc/passwd  查看passwd文件后两行内容

tail -f /etc/passwd  实时查看passwd文件后十行内容

tail - 表示从标准终输入读取


tail -n 20 /etc/passwd 显示最后20行的内容

tail -c 10 /etc/passwd 显示passwd最后10个字节


more +10 file1

从第10行开始向下显示内容
