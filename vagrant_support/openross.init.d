#! /bin/sh
### BEGIN INIT INFO
# Provides:          openross
# Required-Start:    $local_fs $remote_fs $network $syslog
# Required-Stop:     $local_fs $remote_fs $network $syslog
# Default-Start:     2 3 4 5
# Default-Stop:      0 1 6
# Short-Description: Start/stop OpenRoss server
### END INIT INFO

logger "OpenRoss: Start script executed"
OPENROSS_SERVER_PATH="/vagrant/openross"
export PYTHONPATH="$OPENROSS_SERVER_PATH:$PYTHONPATH"

case "$1" in
  start)
    echo "Starting OpenRoss..."
    twistd -l "$OPENROSS_SERVER_PATH/openrossserver.log" --pidfile "$OPENROSS_SERVER_PATH/twistd.pid" --umask=022 openross
    ;;
  stop)
    logger "OpenRoss: Stopping"
    echo "Stopping GHServer..."
    kill `cat $OPENROSS_SERVER_PATH/twistd.pid`
    ;;
  *)
    logger "OpenRoss: Invalid usage"
    echo "Usage: /etc/init.d/openross {start|stop}"
    exit 1
    ;;
esac

exit 0
