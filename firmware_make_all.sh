#!/bin/bash

#E CONFIG START

DIR_FIRMWARE=/home/pi/printer_data/config/_other/firmware
DIR_BOARDS=/home/pi/printer_data/config/_other/boards
DIR_KLIPPER=/home/pi/klipper
MAKE_LOG=/tmp/last_make.txt

### CONFIG END

SCRIPT_DIR=$(cd "$(dirname "${BASH_SOURCE[0]}")" &> /dev/null && pwd)
DATE=$(date +'%Y-%m-%d')

echo "Date: $DATE"

echo "Boards: "
for entry in "$DIR_BOARDS"/*
do
  if [ -d "$entry" ]
  then
    BOARD=$(basename -- "$entry")
    echo "> $BOARD"

    CONFIG_FILE_TEMPLATE="$DIR_BOARDS/$BOARD/make_config.txt"

    if [ -f "$CONFIG_FILE_TEMPLATE" ]
    then

      if [ -f "$DIR_KLIPPER/.config" ]
      then
        echo "  deleting existing config..."
        rm "$DIR_KLIPPER/.config"  | sed 's/^/    /'
        echo "  done"
      fi


      cd $DIR_KLIPPER  | sed 's/^/    /'
      echo "  cleaning make..."
      make clean  | sed 's/^/    /'

      echo "  copying config template..."
      cp "$CONFIG_FILE_TEMPLATE" "$DIR_KLIPPER/.config" | sed 's/^/    /'
      cd $DIR_KLIPPER
      if [ -f "$MAKE_LOG" ]
      then
        rm "$MAKE_LOG"
      fi
      echo "  building firmware..."
      make | tee /tmp/last_make.txt | sed 's/^/    /'

      CREATED=$(cat "$MAKE_LOG" | grep "Creating" | tail -n 1 | awk '{print $NF}')
      echo "  created file: $CREATED"

      if [ -f "$DIR_KLIPPER/$CREATED" ]
      then
        echo " .. created file exists!"

        CFF=$(basename -- "$CREATED")
        CFE="${CFF##*.}"
        CFN="${CFF%.*}"
        echo " .. full filename: $CFF"
        echo " .. .. extension: $CFE"
        echo " .. .. name: $CFN"

        mkdir -p "$DIR_FIRMWARE/$DATE"

        if [ -f "$DIR_FIRMWARE/$DATE/$CFN.$CFE" ]
        then
          rm "$DIR_FIRMWARE/$DATE/$CFN.$CFE"
          echo "  erased old firmware file"
        fi
        cp "$DIR_KLIPPER/$CREATED" "$DIR_FIRMWARE/$DATE/$CFN.$BOARD.$CFE"

        if [ -f "$DIR_FIRMWARE/$DATE/$CFN.$CFE.txt" ]
        then
          rm "$DIR_FIRMWARE/$DATE/$CFN.$CFE.txt"
          echo " erased old firmware log"
        fi
        cp "$MAKE_LOG" "$DIR_FIRMWARE/$DATE/$CFN.$BOARD.$CFE.txt"

      fi

    else
      echo "  Error: config file template not found at $CONFIG_FILE_TEMPLATE"
    fi

  fi
done

cd $SCRIPT_DIR
