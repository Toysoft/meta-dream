# DEPENDS += " upx-native"
do_upx() {
	if echo "${MACHINE_FEATURES}" | grep -q smallflash
	then
		echo "UPX - Binary compression"
		if [ "${TARGET_ARCH}" == "sh4" ] || [ "${TARGET_ARCH}" == "arm" ]
		then
			echo "Sorry UPX doesn't support sh4 and doesn't work reliably on arm.."
			echo "So no compression for your platform."
		else
			find "${WORKDIR}/packages-split/${PN}" -type f -executable | while read line
			do
				if [ "`file -b "${line}" | cut -d, -f1`" == "ELF 32-bit LSB executable" ]
				then
					echo "Let's try and compress: ${line}"
					upx --best --ultra-brute "${line}" || exit 0
				fi
			done
		fi
	fi
}
addtask upx before do_package_write_ipk after do_package_qa
