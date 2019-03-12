include(utils.m4)dnl Include utility macros
include(repository.m4)dnl Include Repository command
----------------------------------------------------------------------------------

-- Updater itself
Install('updater-ng', 'updater-ng-supervisor', { critical = true })
Package('updater-ng', { replan = 'finished' })
Package('l10n_supported', { replan = 'finished' })

-- Critical minimum
Install("base-files", "busybox", "dns-resolver", { critical = true })
-- Kernel
Package("kernel", { reboot = "delayed" })
Package("kmod-mac80211", { reboot = "delayed" })
forInstallCritical(kmod,file2args(kmod.list))
if model:match("[Mm][Oo][Xx]") then
	forInstallCritical(kmod,file2args(kmod-mox.list))
elseif model:match("[Oo]mnia") then
	forInstallCritical(kmod,file2args(kmod-omnia.list))
elseif model:match("^[Tt]urris$") then
	forInstallCritical(kmod,file2args(kmod-turris.list))
end
Install("fstools", { critical = true })
if model:match("^[Tt]urris$") then
	Install("turris-support", { critical = true })
end
if model:match("[Oo]mnia") then
	Install("omnia-support", { critical = true })
elseif model:match("[Mm][Oo][Xx]") then
	Install("mox-support", { critical = true })
	Install("zram-swap", { priority = 40 })
end

-- OpenWRT minimum
Install("procd", "ubus", "uci", "netifd", "firewall", { critical = true})
Install("ebtables", "odhcpd", "odhcp6c", "rpcd", { priority = 40 })
Install("opkg", "libustream-openssl", { priority = 40 })
if model:match("^[Tt]urris$") then
	Install("swconfig", { critical = true })
end

-- Turris minimum
Install("vixie-cron", "syslog-ng", { priority = 40 })
Install("logrotate", { priority = 40 })
Install("dnsmasq-full", { priority = 40 })
if model:match("^[Tt]urris$") then
	Install("unbound", "unbound-anchor", { priority = 40 })
	Install("turris-btrfs", { priority = 40 }) -- Currently only SD card root is supported
else
	Install("knot-resolver", { priority = 40 })
end
Install("ppp", "ppp-mod-pppoe", { priority = 40 })

-- Certificates
Install("dnssec-rootkey", "cznic-cacert-bundle", "cznic-repo-keys", { critical = true })
-- Note: We don't ensure safety of these CAs
Install("ca-certificates", { priority = 40 })

_FEATURE_GUARD_

-- Updater utility
Install("updater-ng-opkg", { priority = 40 })
Package('updater-ng-opkg', { replan = 'finished' })
Package('updater-ng-localrepo', { replan = 'finished' })
Package('switch-branch', { priority = 40 })
-- Package migration hack
Install("oneshot")

-- Utility
Install("ip-full", "tc", "genl", "ip-bridge", "ss", "nstat", "devlink", "rdma", { priority = 40 })
Install("iputils-ping", "iputils-ping6", "iputils-tracepath", "iputils-tracepath6", "iputils-traceroute6", { priority = 40 })
Install("iptables", "ip6tables", "conntrack", { priority = 40 })
Install("shadow", "shadow-utils", "uboot-envtools", "i2c-tools", { priority = 40 })
Install("openssh-client", "openssh-client-utils", "openssh-moduli", "openssh-server", "openssh-sftp-client", "openssh-sftp-server", "openssl-util", { priority = 40 })
Uninstall("dropbear", { priority = 40 })
Install("bind-client", "bind-dig", { priority = 40 })
Install("pciutils", "usbutils", "lsof", "btrfs-progs", { priority = 40 })
Install("lm-sensors", { priority = 40 })
Install("haveged", { priority = 40 })
Install("umdns", { priority = 40 })

-- Turris utility
Install("turris-version", "start-indicator", { priority = 40 })
Install("turris-utils", "user-notify", "watchdog_adjust", { priority = 40 })
if for_l10n then
	for_l10n("user-notify-l10n-")
end
local use_atsha204 = false
if model:match("[Mm][Oo][Xx]") then
	Install("mox-otp", { priority = 40 })
elseif model:match("[Oo]mnia") then
	Install("rainbow-omnia", { priority = 40 })
	use_atsha204 = true
elseif model:match("^[Tt]urris$") then
	Install("rainbow", { priority = 40 })
	use_atsha204 = true
end
if use_atsha204 then
	Install("libatsha204", "update_mac", { priority = 40 })
end
if not model:match("^[Tt]urris$") then
	Install("schnapps", { priority = 40 })
end


-- Wifi
Install("hostapd-common", "wireless-tools", "wpad", "iw", "iwinfo", { priority = 40 })
Install("ath10k-firmware-qca988x-ct", { priority = 40 })
if model:match("[Mm][Oo][Xx]") then
	Install("mwifiex-sdio-firmware", { priority = 40 })
end

_END_FEATURE_GUARD_
