### Container

-----

本人最近在学习大数据框架，以便提高自己对数据领域的认知。学习路径大概为： Hadoop(hdfs,yarn,mapreduce) -> Hive -> Spark -> Kafka -> Flink。 

本着快速搭建起开发和测试环境的前提，我决定使用Docker去搭建需要的环境。

但是在使用别人创建好的Docker镜像的时候总是遇到这样那样不顺手的情况，所以决定自己重新build一些Docker镜像。

本仓库用于保存所有Docker镜像的Dockerfile文件及其周边脚本。

由于与本仓库相关的Docker镜像只用作开发和测试使用，其必然存在一些问题。请酌情参考使用。 


### 1.目录介绍

### 1.1.Ubuntu

由于使用习惯的问题，我创建的镜像都给予ubuntu:18.04构建。

我对ubuntu:18.04系统做的修改是把软件更新源变成了阿里云的，并且安装了部分软件包。

详见Ubuntu目录相关文件

### 1.2.JDK

在之前做好的Ubuntu 18.04镜像的基础上创建JDK 8镜像。并且配置好对应的JAVA_HOME等环境变量。

此镜像中的环境变量会被子镜像继承，所以不用在子镜像中重复配置。


### 1.3.hadoop

网上能搜到的hdfs集群的搭建过程不是配置负载，就是对datanode节点扩容操作不够方便。

依据对Docker的理解和对HDFS搭建过程的理解，自己重新整理了Hadoop镜像。

使用该镜像有几点需要注意：

1. 启动脚本startup.sh中单独创建了一个docker network，方便容器间互相访问。
1. namenode启动的时候需要用到-v选项，这样namenode就会把/opt/hadoop-2.7.7目录共享给其他的容器，包括datanode容器。其他容器需要挂在namenode共享出来的/opt/hadoop-2.7.7目录的时候就可以使用--volumes-from namenode01选项即可。
1. namenode和datanode启动的时候主机名尽可能使用统一的命名规范，这里namenode容器名称为namenode01；datanode容器名称为datanode[01-10]，以此类推。
1. namenode和datanode使用同一个镜像，只是在启动的时候需要使用不同的参数。
1. 目前该镜像只可以启动一个namenode和n个datanode。通过修改startup.sh脚本中的循环参数即可启动n个datanode容器，不同做特殊修改。

以上内容请参考startup.sh脚本


### 1.4.hive

hive严重依赖hdfs，所以在启动hive容器的时候一定要保证hdfs集群已经启动。

hive需要依赖HADOOP_HOME环境变量，并且需要调用HADOOP_HOME环境变量对应目录下的文件，所以需要用到--volumes-from namenode01启动参数。

详见startup.sh脚本



