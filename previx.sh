#!/bin/bash
#
# previx
#
# Weather Informations
#
# Extract weather informations from the sites "www.apixu.com" and
# "openweathermap" it makes an average and show them on screen.
#
# Where you see "key" or "appid" in the script you have to substitute them
# with your personal keys obtained during sign up to these sites.
# The same thing you can do when you meet "q=" --> name of your city ($city)
#
# remotomasi: https://github.com/remotomasi
#
#                     GNU AFFERO GENERAL PUBLIC LICENSE
#                        Version 3, 19 November 2007
#
# Copyright (C) 2007 Free Software Foundation, Inc. <http://fsf.org/>
# Everyone is permitted to copy and distribute verbatim copies
# of this license document, but changing it is not allowed.
#
# 2016 Remo Tomasi • remo.tomasi@gmail.com
#

clear
echo "Insert the name of your city: "
read city
if [ -e "tempo1.xml" ]; then rm tempo1.xml; fi
if [ -e "tempo2.xml" ]; then rm tempo2.xml; fi
wget "https://api.apixu.com/v1/current.json?key=*******************&q=$city" 2>/dev/null -O tempo1.json
wget "http://api.openweathermap.org/data/2.5/weather?q=$city,it&appid=*******************" 2>/dev/null -O tempo2.json
data=$(date -u)
echo "--------------------------------------------"
echo "Meteo>>" $city $(echo $data)
echo "--------------------------------------------"
echo "                  : APX | OWM "
echo "--------------------------------------------"
T1=$(cat tempo1.json* | jq -r '.current.temp_c')
T2=$(cat tempo2.json | jq -r '.main.temp')
T2=$(bc -l <<< "$T2 -273.15")
Tma=$(echo $T1 "   |   " $T2  )
echo "Tmax              :" $Tma
pressure1=$(cat tempo1.json* | jq -r '.current.pressure_mb')
pressure2=$(cat tempo2.json | jq -r '.main.pressure')
pres=$(echo $pressure1 " | " $pressure2 )
echo "Pressure          :" $pres
humidity1=$(cat tempo1.json* | jq -r '.current.humidity')
humidity2=$(cat tempo2.json | jq -r '.main.humidity')
hum=$(echo $humidity1 "   | " $humidity2 )
echo "Umidita'          :" $hum
windspeed1=$(cat tempo1.json* | jq -r '.current.wind_kph')
windspeed2=$(cat tempo2.json | jq -r '.wind.speed')
windspeed=$(bc -l <<< "$windspeed2 * 3.6")
windsp=$(echo $windspeed1 " | " $windspeed )
echo "Vento (Velocita') :" $windsp
winddir1=$(cat tempo1.json* | jq -r '.current.wind_dir')
winddir2=$(cat tempo2.json | jq -r '.wind.deg')
echo "Vento (Direzione) :" $winddir1 "|" $winddir2 "°"
cielo1=$(cat tempo1.json* | jq -r '.current.condition.text')
cielo2=$(cat tempo2.json | jq -r '.weather[0].description')
echo "Cielo             :"  $cielo1 " | " $cielo2
copertura1=$(cat tempo1.json* | jq -r '.current.cloud')
copertura2=$(cat tempo2.json | jq -r '.clouds.all')
cop=$(echo $copertura1 " | " $copertura2)
echo "Copertura         :" $cop
