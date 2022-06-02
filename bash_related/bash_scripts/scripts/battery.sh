cap=$(cat /sys/class/power_supply/BAT0/capacity)
if [ $cap -gt 90 ]
then
  echo " $cap%  "
elif [ $cap -le 90 ] && [ $cap -ge 70 ]
then
  echo " $cap%  "
elif [ $cap -le 70 ] && [ $cap -ge 50 ]
then
  echo " $cap%  "
elif [ $cap -le 50 ] && [ $cap -ge 30 ]
then
  echo " $cap%  "
elif [ $cap -le 50 ] && [ $cap -ge 30 ]
then
  echo " $cap%  "
fi
