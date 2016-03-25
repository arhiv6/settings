#!/bin/bash

# Скрипт выводит сообщения через notify-send и может работать при вызове из cron или udev-rules
# https://habrahabr.ru/post/47892/

#----------------------------------------------------------------------------------------------

# get_user [] -- Returns USER name.
get_user () {
    tmp=`who`;echo ${tmp%% *}
}
#get_user () {
#	TMP1=`dirname $1`
#	TMP2=${TMP1##/home/}
#	TMP3=${TMP2%%/*} || $TMP2
#	echo $TMP3
#}
USER=$(get_user) || $LOGNAME # || $(get_user "$0")
HOME=/home/$USER
export HOME

#----------------------------------------------------------------------------------------------

# get_display [USER] -- Returns $DISPLAY of USER.
# If first param is omitted, then $LOGNAME will be used.
get_display () {
    who \
        | grep ${1:-$LOGNAME} \
        | perl -ne 'if ( m!\(\:(\d+)\)$! ) {print ":$1.0\n"; $ok = 1; last} END {exit !$ok}'
}
DISPLAY=$(get_display $USER) || DISPLAY=:0.0
export DISPLAY

#----------------------------------------------------------------------------------------------

notify-send  -t 3000 "$@"

