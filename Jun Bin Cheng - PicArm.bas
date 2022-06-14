
symbol varMode = b0
symbol varTimer = b1
symbol varVertPot = b2
symbol varHoriPot = b3

main:
	let dirsB = %11111111 ; Establish all "B" as outputs
	let dirsC = %00110000 ; Establish C.4 & C.5 as outputs, all other "C" as input
		
	varMode = 0      ; Set mode to practice mode, 0 = Practice mode, 1 = play
	varTimer = 0     ; For timeout and display, inc by 0.1s
	
	; Turn off all LED segments
	high B.0, B.3, B.4, B.5, B.6
	high C.4, C.5
	
	; ADC
	; vertical pot C.1 = ADC9
	; horizontal pot C.2 = ADC8
	; symbol varVertPot = b2
	; symbol varHortPot = b3
	;
	; readadc 9, varVertPot
	; readadc 8, varHortPot 
	
	adcsetup = %0000001100000000 ; ADC channel 8,9
	
	; Set ports for servo motors
	symbol vertServo = B.1
	symbol horiServo = B.2
	
	servo vertServo,75      ; Set first servo position
	servo horiServo,75      ; Set first servo position
	
big_loop:
	gosub prc_checkPushButton     ; Run subroutine to check push buttons, i.e: Start, Reset, Win
	gosub prc_moveServoMotor      ; Run subroutine to check POT inputs and rotate servo motors
	
	; Check mode
	if varMode = 1 then
		; Play mode
		gosub prc_displaySegment ; display 7-segment
		
		; Check if timeout
		if varTimer >= 101 then
			; Timeout
			gosub prc_Timeout   ; go to Timeout procedure 
			varMode = 0   ; Go back to practice mode
			varTimer = 0  ; Reset timer
		else
			; Did not time out, increment timer by 1 = 0.1s
			inc varTimer
		end if
	else
		; practice mode
		; Turn off 7-segment display
		high B.0, B.3, B.4, B.5, B.6
		high C.4, C.5
	end if

	pause  100 ; wait 0.1 second
	
	goto big_loop
	
;*********************************
; End of main 
;*********************************

;*********************************
; prc_checkPushButton
;
; Check if Win button pressed
; Check if start/reset button is pressed
;
;*********************************
prc_checkPushButton:

	; if win button pressed and playing then
	;     play win music
	;     varMode = 0 (back to practice mode)
	;     varTimer = 0 (reset timer)
	; end if (do nothing if in practice mode)
	;

	if pinC.6 = 1 and varMode = 1 then
		gosub prc_WinMusic
		let varMode = 0     ; back to practice mode
		let varTimer = 0    ; reset timer
	end if

	; if start button pressed then
	;	varMode = 1   (go to play)
	;     varTimer = 0  (reset timer)
	; end if

	if pinC.3=1 then
		let varMode = 1  ; go to play mode, don't care if we are already in play mode
		let varTimer = 0 ; reset timer
	end if

return
;*********************************
; prc_moveServoMotor
;
; read ADC
; calculate value for servo motor
; output servo motor value
;
; adc value: 0 to 255 (mid value = 128)
; servo motor value: 75 to 225 (mid value = 150)
;
; To map adc value to within the range of servo motor value
; Motor Value = (ADC Value / 2) + 86
;
; Motor (min value) = (0/2) + 86 = 86
; Motor (mid value) = (128/2) + 86 = 150
; Motor (max value) = (255/2) + 86 = 214
; 
;*********************************

prc_moveServoMotor:

	readadc 9, varVertPot      ; read adc9 as Vertical Pot
	readadc 8, varHoriPot      ; read adc8 as Hortical Pot
	
	; Pot to Servo calculation
	; Motor Value = (ADC Value / 2) + 86
	
	; vertical pot
	varVertPot = varVertPot / 2
	varVertPot = varVertPot + 86
	servopos vertServo, varVertPot    ; move vetical servo motor 
	
	; horizontal pot
	varHoriPot = varHoriPot / 2     
	varHoriPot = varHoriPot + 86
	servopos horiServo, varHoriPot    ; move horizontal servo motor 

return

;******************************************
; prc_Timeout
;
; procedure for timeout in play mode
;
; play Fail sound
; off LED
;
;*******************************************

prc_Timeout:
	sound B.7, ( 170, 100 )
	pause 200
	sound B.7, ( 170, 100 )
	pause 200
	sound B.7, ( 170, 100 )
	pause 200
	
	; off LED
	high B.0, B.3, B.4, B.5, B.6, B.7, C.4, C.5

return
;******************************************
; prc_DisplaySegment
;
; procedure for display the 7-segment
;
; varTimer inc by 1 (= 0.1s) in main program (big_loop)
;
; every 10 counts = 1s
; display updated every 10 counts
;
;*******************************************
prc_DisplaySegment:
	if varTimer >= 100 then
		; Display 0
		low B.0, B.3, B.4, B.5
		low C.4, C.5
		high B.6
	else if varTimer >= 90 then
		; Display 0
		low B.0, B.3, B.4, B.5
		low C.4, C.5
		high B.6
	else if varTimer >= 80 then
		; Display 1
		high B.0, B.3, B.4, B.5, B.6
		low C.4, C.5
	else if varTimer >= 70 then
		; Display 2
		low B.0, B.3, B.4, B.6
		low C.4
		high C.5
		high B.5
	else if varTimer >= 60 then
		; Display 3
		low B.0, B.3, B.6
		low C.4, C.5
		high B.4, B.5
	else if varTimer >= 50 then
		; Display 4
		low B.5, B.6
		low C.4, C.5
		high B.0, B.3, B.4
	else if varTimer >= 40 then
		; Display 5
		low B.0, B.3, B.5, B.6
		low C.5
		high B.4
		high C.4
	else if varTimer >= 30 then
		; Display 6
		low B.3, B.4, B.5, B.6 
		low C.5
		high B.0, C.4
	else if varTimer >= 20 then
		; Display 7
		low B.0 
		low C.4, C.5
		high B.3, B.4, B.5, B.6
	else if varTimer >= 10 then
		; Display 8
		low B.0, B.3, B.4, B.5, B.6
		low C.4, C.5
	else	; 0 to 9	
		; Display 9
		low B.0, B.5, B.6
		low C.4, C.5
		high B.3, B.4
	end if

return
;******************************************
; prc_WinMusic
;
; Procedure to play WIN music (The Entertainer by Scott Joplin)
;
;*******************************************
prc_WinMusic:
tune B.7, 6, ($72,$73,$74,$00,$74,$00,$74,$C0,$40,$42,$43,$44,$40,$42,$04,$7B,$02,$C0,$3C,$72,$73,$74,$00,$74,$00,$74,$C0,$7C,$79,$77,$76,$79,$40,$04,$42,$40,$79,$C2)
return