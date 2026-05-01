#!/bin/bash

if [ "$(whoami)" != "root" ]; then
        echo "Script must be run as user: root"
        exit 255
fi

# Copy /etc/skel

if [ "$SHAREDDIR" = "" ]; then
    echo 'Variable $SHAREDDIR should be defined'
fi

for f in $SHAREDDIR/etc/skel/.*
do
  echo "Processing $f"
  if [ -f "/etc/skel$(basename $f)" ]; then
      echo "File /etc/skel/$(basename $f)" exists already
  else
      cp $f /etc/skel
  fi
done


read -p "user name: " USERNAME

if [ "$(id -u -n $USERNAME 2> /dev/null)" = "$USERNAME" ]; then
    echo "The user $USERNAME already exists."
    exit 0
else
    echo "Creating user $USERNAME."
    useradd -m "$USERNAME"
fi
