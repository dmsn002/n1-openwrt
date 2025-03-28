#!/bin/bash
# Git稀疏克隆，只克隆指定目录到本地
function git_sparse_clone() {
  branch="$1" repourl="$2" && shift 2
  git clone --depth=1 -b $branch --single-branch --filter=blob:none --sparse $repourl
  repodir=$(echo $repourl | awk -F '/' '{print $(NF)}')
  cd $repodir && git sparse-checkout set $@
  mv -f $@ ../package
  cd .. && rm -rf $repodir
}

# Add packages
#添加科学上网源
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall-packages package/openwrt-passwall-packages
#git clone --depth=1 https://github.com/xiaorouji/openwrt-passwall package/openwrt-passwall
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-theme-argon package/luci-theme-argon
git clone -b 18.06 --single-branch --depth 1 https://github.com/jerrykuku/luci-app-argon-config package/luci-app-argon-config
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/amlogic
#git clone --depth=1 https://github.com/sirpdboy/luci-app-ddns-go package/ddnsgo
#git clone --depth=1 https://github.com/sirpdboy/NetSpeedTest package/NetSpeedTest

#git clone -b v5-lua --single-branch --depth 1 https://github.com/sbwml/luci-app-mosdns package/mosdns
git clone -b lua --single-branch --depth 1 https://github.com/sbwml/luci-app-alist package/alist
git clone --depth=1 https://github.com/gdy666/luci-app-lucky.git package/lucky
#添加自定义的软件包源
#ddns-go
git_sparse_clone main https://github.com/kiddin9/kwrt-packages ddns-go
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-ddns-go
#openclsh
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-openclash
#aria2
git_sparse_clone main https://github.com/kiddin9/kwrt-packages aria2
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-aria2
#docker
git_sparse_clone main https://github.com/kiddin9/kwrt-packages dockerd
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-docker
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-dockerman
#FTP
git_sparse_clone main https://github.com/kiddin9/kwrt-packages vsftpd
git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-vsftpd

# Remove packages
#删除lean库中的插件，使用自定义源中的包。
rm -rf feeds/packages/net/v2ray-geodata
rm -rf feeds/luci/themes/luci-theme-argon
rm -rf feeds/luci/applications/luci-app-argon-config
rm -rf feeds/packages/net/mosdns
rm -rf feeds/packages/utils/v2dat
rm -rf feeds/luci/applications/luci-app-mosdns
#rm -rf feeds/luci/themes/luci-theme-design
#rm -rf feeds/luci/applications/luci-app-design-config

# 替换luci-app-openvpn-server imm源的启动不了服务！
#rm -rf feeds/luci/applications/luci-app-openvpn-server
#git_sparse_clone main https://github.com/kiddin9/kwrt-packages luci-app-openvpn-server
# 调整 openvpn-server 到 VPN 菜单
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/controller/*.lua
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/model/cbi/openvpn-server/*.lua
#sed -i 's/services/vpn/g' package/luci-app-openvpn-server/luasrc/view/openvpn/*.htm
# 调整 ssr-plus 到 VPN 菜单
#sed -i 's/services/vpn/g' package/luci-app-ssr-plus/luasrc/controller/*.lua
#sed -i 's/services/vpn/g' package/luci-app-ssr-plus/luasrc/model/cbi/openvpn-server/*.lua
#sed -i 's/services/vpn/g' package/luci-app-ssr-plus/luasrc/view/ShadowSocksR Plus/*.htm
# 调整 passwall 到 VPN 菜单
#sed -i 's/services/vpn/g' package/luci-app-passwall/luasrc/controller/*.lua
#sed -i 's/services/vpn/g' package/luci-app-passwall/luasrc/model/cbi/openvpn-server/*.lua
#sed -i 's/services/vpn/g' package/luci-app-passwall/luasrc/view/Passwall/*.htm

# Default IP
sed -i 's/192.168.1.11/192.168.1.12/g' package/base-files/files/bin/config_generate

#修改默认时间格式
sed -i 's/os.date()/os.date("%Y-%m-%d %H:%M:%S %A")/g' $(find ./package/*/autocore/files/ -type f -name "index.htm")
