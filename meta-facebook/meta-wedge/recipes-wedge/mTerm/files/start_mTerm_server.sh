#!/bin/sh
#
# Copyright 2015-present Facebook. All Rights Reserved.
#
# This program file is free software; you can redistribute it and/or modify it
# under the terms of the GNU General Public License as published by the
# Free Software Foundation; version 2 of the License.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
# FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License
# for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program in a file named COPYING; if not, write to the
# Free Software Foundation, Inc.,
# 51 Franklin Street, Fifth Floor,
# Boston, MA 02110-1301 USA
#

### BEGIN INIT INFO
# Provides:         mTerm_server
# Required-Start:
# Required-Stop:
# Default-Start: S
# Default-Stop:
# Short-Description: starts a daemon for server
### END INIT INFO

PATH=/sbin:/bin:/usr/sbin:/usr/bin
NAME="mTerm_server"
DESC="microserver console connection"
DAEMON="mTerm_server.sh"

# source function library
. /etc/init.d/functions

. /usr/local/bin/openbmc-utils.sh

STOPPER=
ACTION="$1"

kill_mTerm_server() {
  pid=$(ps | grep -v grep | grep '/usr/local/bin/mTerm_server' -m 1 |
      awk '{print $1}')
  if [ $pid ] ; then
      kill $pid
  fi
}

case "$ACTION" in
  start)
    echo -n "Starting $DESC: "
    /usr/local/bin/${DAEMON} > /dev/null 2>&1 &
    echo "$NAME."
    ;;
  stop)
    echo -n "Stopping $DESC: "
    kill_mTerm_server
    echo "$NAME."
    ;;
  restart|force-reload)
    echo -n "Restarting $DESC: "
    kill_mTerm_server
    /usr/local/bin/${DAEMON} > /dev/null 2>&1 &
    echo "$NAME."
    ;;
  status)
    status ${DAEMON}
    exit $?
    ;;
  *)
    N=${0##*/}
    N=${N#[SK]??}
    echo "Usage: $N {start|stop|status|restart|force-reload}" >&2
    exit 1
    ;;
esac

exit 0
