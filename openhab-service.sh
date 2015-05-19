#!/bin/bash

###########################
# Check for contents in Configu directory

if [ "$(ls -A ${APP_CONFIG})" ]
then
  echo "Configuration directory not empty"
else
  echo "Configuration directory empty. Copying defaults"
  cp -a "${APP_HOME}/defaults/." "${APP_CONFIG}/"
fi

###########################
# Configure Addon libraries

ADDON_SOURCE=$APP_HOME/addons-available
ADDON_DEST=$APP_HOME/addons
ADDON_FILE=$APP_CONFIG/addons.cfg

function addons {
  # Remove all links first
  rm $ADDON_DEST/*

  # create new links based on input file
  while read STRING
  do
    echo Processing $STRING...
    if [ -f $ADDON_SOURCE/$STRING-*.jar ]
    then
      ln -s $ADDON_/$STRING-*.jar $ADDON_DEST/
      echo link created.
    else
      echo not found.
    fi
  done < "$ADDON_FILE"
}

if [ -f "$ADDON_FILE" ]
then
  addons
else
  echo addons.cfg not found.
fi

###########################################
# Setup TouchUI if exists

UI_SOURCE=${APP_HOME}/webapps/greent

if [ -f ${APP_CONFIG}/items/greent.items ]
then
  echo TouchUI items found.
else
  mv ${UI_SOURCE}/greent.items ${APP_CONFIG}/items/
fi

if [ -f ${APP_CONFIG}/greent/settings.cfg ]
then
  rm -f ${UI_SOURCE}/configs/settings.cfg
  cp -f ${APP_CONFIG}/greent/settings.cfg ${UI_SOURCE}/configs/settings.cfg
fi

###########################################
# Download Demo if no configuration is given

if [ -f $APP_CONFIG/openhab.cfg ]
then
  echo configuration found.
else
  echo --------------------------------------------------------
  echo          NO openhab.cfg CONFIGURATION FOUND
  echo
  echo                = using demo files =
  echo
  echo Consider running the Docker with a openhab configuration
  echo 
  echo --------------------------------------------------------
  cp -R ${APP_HOME}/demo/configurations/* ${APP_CONFIG}/
  ln -s ${APP_HOME}/demo/addons/* ${APP_HOME}/addons/
  cp ${APP_CONFIG}/openhab_default.cfg ${APP_CONFIG}/openhab.cfg
fi

chown -R openhab:openhab ${APP_HOME}
chown -R openhab:openhab ${APP_CONFIG}

/sbin/setuser openhab /opt/openhab/openhab-launcher.sh

