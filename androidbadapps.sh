#!/system/bin/sh

case $1 in
    on) cmd=enable; word=Enabling ;;
    off) cmd=disable; word=Disabling ;;
    *) echo "Usage: androidbadapps.sh [on|off]"; exit
esac

apps=(
    com.google.android.gsf.login
    com.android.providers.downloads 
    com.android.providers.downloads.ui 
    com.google.android.gms 
    com.google.android.syncadapters.calendar 
    com.android.exchange 
    com.android.email 
    com.google.android.backuptransport 
    com.android.vending 
    com.google.android.gsf
)

for i in "${apps[@]}"
do
    echo "$word $i"
    pm $cmd $i
done
