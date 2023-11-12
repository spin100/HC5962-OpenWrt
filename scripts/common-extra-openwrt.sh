# 修改root密码
password=$(openssl passwd -1 'adminadmin')
sed -i "s|root::0:0:99999:7:::|root:$password:0:0:99999:7:::|g" package/base-files/files/etc/shadow
# 设置主机名称
sed -i 's/OpenWrt/danxiaonuo/g' package/base-files/files/bin/config_generate
sed -i '/uci commit system/i\uci set system.@system[0].hostname='神奇的List'' package/lean/default-settings/files/zzz-default-settings
# 重启WIFI
sed -i '/exit 0/i\# 启动WIFI\nnohup sleep 60 && /sbin/wifi up &' package/base-files/files/etc/rc.local
# 增加 SSID 2.5G
sed -i '/channel="11"/a\\t\tssid="HiwiFi-2HZ"' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 增加 SSID 5.0G
sed -i '/channel="36"/a\\t\t\tssid="HiwiFi-5HZ"' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认 SSID
sed -i 's/OpenWrt/${ssid}/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 修改默认密钥
sed -i 's/none/psk2/g' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 增加默认WIFI密码
sed -i '/set wireless.radio${devidx}.hwmode=11/a\\t\t\tset wireless.radio${devidx}.country=CN\n\t\t\tset wireless.radio${devidx}.legacy_rates=1\n\t\t\tset wireless.radio${devidx}.mu_beamformer=1' package/kernel/mac80211/files/lib/wifi/mac80211.sh
sed -i '/set wireless.default_radio${devidx}.encryption=psk2/a\\t\t\tset wireless.default_radio${devidx}.key=password\n\t\t\tset wireless.default_radio${devidx}.ieee80211k=1' package/kernel/mac80211/files/lib/wifi/mac80211.sh
# 增加自定义配置
svn co https://github.com/danxiaonuo/AutoBuild-OpenWrt/trunk/server/default-settings package/danxiaonuo/default-settings
# 增加IPV6
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/server/etc/99-ipv6 > package/base-files/files/etc/hotplug.d/99-ipv6
sed -i '/exit 0/i\mv /etc/hotplug.d/99-ipv6 /etc/hotplug.d/iface/99-ipv6' package/danxiaonuo/default-settings/files/zzz-default-settings
sed -i '/99-ipv6/a\chmod u+x /etc/hotplug.d/iface/99-ipv6' package/danxiaonuo/default-settings/files/zzz-default-settings
# 修改smartdns配置
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/server/smartdns/newsmartdns > package/base-files/files/etc/newsmartdns
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/server/smartdns/smartdns.conf > package/base-files/files/etc/smartdns.conf
sed -i '/exit 0/i\# 修改smartdns配置\nmv /etc/newsmartdns /etc/config/smartdns\nmv /etc/smartdns.conf /var/etc/smartdns/smartdns.conf' package/danxiaonuo/default-settings/files/zzz-default-settings
# 修改系统欢迎词
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/server/etc/banner > package/base-files/files/etc/banner
# 修改系统内核参数
curl -fsSL https://raw.githubusercontent.com/danxiaonuo/AutoBuild-OpenWrt/master/server/etc/sysctl.conf > package/base-files/files/etc/sysctl.conf
