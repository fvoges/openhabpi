#!/bin/sh
### BEGIN INIT INFO
# Provides:          openhab
# Required-Start:    $remote_fs $syslog ntp
# Required-Stop:     $remote_fs $syslog 
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: OpenHAB Daemon
### END INIT INFO

# Author: Thomas Brettinger

# Do NOT "set -e"

# PATH should only include /usr/* if it runs after the mountnfs.sh script
PATH=/sbin:/usr/sbin:/bin:/usr/bin

DESC="Open Home Automation Bus Daemon"
NAME=openhab
DAEMON=/usr/bin/java
PIDFILE=/var/run/$NAME.pid
SCRIPTNAME=/etc/init.d/$NAME
ECLIPSEHOME="/home/openhab/runtime";
HTTPPORT=8080
HTTPSPORT=8443
TELNETPORT=5555
RUN_AS=openhab

# get path to equinox jar inside $eclipsehome folder
cp=$(find $ECLIPSEHOME/server -name "org.eclipse.equinox.launcher_*.jar" | sort | tail -1);

DAEMON_ARGS="-Dosgi.clean=true -Declipse.ignoreApp=true -Dosgi.noShutdown=true -Djetty.port=$HTTPPORT -Djetty.port.ssl=$HTTPSPORT -Djetty.home=$ECLIPSEHOME -Dlogback.configurationFile=$ECLIPSEHOME/configurations/logback.xml -Dfelix.fileinstall.dir=$ECLIPSEHOME/addons -Djava.library.path=$ECLIPSEHOME/lib -Djava.security.auth.login.config=$ECLIPSEHOME/etc/login.conf -Dorg.quartz.properties=$ECLIPSEHOME/etc/quartz.properties -Djava.awt.headless=true -jar $cp -console ${TELNETPORT} -server -XX:MarPermSize=384m -Xmx384m -XX:ReserveCodeCacheSize=96m"

# Exit if the package is not installed
[ -x "$DAEMON" ] || exit 0

# Read configuration variable file if it is present
[ -r /etc/default/$NAME ] && . /etc/default/$NAME

# Load the VERBOSE setting and other rcS variables
. /lib/init/vars.sh

# Define LSB log_* functions.
# Depend on lsb-base (>= 3.2-14) to ensure that this file is present
# and status_of_proc is working.
. /lib/lsb/init-functions

#
# Function that starts the daemon/service
#
do_start()
{
    # Return
    #   0 if daemon has been started
    #   1 if daemon was already running
    #   2 if daemon could not be started
    start-stop-daemon --start --quiet --make-pidfile --pidfile $PIDFILE --chuid $RUN_AS --chdir $ECLIPSEHOME --exec $DAEMON --test > /dev/null \
        || return 1
    start-stop-daemon --start --quiet --background --make-pidfile --pidfile $PIDFILE --chuid $RUN_AS --chdir $ECLIPSEHOME --exec $DAEMON -- $DAEMON_ARGS \
        || return 2
    # Add code here, if necessary, that waits for the process to be ready
    # to handle requests from services started subsequently which depend
    # on this one.  As a last resort, sleep for some time.
    return 0
}

#
# Function that stops the daemon/service
#
do_stop()
{
    # Return
    #   0 if daemon has been stopped
    #   1 if daemon was already stopped
    #   2 if daemon could not be stopped
    #   other if a failure occurred
    start-stop-daemon --stop --quiet --retry=TERM/30/KILL/5 --pidfile $PIDFILE --name $NAME
    RETVAL="$?"
    [ "$RETVAL" = 2 ] && return 2
    # Wait for children to finish too if this is a daemon that forks
    # and if the daemon is only ever run from this initscript.
    # If the above conditions are not satisfied then add some other code
    # that waits for the process to drop all resources that could be
    # needed by services started subsequently.  A last resort is to
    # sleep for some time.
    start-stop-daemon --stop --quiet --oknodo --retry=0/30/KILL/5 --exec $DAEMON
    [ "$?" = 2 ] && return 2
    # Many daemons don't delete their pidfiles when they exit.
    rm -f $PIDFILE
    return "$RETVAL"
}

#
# Function that sends a SIGHUP to the daemon/service
#
do_reload() {
    #
    # If the daemon can reload its configuration without
    # restarting (for example, when it is sent a SIGHUP),
    # then implement that here.
    #
    do_stop
    sleep 1
    do_start
    return 0
}

case "$1" in
  start)
    log_daemon_msg "Starting $DESC"
    do_start
    case "$?" in
        0|1) log_end_msg 0 ;;
        2) log_end_msg 1 ;;
    esac
    ;;
  stop)
    log_daemon_msg "Stopping $DESC"
    do_stop
    case "$?" in
        0|1) log_end_msg 0 ;;
        2) log_end_msg 1 ;;
    esac
    ;;
  status)
       status_of_proc "$DAEMON" "$NAME" && exit 0 || exit $?
       ;;
  #reload|force-reload)
    #
    # If do_reload() is not implemented then leave this commented out
    # and leave 'force-reload' as an alias for 'restart'.
    #
    #log_daemon_msg "Reloading $DESC" "$NAME"
    #do_reload
    #log_end_msg $?
    #;;
  restart|force-reload)
    #
    # If the "reload" option is implemented then remove the
    # 'force-reload' alias
    #
    log_daemon_msg "Restarting $DESC"
    do_stop
    case "$?" in
      0|1)
        do_start
        case "$?" in
            0) log_end_msg 0 ;;
            1) log_end_msg 1 ;; # Old process is still running
            *) log_end_msg 1 ;; # Failed to start
        esac
        ;;
      *)
          # Failed to stop
        log_end_msg 1
        ;;
    esac
    ;;
  *)
    #echo "Usage: $SCRIPTNAME {start|stop|restart|reload|force-reload}" >&2
    echo "Usage: $SCRIPTNAME {start|stop|status|restart|force-reload}" >&2
    exit 3
    ;;
esac