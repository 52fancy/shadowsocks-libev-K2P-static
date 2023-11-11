# shadowsocks-libev-K2P-static
Debian环境下为K2P静态编译shadowsocks-libev


### 编译说明 ###

* 安装依赖包

```shell

apt update
apt install -y build-essential cmake git wget

```

* 克隆源码

```shell
git clone --depth=1 https://e.coding.net/hanwckf/rt-n56u/padavan.git /opt/rt-n56u
#git clone --depth=1 https://github.com/hanwckf/rt-n56u.git /opt/rt-n56u
```

* 准备工具链

```shell
cd /opt/rt-n56u/toolchain-mipsel

# （推荐）使用脚本下载预编译的工具链：
sh dl_toolchain.sh

# 或者，也可以从源码编译工具链，这需要一些时间：
./clean_toolchain
./build_toolchain

```

* 配置工具链环境

```shell
export PATH=/opt/rt-n56u/toolchain-mipsel/toolchain-3.4.x/bin/:$PATH
export CC=mipsel-linux-uclibc-gcc
```

* 开始编译

```shell
bash <(wget --no-check-certificate -qO- 'https://github.com/52fancy/shadowsocks-libev-K2P-static/raw/main/ss-libev.sh')
# 编译成品在/opt/projects/中

```
