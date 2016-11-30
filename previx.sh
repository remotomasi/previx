#!/bin/bash
#
# D7v2 v1.0
#
# Weather Informations
#
# Extract weather informations from the sites "worldweatheronline" and
# "openweathermap" it makes an average and show them on screen.
#
# Where you see "key" or "appid" in the script you have to substitute them
# with your personal keys obtained during sign up to these sites.
# The same thing you can do when you meet "q=" --> name of your city
#
# remotomasi: https://github.com/remotomasi
#
# Creative Commons (cc) BY-NC 2016 Remo Tomasi • remo.tomasi@gmail.com
###############################################################################
wget "http://api.worldweatheronline.com/free/v2/weather.ashx?q=City&format=xml&num_of_days=5&key=*****************************" 2>/dev/null -O -|  tr '/' '\n\r' > tempo3.xml
cat tempo3.xml | head -n 704 | tail -n 339 > tempo4.xml
rm tempo3.xml; cat tempo4.xml > tempo3.xml; rm tempo4.xml
wget "http://api.openweathermap.org/data/2.5/forecast/daily?q=City&mode=xml&units=metric&cnt=3&lang=it&appid=********************************" 2>/dev/null -O -| tr '>' '\n' | tr '/' ' ' | tr '"' ' ' | tr '<' ' ' > tempo.txt
data=$(cat tempo3.xml | grep "<weather><date>" | cut -d'<' -f3 | cut -d'>' -f2)
echo "--------------------------------------------"
echo "Meteo Casarano    :" $(echo $data | cut -d' ' -f2)
echo "--------------------------------------------"
echo "                  : WWO| OWM "
echo "--------------------------------------------"
Tmax=$(cat tempo3.xml | grep "maxtempC" | head -n 1 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
Tmax2=$(cat tempo.txt | grep temperature | head -n 1 | tail -n 1 | cut -d'=' -f4 | cut -d' ' -f2)
TmaxMed=$(bc -l <<< "($Tmax + $Tmax2) / 2")
Tma=$(echo $Tmax "   | " $Tmax2 "   | " $TmaxMed )
echo "Tmax              :" ${Tma:0:${#Tma}-18}
Tmin=$(cat tempo3.xml | grep "mintempC" | head -n 1 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
Tmin2=$(cat tempo.txt | grep temperature | head -n 1 | tail -n 1 | cut -d'=' -f3 | cut -d' ' -f2)
TminMed=$(bc -l <<< "($Tmin + $Tmin2) / 2")
Tmi=$(echo $Tmin "   | " $Tmin2 "   | " $TminMed)
echo "Tmin              :" ${Tmi:0:${#Tmi}-18}
pressure1=$(cat tempo3.xml | grep "pressure" | head -n 1 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
pressure13=$(cat tempo3.xml | grep "pressure" | head -n 9 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
pressure22=$(cat tempo3.xml | grep "pressure" | head -n 15 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
pressureM=$(bc -l <<< "($pressure1 + $pressure13 + $pressure22) / 3"); pressureM=$(echo $pressureM | cut -d'.' -f1)
pressure=$(cat tempo.txt | grep pressure |  head -n 1 | tail -n 1 | cut -d'=' -f3 | cut -d'u' -f1)
pressureMed=$(bc -l <<< "($pressureM + $pressure) / 2")
pres=$(echo $pressureM " | " $pressure " | " $pressureMed)
echo "Pressure          :" ${pres:0:${#pres}-18}
humidity1=$(cat tempo3.xml | grep "humidity" | head -n 1 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
humidity13=$(cat tempo3.xml | grep "humidity" | head -n 9 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
humidity22=$(cat tempo3.xml | grep "humidity" | head -n 15 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
humidityM=$(bc -l <<< "($humidity1 + $humidity13 + $humidity13) / 3"); humidityM=$(echo $humidityM | cut -d'.' -f1)
humidity=$(cat tempo.txt | grep humidity | head -n 1 | tail -n 1 | cut -d'=' -f2 | cut -d'u' -f1)
humidityMed=$(bc -l <<< "($humidityM + $humidity) / 2")
hum=$(echo $humidityM "   | " $humidity "      | " $humidityMed)
echo "Umidita'          :" ${hum:0:${#hum}-18}
windspeed1=$(cat tempo3.xml | grep "windspeedKmph" | head -n 1 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
windspeed13=$(cat tempo3.xml | grep "windspeedKmph" | head -n 9 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
windspeed22=$(cat tempo3.xml | grep "windspeedKmph" | head -n 15 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
windspeedM=$(bc -l <<< "($windspeed1 + $windspeed13 + $windspeed22) / 3"); windspeedM=$(echo $windspeedM | cut -d'.' -f1)
windspeed=$(cat tempo.txt | grep windSpeed | head -n 2 | tail -n 1 | cut -d'=' -f2 | cut -d'n' -f1)
windspeed=$(bc -l <<< "$windspeed * 3.6")
windspeedMed=$(bc -l <<< "($windspeedM + $windspeed) / 2")
windsp=$(echo $windspeedM " | " $windspeed " | " $windspeedMed)
echo "Vento (Velocita') :" ${windsp:0:${#windsp}-18}
winddir1=$(cat tempo3.xml | grep "winddir16Point" | head -n 1 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
winddir13=$(cat tempo3.xml | grep "winddir16Point" | head -n 9 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
winddir22=$(cat tempo3.xml | grep "winddir16Point" | head -n 15 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
windir=$(cat tempo.txt | grep windDirection | head -n 1 | tail -n 1 | cut -d'=' -f3 | cut -d'n' -f1)
echo "Vento (Direzione) :" $winddir1 "|" $windir
cielo1=$(cat tempo3.xml | grep "CDATA" | head -n 2 | tail -n 1 | cut -d'[' -f3 | cut -d']' -f1)
cielo13=$(cat tempo3.xml | grep "CDATA" | head -n 10 | tail -n 1 | cut -d'[' -f3 | cut -d']' -f1)
cielo22=$(cat tempo3.xml | grep "CDATA" | head -n 16 | tail -n 1 | cut -d'[' -f3 | cut -d']' -f1)
b=$(cat tempo.txt | grep symbol | head -n 1 | tail -n 1 | cut -d'=' -f3)
echo "Cielo             :"  $cielo1 "-" $cielo13 "-" $cielo22 " | " ${b:0:${#b}-3}
copertura1=$(cat tempo3.xml | grep "cloudcover" | head -n 1 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
copertura13=$(cat tempo3.xml | grep "cloudcover" | head -n 9 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
copertura22=$(cat tempo3.xml | grep "cloudcover" | head -n 15 | tail -n 1 | cut -d'>' -f3 | cut -d'<' -f1)
copertura=$(cat tempo.txt | grep clouds | head -n 1 | tail -n 1 | cut -d'=' -f3 | cut -d' ' -f2)
coperturaM=$(bc -l <<< "($copertura1 + $copertura13 + $copertura22) / 3"); coperturaM=$(echo $coperturaM | cut -d'.' -f1)
coperturaMed=$(bc -l <<< "($coperturaM + $copertura) / 2")
cop=$(echo $coperturaM " | " $copertura " | " $coperturaMed)
echo "Copertura         :" ${cop:0:${#cop}-18}
