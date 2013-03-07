#!/bin/sh

###
#  CHANGE the variable below to either the IP address or DNS name for your VERA
#
VERA_IP="192.168.10.35"

###
# UI4 form elements:  
# input type="file" name=upnp_file_x (1-10), type=file, filename=""
# input type="submit" name="go" value="GO"
# input type="checkbox" name="restart_lua" id="restart_lua" value="1"
#
shopt -s nullglob
for luupFile in $(ls *.xml *.json *.js *.lua); do
   i=$((i+1))
   formdata="${formdata} --form "upnp_file_${i}"=@${luupFile}"
done
shopt -u nullglob

# Upload the files to Vera
curl ${formdata} --form restart_lua=1 --form go="GO" --referer "http://${VERA_IP}/cmh/" -H Expect: "http://${VERA_IP}/cgi-bin/cmh/upload_upnp_file.sh"

# Separately request restart because the restart_lua=1 form element does not seem to work via curl
curl -k -s -S --fail --connect-timeout 7 --max-time 5 "http://${VERA_IP}:49451/data_request?id=lu_reload"
