SRC_URI_remove = "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=main;name=rdk-wifi-hal"

SRC_URI += "git://github.com/bmilcz-comcast/rdk-wifi-hal.git;protocol=https;branch=bpi-link-reconf;name=rdk-wifi-hal"
SRCREV_rdk-wifi-hal = "106da049648be30c121f60eaa1e4b5688a501ebf"

#SRC_URI += "git://github.com/rdkcentral/rdk-wifi-hal.git;protocol=https;branch=develop;name=rdk-wifi-hal"
#SRCREV_rdk-wifi-hal = "de43a39e703449211a4c0f240dcc34c198b9cc15"

CFLAGS_append = " -D_PLATFORM_BANANAPI_R4_  -DBANANA_PI_PORT  -DFEATURE_SINGLE_PHY -DCONFIG_HW_CAPABILITIES "

CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'generic_mlo', ' -DCONFIG_GENERIC_MLO -DCONFIG_MLO ', '', d)}"
CFLAGS_append = "${@bb.utils.contains('DISTRO_FEATURES', 'kernel6-6' , ' -DKERNEL_6_6 ','', d)}"
CFLAGS_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' -DEASY_MESH_NODE  ', '', d)}"

CFLAGS_append_kirkstone = " -fcommon"
CFLAGS_remove = "-DCONFIG_MBO"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' ONE_WIFIBUILD=true ', '', d)}"
EXTRA_OECONF_append = " ${@bb.utils.contains('DISTRO_FEATURES', 'OneWifi', ' BANANA_PI_PORT=true ', '', d)}"

FILESEXTRAPATHS_prepend := "${THISDIR}/files:"

SRC_URI += " \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' file://InterfaceMap_em.json ', 'file://InterfaceMap.json ', d)} \
  ${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', bb.utils.contains('DISTRO_FEATURES', 'em_extender', 'file://EasymeshCfg_ext.json ','file://EasymeshCfg.json ', d), ' ', d)} \
"

# Install InterfaceMap.json in /usr/ccsp/wifi
do_install_append() {
  install -d ${D}/usr/ccsp/wifi
  install -m 0644 ${WORKDIR}/InterfaceMa*.json ${D}/usr/ccsp/wifi/InterfaceMap.json
  DISTRO_EM_ENABLED="${@bb.utils.contains('DISTRO_FEATURES','EasyMesh','true','false',d)}"
  if [ $DISTRO_EM_ENABLED = 'true' ]; then
     install -d ${D}/usr/ccsp/EasyMesh
     install -m 0644 ${WORKDIR}/Easymesh*.json  ${D}/usr/ccsp/EasyMesh/EasymeshCfg.json
  fi
}

FILES_${PN} += " \
  /usr/ccsp/wifi/* \
"

FILES_${PN}_append = "${@bb.utils.contains('DISTRO_FEATURES', 'EasyMesh', ' /usr/ccsp/EasyMesh/* ', '', d)}"
