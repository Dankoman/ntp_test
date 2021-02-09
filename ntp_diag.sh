#!/bin/bash

# Tidsintervall mellan förfråningar.
INTERVAL=2

# Körtid i minuter
DURATION=1

# Tidsserver att ställa frågor mot.
SERVER="192.36.143.130"

# Fulständig sökväg till output fil. Om filen inte finns skapas den annars fylls befintlig fil på.
OUT="/tmp/timediff_10.csv"

# Plockar ut aktuellt år eftersom ntpdate endast använder Amerikanskt datumformat utan år.
YEAR=`date +"%Y"`
TIMESTAMP=`date +"%Y-%m-%d, %T"`

let loops=($DURATION*60)/$INTERVAL
let end=$loops+1
#echo $loops



# Funktion för att ställa fråga mot angiven tidsserver, samt trimma ner output till intressant data.
get_ntp_time () {
    ##printf "$(date +%Y-%m-%d), $(date +%T:%N), " >> $OUT

    #ska byta till den här ntpdate -q ntp.ubuntu.com|grep -v "^server "
    RawOutput=$(ntpdate -q $SERVER)

    echo $RawOutput | sed 's/,//' |awk  -vyr="$YEAR" -vts="$TIMESTAMP" -F " "  '{ print $2", "ts",",$9 " " $10 " " yr", "$11 ",",$4 ,$6 ,$8}'#>>$OUT
    #ntpdate -q $SERVER | grep -v "ntpdate" | awk  -vyr="$TIMESTAMP" -F " "  '{ print yr",",$3",",$8",",$10 }'
}

# Funktion för att skriva output till fil
log_to_file () {
    # Om filen saknas skapas den, och kollumnrubriker skrivs.
    if [ ! -f "$OUT" ]; then
        touch $OUT
        echo 'Server, Local Date, Local Timestamp, Server date, Server time, Stratum, Offset, Delay, Offset STD, "=STDEV(G2:G'$end')", Delay STD, "=STDEV(H2:H'$end')" ' > $OUT

        
        get_ntp_time >> $OUT
    # Om filen finns fylls den på med data
    else
        get_ntp_time >> $OUT    
    fi
}

echo "Frågar "$SERVER" med intervall på "$INTERVAL" sekunder."
echo "Sparar till:" $OUT. 
echo "Avbryt körning med Ctrl+C"
echo ""

# Oändlig loop som kör log_to_file med givet intervall.
i=1
while [ $i -le $loops ]
do

  echo -e '\e[1A\e[KFråga' $i'/'$loops
  
  #get_ntp_time
  log_to_file
  
  sleep $INTERVAL
  i=$(( $i + 1 ))
done