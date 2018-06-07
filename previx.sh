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
# The way in which we can get passwords is to create a file that contain them
# structured in this way:
# key1 apixu
# key2 openweathermap
# the file must have the following name keys.txt
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
key1=$(cat keys.txt | cut -d' ' -f1 | head -1)
key2=$(cat keys.txt | cut -d' ' -f1 | tail -1)
wget "https://api.apixu.com/v1/current.json?key=$key1&q=$city" 2>/dev/null -O tempo1.json
wget "http://api.openweathermap.org/data/2.5/weather?q=$city,it&appid=$key2" 2>/dev/null -O tempo2.json
data=$(date -u)
echo "----------------------------------------------"
echo "Meteo>>" $city $(echo $data)
echo "----------------------------------------------"
echo -e "                 : APX \t\t|\t OWM "
echo "----------------------------------------------"
T1=$(cat tempo1.json* | jq -r '.current.temp_c')
T2=$(cat tempo2.json | jq -r '.main.temp')
T2=$(bc -l <<< "$T2 -273.15")
echo -e "Temperature (°C) :" $T1 "\t|\t" $T2
pressure1=$(cat tempo1.json* | jq -r '.current.pressure_mb')
pressure2=$(cat tempo2.json | jq -r '.main.pressure')
echo -e "Pressure (hPa)   :" $pressure1 "\t|\t" $pressure2
humidity1=$(cat tempo1.json* | jq -r '.current.humidity')
humidity2=$(cat tempo2.json | jq -r '.main.humidity')
echo -e "Umidity (%)      :" $humidity1 "\t\t|\t" $humidity2
windspeed1=$(cat tempo1.json* | jq -r '.current.wind_kph')
windspeed2=$(cat tempo2.json | jq -r '.wind.speed')
windspeed=$(bc -l <<< "$windspeed2 * 3.6")
echo -e "Wind speed (Km/h):" $windspeed1 "\t|\t" $windspeed
winddir1=$(cat tempo1.json* | jq -r '.current.wind_dir')
winddir2=$(cat tempo2.json | jq -r '.wind.deg')
echo -e "Wind (Direction) :" $winddir1 "\t\t|\t" $winddir2 "°"
copertura1=$(cat tempo1.json* | jq -r '.current.cloud')
copertura2=$(cat tempo2.json | jq -r '.clouds.all')
echo -e "Covered sky (%)  :" $copertura1 "\t\t|\t" $copertura2
cielo1=$(cat tempo1.json* | jq -r '.current.condition.text')
cielo2=$(cat tempo2.json | jq -r '.weather[0].description')
echo -e "Weather          :"  $cielo1 "/" $cielo2
