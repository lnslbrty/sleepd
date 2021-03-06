#!/bin/bash

#debug only
#exec 1>>/tmp/s2r.log
#exec 2>>/tmp/s2r.log

export NOTIF_TIME=20

if [ $(id -u) -ne 0 ]; then
	echo "$0: This script should be run as root!" >&2
	sudo $0
	exit 1
fi

if [ $# -eq 1 -a x"$1" = x"force" ]; then
	SLEEP_IMMED=1
else
	SLEEP_IMMED=0
fi

if [ -z "${SLEEPD_XUSER}" ]; then
	if [ -z "${SUDO_USER}" ]; then
		SLEEPD_XUSER="${USER}"
	else
		SLEEPD_XUSER="${SUDO_USER}"
	fi
fi

echo "$0: Running commands as ${SLEEPD_XUSER}" >&2

# user gets additional time before sleep if xidle avail
if [ ${SLEEP_IMMED} -eq 0 -a x"$(command -v xidle)" != x ]; then
	beep
	xidle >/dev/null 2>/dev/null
	if [ $? -eq 0 ]; then
		# display a notification before sleeping
		su -l ${SLEEPD_XUSER} -c "notify-send -t ${NOTIF_TIME}000 \"forced sleep in ${NOTIF_TIME}s; ${SLEEPD_UNUSED}s unused\""
		sleep ${NOTIF_TIME}
		if [ $(echo $(xidle)'<'"${NOTIF_TIME}".0|bc -l) -eq 1 ]; then
			su -l ${SLEEPD_XUSER} -c "notify-send -t 8 \"forced sleep manually aborted\""
			echo 'forced sleep aborted by user' | logger
			exit 1
		fi
	fi
fi

# lock screen
#xtrlock &
start-stop-daemon --start -b -c ${SLEEPD_XUSER} --exec  /usr/bin/xtrlock

SLEEP_DATE=$(date '+%d.%m.%y - %H:%M:%S')

# go to sleep
s2ram --force --no_kms --acpi_sleep 1

# give her some time to wakeup ;)
sleep 5
# show notify message after sleeping
su -l ${SLEEPD_XUSER} -c "notify-send -t ${NOTIF_TIME}000 \"wokeup from sleep; since ${SLEEP_DATE}\""
echo 'wokeup from sleep; since '"${SLEEP_DATE}" | logger

exit 0
