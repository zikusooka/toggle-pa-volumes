#!/bin/sh
# Copyright (C) 2014 Joseph Zikusooka.
#
# Contact me at: joseph AT zikusooka.com

#    This program is free software: you can redistribute it and/or modify
#    it under the terms of the GNU General Public License as published by
#    the Free Software Foundation, either version 3 of the License, or
#    (at your option) any later version.
#
#    This program is distributed in the hope that it will be useful,
#    but WITHOUT ANY WARRANTY; without even the implied warranty of
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
#    GNU General Public License for more details.
#
#    You should have received a copy of the GNU General Public License
#    along with this program.  If not, see the file COPYING or <http://www.gnu.org/licenses/>.


# Variables
CLIENT_VOLUME="120%"
CLIENT_LIST_FILE=/tmp/pa-clients-switcher.log
CLIENT_NUMBERS=`pactl list short sink-inputs | awk {'print $1'}`
# Unused
PA_USER=`pactl info | grep -i 'User Name' | awk {'print $3'}` 
SCRIPT_USER=`whoami`



###############
#  FUNCTIONS  #
###############

cycle_thru_client_numbers () {
echo $CLIENT_NUMBERS | tr " " "\n" | while read CLIENT_NO
do
$1 $2 $CLIENT_NO
done
}

mute_all_clients () {
echo $CLIENT_NUMBERS | tr " " "\n" | while read CLIENT_NO
do
pactl set-sink-input-mute $CLIENT_NO 1
done
}



#################
#  MAIN SCRIPT  #
#################

# See if this is first time to run script
[ -s $CLIENT_LIST_FILE ] || cycle_thru_client_numbers echo >> $CLIENT_LIST_FILE

# Mute all clients
mute_all_clients

# Get next client number from list
CLIENT_NO=`head -1 $CLIENT_LIST_FILE`

# Play next client No.
#---------------------
# Unmute
pactl set-sink-input-mute $CLIENT_NO 0
# Set volume # NOT NEEDED -> Messes up volume level
#pactl set-sink-input-volume $CLIENT_NO $CLIENT_VOLUME

# Remove played client number from list
sed -i -e '1d' $CLIENT_LIST_FILE

# Quit
exit 0
