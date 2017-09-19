### 编译

- mount 硬盘到 /data 目录下，然后进入 /data；
- 运行 set-env.sh 脚本，用以设置环境变量；
- 将 ```terark-zip-rocksdb-Linux-x86_64-g++-5.4-bmi2-0.tar.gz``` 拷贝到 /data 下，解压并改名 ```terark-zip-rocksdb-Linux-x86_64-gplusplus-5.4-bmi2-0```，改名目的是目录名称中如果带有 '+' 会影响编译；
- 进入 rocksdb，更新并 ```make shared_lib -j4```，把生成的动态库拷贝到 /opt/rocksdb 下；
- 进入 mongo-rocks，更新代码；
- 进入 mongo，如果需要，则更新代码，然后编译

```
$ scons \
	"CXX=/data/gcc-5.4.0/bin/g++" \
	"CC=/data/gcc-5.4.0/bin/gcc" \
	"LINKFLAGS=-Wl,-rpath-link=$TERARK_HOME/lib" \
	"CPPPATH=$ROCKSDB_INC $TERARK_HOME/include /data/zzz/include" \
	"LIBPATH=$ROCKSDB_LIB $TERARK_HOME/lib /data/zzz/lib /data/gcc-5.4.0/lib64" \
	--disable-warnings-as-errors mongod -j4 -Q VERBOSE=1
```

- 将生成的 mongod 拷贝到 /opt/mongo 下；
- 将 ```terark-zip-rocksdb-Linux-x86_64-g++-5.4-bmi2-0.tar.gz``` 拷贝到 ／opt 下，解压并改名 ```terark-zip-rocksdb-Linux-x86_64-gplusplus-5.4-bmi2-0```；


### 脚本介绍

青云通过回调用户（我们）提供的脚本，实现服务的启停、主从的设置等。我们提供的脚本包括（主要放置在 mongo/bin 下）：

- start.sh: 启动脚本，需要提供参数以指明是单机还是主从；
- stop.sh: 停止服务脚本；
- update-memeber.sh: 根据集群信息，与集群建立联系；
- monitor.sh: 收集服务的运行信息，反馈给青云，青云负责绘制并以图表的方式呈现给用户；
- sync-logs.sh: 用户无法远程登录服务所在的机器，这是我们额外提供给用户的接口，以方便他们获取日志信息；
- toml, tmpl 等若干集群相关的模版设置文件，包含在 /etc/confd 下；

### KVM 镜像

我们的服务是以 KVM 镜像的形式提供给用户的。完成上述步骤后，我们需要生成 KVM 镜像。

所有的用户数据需要存在于挂盘里。mongo 的 datadir 设置在 /mongo-on-terark，系统启动时会将硬盘挂载在该位置。

### 配置文件

提交审核前，我们需要将配置文件打包提交，包括有：

- config.json：定义最终用户在控制台部署应用实例时需要填写的表单，例如有哪些可选的系统资源等；
- cluster.json.mustache：包含创建应用实例时需要用到的镜像、多少类节点、服务启动命令等信息文件。主从信息、镜像名称、以及脚本命令等都在这个文件里。

### 其他

青云部署的[官方文档](https://appcenter-docs.qingcloud.com/developer-guide/)









