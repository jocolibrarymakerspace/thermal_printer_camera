#This project is based on Phillip Burgess' "Instant Camera using Raspberry Pi and Thermal Printer".
#You can find his complete tutorial on Adafruit at https://learn.adafruit.com/instant-camera-using-raspberry-pi-and-thermal-printer?view=all
#You can find our tutorial for this project, including a laser-cut frame, at [insert URL].

#!/bin/bash

#We tell the Raspberry Pi on which pin the shutter button is connected
SHUTTER=16

# We get the GPIO pin states ready
gpio -g mode  $SHUTTER up

while :
do
	# The Raspberry Pi checks if the shutter button has been pressed
	if [ $(gpio -g read $SHUTTER) -eq 0 ]; then
		#Optional: uncomment the following line and add the path to a specific image file to print a header before your picture (see Instructable for example)
		#lp -d zj-58 filename.png 
		#The Raspberry Pi displays a preview picture and after 2 seconds, sends it to the printer.
		#Change the timeout value in milliseconds to change the preview time. 2000 = 2 seconds, 3000 = 3 seconds, etc.
		raspistill -br 50 --fullscreen --timeout 5000 -o - | lp
		sleep 1
		# Wait for user to release button before resuming
		while [ $(gpio -g read $SHUTTER) -eq 0 ]; do continue; done
	fi

done
