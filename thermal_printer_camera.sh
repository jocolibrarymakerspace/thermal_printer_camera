#Welcome to the Black & Veatch MakerSpace's Thermal Printer Camera project!

#This project is based on Phillip Burgess' "Instant Camera using Raspberry Pi and Thermal Printer".
#You can find his complete tutorial on Adafruit at https://learn.adafruit.com/instant-camera-using-raspberry-pi-and-thermal-printer?view=all
#You can find our tutorial for this project, including a laser-cut frame, at https://www.instructables.com/Pi-Powered-Thermal-Printer-Camera-1/

#!/bin/bash

#We tell the Raspberry Pi on which pins the shutter and off buttons will be
SHUTTER=16
OFFPIN=26

# We get the GPIO pins states ready
gpio -g mode  $SHUTTER up
gpio -g mode  $OFFPIN up

clear
echo "Welcome to JCL's thermal printer camera!"
echo "Push the Big Button to take a picture! If there is a screen, you will see a preview so you can strike a pose!"
echo "Press CTRL+C on a keyboard to stop the picture-taking script"
echo "Connect PIN 26 to Ground to shut down the Raspberry Pi safely"
echo "Have fun!"

while :
do
	# The Raspberry Pi checks if the shutter button has been pressed
	if [ $(gpio -g read $SHUTTER) -eq 0 ]; then
		#Optional: uncomment the following line and add the path to a specific image file to print a header before your picture (see Instructable for example)
		#lp -d zj-58 filename.png 
		#The Raspberry Pi displays a preview picture and after 2 seconds, sends it to the printer.
		#Change the timeout value in milliseconds to change the preview time. 2000 = 2 seconds, 3000 = 3 seconds, etc.
		raspistill -ex auto -p 0,0,800,600 --timeout 4000 -o - | lp
		sleep 1
		# Wait for user to release button before resuming
		while [ $(gpio -g read $SHUTTER) -eq 0 ]; do continue; done
		echo "Picture taken!"
	fi
	
	#The Raspberry Pi checks if the shutdown pins are connected
	if [ $(gpio -g read $OFFPIN) -eq 0 ]; then
		#Waiting for the user to unground pins before continuing
		while [ $(gpio -g read $OFFPIN) -eq 0 ]; do continue; done
		echo "Alright, we are shutting down! See you next time!"
		sleep 5
		sudo shutdown now
	fi
done
