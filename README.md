# MDHSPicarmProject
Grade 12 Pic-Arm project for MD High School using PICAXE 20X2 Chip


A vertical servo motor connected to B.1 (pin 17) is controlled by the vertical potentiometer connected to C.1 (pin 9).  As the potentiometer is turned clockwise, ADC9 (analog to digital port 9) converts the reading from the potentiometer into a number, of which the internal pulse's time high is adjusted so that the servo motor's angle is rotated accordingly. The horizontal servo motor and potentiometer work the same, but in the horizontal dimension.

When the "start" push button connected to C.3 (pin 7) is pushed, the game sequence initiates.  The 7-segment display counts down from 9 to 0 as per its output pins: C.5, 4 and B.0 to 6 (pins 5,6 12-18).

If the "start" push button is pressed again during the countdown sequence, the counter is reset to 9 and continues to count down from 9 to 0. 

If the "Win" button is pressed during the countdown sequence, all movement of the arm is temporarily disabled and a victory tune plays.

If the countdown reaches 0, all movement of the arm is temporarily disabled and a lose tune will be played. 
