#!/bin/bash 

if [ -z $HTTP_PORT ]; then
        HTTP_PORT=8080
fi
if [ -z $HTTPS_PORT ]; then
        HTTPS_PORT=8443
fi
if [ -z $TELNET_PORT ]; then
        TELNET_PORT=5555
fi

JAVA="/usr/bin/java"
LAUNCHER=`ls ${APP_HOME}/server/plugins/org.eclipse.equinox.launcher_*.jar`

# Exit if the package is not installed
if [ ! -r "$LAUNCHER" ]; then
    echo "launcher jar is missing" >&2
    exit 5
fi

if [ ! -x "${JAVA}" ]; then
        echo "Error: no java executable found at ${JAVA}" >&2
        exit 2
fi

JAVA_ARGS_DEFAULT="-Dosgi.clean=true \
 -Declipse.ignoreApp=true \
 -Dosgi.noShutdown=true \
 -Djetty.port=${HTTP_PORT} \
 -Djetty.port.ssl=${HTTPS_PORT} \
 -Djetty.home="${APP_HOME}" \
 -Dopenhab.logdir="${APP_LOG}" \
 -Dsmarthome.userdata="${APP_DATA}" \
 -Djetty.logs="${APP_LOG}" \
 -Djava.library.path=lib \
 -Dfelix.fileinstall.dir="${APP_HOME}/addons" \
 -Dfelix.fileinstall.filter=.*\\.jar \
 -Djava.security.auth.login.config="${APP_HOME}/etc/login.conf" \
 -Dorg.quartz.properties="${APP_HOME}/etc/quartz.properties" \
 -Dequinox.ds.block_timeout=240000 \
 -Dequinox.scr.waitTimeOnBlock=60000 \
 -Dfelix.fileinstall.active.level=4 \
 -Djava.awt.headless=true \
 -jar ${LAUNCHER} \
 -data "${APP_DATA}/workspace" \
 -configuration "${APP_DATA}/workspace" \
 -console ${TELNET_PORT}"

JAVA_ARGS_DUMB="
 -Dopenhab.configfile="${OPENHAB_CONF_DIR}/configurations/openhab.cfg" \
 -Dopenhab.configdir="${OPENHAB_CONF_DIR}/configurations" \
 -Dopenhab.logdir="${OPENHAB_LOG_DIR}" \
 -Djetty.config="${OPENHAB_CONF_DIR}/jetty" \
 -Djetty.logs="${OPENHAB_LOG_DIR}" \
 -Djetty.rundir="${OPENHAB_DIR}" \
 -Djava.library.path="${OPENHAB_DIR}/lib""

JAVA_ARGS_RUN="-Dlogback.configurationFile=${APP_CONFIG}/logback.xml ${JAVA_ARGS_DEFAULT}"

cd ${APP_HOME}
echo Starting OpenHAB Runtime
$JAVA $JAVA_ARGS_RUN

