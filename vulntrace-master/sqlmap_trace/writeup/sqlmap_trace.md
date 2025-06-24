更新时间：2025年06月16日11:04:53



# 文件结构
![](images/1750083444055-abf43b03-dd38-4739-8c70-bf94b2a2ac76.png)

# 环境准备
分析机：kali linux  192.168.13.145 

靶机：docker环境 192.168.13.1

攻击工具：sqlmap（[https://sqlmap.org/](https://sqlmap.org/)）

分析工具：网站访问日志access.log、kali的wireshark



# 启动方法
```python
docker-compose up -d --build
```



![](images/1750755227253-a52b5946-989b-4eff-80d2-5b4e24ad6351.png)





然后访问http://目标ip:8080端口



![](images/1750082483495-84e56174-6622-447c-8942-718b9dc722c2.png)

此时在access_logs目录下存在access.log文件，并有访问日志：



![](images/1750082724381-21f506c1-0a85-4027-8179-0580423c13eb.png)

# sqlmap特征识别
在这里输入单引号，发现存在报错：



![](images/1750082528201-6c0b9377-75dd-4bf2-8c3a-6ba6b421aa9c.png)



此时使用wireshark抓包，并且使用sqlmap跑一下包看下：



![](images/1750082829876-263bb5a8-a06e-4cdb-b1b8-9b067a6ea168.png)



![](images/1750082840528-c9aebae0-6129-47b1-a8f0-cec1b010026e.png)



此时存在sql注入漏洞，并且发现存在几种注入方法。

# 特征分析
## access.log日志
在sqlmap注入之后，在access.log日志文件里面可以找到sqlmap的关键特征信息：





![](images/1750082937801-c498c5a6-a77b-401b-bedf-e3c5ee84b85d.png)





此时可以看到当前存在的sqlmap的版本号和特征信息。

## 流量分析
分析wireshark抓包流量，过滤http请求：





![](images/1750083013572-7af5aeee-eab9-44be-b344-912dad2b3e69.png)



追踪一下tcp流看下：

此时在User-Agent里面可以看到sqlmap的特征信息：

![](images/1750083041213-b11d6705-2cb2-4ce0-b302-5b1cc2d023d8.png)



# 实验结束
分析完成之后，使用：

```python
docker-compose down
```





![](images/1750755263394-721bd2e2-e371-4f64-a898-b97ba81739eb.png)



















