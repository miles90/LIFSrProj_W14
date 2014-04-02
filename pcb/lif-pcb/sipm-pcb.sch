EESchema Schematic File Version 2
LIBS:power
LIBS:device
LIBS:transistors
LIBS:conn
LIBS:linear
LIBS:regul
LIBS:74xx
LIBS:cmos4000
LIBS:adc-dac
LIBS:memory
LIBS:xilinx
LIBS:special
LIBS:microcontrollers
LIBS:dsp
LIBS:microchip
LIBS:analog_switches
LIBS:motorola
LIBS:texas
LIBS:intel
LIBS:audio
LIBS:interface
LIBS:digital-audio
LIBS:philips
LIBS:display
LIBS:cypress
LIBS:siliconi
LIBS:opto
LIBS:atmel
LIBS:contrib
LIBS:valves
LIBS:sma_edge
LIBS:sma
LIBS:sipm-pcb-cache
EELAYER 27 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "SiPM schematic"
Date "26 mar 2014"
Rev ""
Comp ""
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L +3.3V #PWR01
U 1 1 5331EDBC
P 4350 3250
F 0 "#PWR01" H 4350 3210 30  0001 C CNN
F 1 "+3.3V" H 4350 3360 30  0000 C CNN
F 2 "" H 4350 3250 60  0000 C CNN
F 3 "" H 4350 3250 60  0000 C CNN
	1    4350 3250
	1    0    0    -1  
$EndComp
$Comp
L GND #PWR02
U 1 1 5331EDCB
P 4250 5450
F 0 "#PWR02" H 4250 5450 30  0001 C CNN
F 1 "GND" H 4250 5380 30  0001 C CNN
F 2 "" H 4250 5450 60  0000 C CNN
F 3 "" H 4250 5450 60  0000 C CNN
	1    4250 5450
	1    0    0    -1  
$EndComp
$Comp
L R R3
U 1 1 5331EDEE
P 3900 4750
F 0 "R3" V 3980 4750 40  0000 C CNN
F 1 "R" V 3907 4751 40  0000 C CNN
F 2 "~" V 3830 4750 30  0000 C CNN
F 3 "~" H 3900 4750 30  0000 C CNN
	1    3900 4750
	1    0    0    -1  
$EndComp
$Comp
L SMA_EDGE SMA_E1
U 1 1 5331EE10
P 5500 3850
F 0 "SMA_E1" H 5650 4150 60  0000 C CNN
F 1 "SMA_EDGE" H 5650 4050 60  0000 C CNN
F 2 "" H 5500 3850 60  0000 C CNN
F 3 "" H 5500 3850 60  0000 C CNN
	1    5500 3850
	1    0    0    -1  
$EndComp
$Comp
L RVAR R4
U 1 1 5331EE6B
P 4350 4500
F 0 "R4" V 4430 4450 50  0000 C CNN
F 1 "RVAR" V 4270 4560 50  0000 C CNN
F 2 "~" H 4350 4500 60  0000 C CNN
F 3 "~" H 4350 4500 60  0000 C CNN
	1    4350 4500
	0    -1   -1   0   
$EndComp
$Comp
L C C1
U 1 1 5331EF60
P 3200 3200
F 0 "C1" H 3200 3300 40  0000 L CNN
F 1 "C" H 3206 3115 40  0000 L CNN
F 2 "~" H 3238 3050 30  0000 C CNN
F 3 "~" H 3200 3200 60  0000 C CNN
	1    3200 3200
	0    -1   -1   0   
$EndComp
$Comp
L R R2
U 1 1 5331EFAF
P 3500 4000
F 0 "R2" V 3580 4000 40  0000 C CNN
F 1 "R" V 3507 4001 40  0000 C CNN
F 2 "~" V 3430 4000 30  0000 C CNN
F 3 "~" H 3500 4000 30  0000 C CNN
	1    3500 4000
	1    0    0    -1  
$EndComp
$Comp
L R R1
U 1 1 5331F023
P 3500 2950
F 0 "R1" V 3580 2950 40  0000 C CNN
F 1 "R" V 3507 2951 40  0000 C CNN
F 2 "~" V 3430 2950 30  0000 C CNN
F 3 "~" H 3500 2950 30  0000 C CNN
	1    3500 2950
	1    0    0    -1  
$EndComp
$Comp
L +36V #PWR03
U 1 1 5331F032
P 3500 2600
F 0 "#PWR03" H 3500 2570 30  0001 C CNN
F 1 "+36V" H 3500 2710 40  0000 C CNN
F 2 "" H 3500 2600 60  0000 C CNN
F 3 "" H 3500 2600 60  0000 C CNN
	1    3500 2600
	1    0    0    -1  
$EndComp
$Comp
L PWR_FLAG #FLG04
U 1 1 5331F0DC
P 3400 2650
F 0 "#FLG04" H 3400 2745 30  0001 C CNN
F 1 "PWR_FLAG" H 3400 2830 30  0000 C CNN
F 2 "" H 3400 2650 60  0000 C CNN
F 3 "" H 3400 2650 60  0000 C CNN
	1    3400 2650
	0    -1   -1   0   
$EndComp
$Comp
L PWR_FLAG #FLG05
U 1 1 5331F131
P 4400 3350
F 0 "#FLG05" H 4400 3445 30  0001 C CNN
F 1 "PWR_FLAG" H 4400 3530 30  0000 C CNN
F 2 "" H 4400 3350 60  0000 C CNN
F 3 "" H 4400 3350 60  0000 C CNN
	1    4400 3350
	0    1    1    0   
$EndComp
$Comp
L PWR_FLAG #FLG06
U 1 1 5331F18A
P 4250 5000
F 0 "#FLG06" H 4250 5095 30  0001 C CNN
F 1 "PWR_FLAG" H 4250 5180 30  0000 C CNN
F 2 "" H 4250 5000 60  0000 C CNN
F 3 "" H 4250 5000 60  0000 C CNN
	1    4250 5000
	1    0    0    -1  
$EndComp
$Comp
L CONN_6 P1
U 1 1 5332165C
P 4450 2600
F 0 "P1" V 4400 2600 60  0000 C CNN
F 1 "CONN_6" V 4500 2600 60  0000 C CNN
F 2 "~" H 4450 2600 60  0000 C CNN
F 3 "~" H 4450 2600 60  0000 C CNN
	1    4450 2600
	1    0    0    -1  
$EndComp
$Comp
L LM358 U1
U 1 1 5331EDA1
P 4450 3850
F 0 "U1" H 4400 4050 60  0000 L CNN
F 1 "LM358" H 4400 3600 60  0000 L CNN
F 2 "" H 4450 3850 60  0000 C CNN
F 3 "" H 4450 3850 60  0000 C CNN
	1    4450 3850
	1    0    0    -1  
$EndComp
$Comp
L CONN_7 P2
U 1 1 5332170D
P 5300 2550
F 0 "P2" V 5270 2550 60  0000 C CNN
F 1 "CONN_7" V 5370 2550 60  0000 C CNN
F 2 "~" H 5300 2550 60  0000 C CNN
F 3 "~" H 5300 2550 60  0000 C CNN
	1    5300 2550
	1    0    0    -1  
$EndComp
Wire Wire Line
	4950 3850 5150 3850
Wire Wire Line
	4600 4500 4950 4500
Wire Wire Line
	4950 4500 4950 3850
Wire Wire Line
	4350 4250 4350 4300
Wire Wire Line
	4350 4300 4800 4300
Wire Wire Line
	4800 4300 4800 5050
Wire Wire Line
	4800 5050 4250 5050
Wire Wire Line
	4250 5000 4250 5450
Wire Wire Line
	4350 3450 4350 3250
Wire Wire Line
	4100 4500 3900 4500
Wire Wire Line
	3900 4500 3900 3950
Wire Wire Line
	3900 3950 3950 3950
Wire Wire Line
	3900 5000 3900 5150
Wire Wire Line
	3000 5150 4250 5150
Connection ~ 4250 5150
Wire Wire Line
	3000 3200 3000 5150
Connection ~ 3900 5150
Connection ~ 3500 3750
Wire Wire Line
	3500 4250 3500 5150
Connection ~ 3500 5150
Wire Wire Line
	3400 3200 4000 3200
Wire Wire Line
	3500 2600 3500 2700
Wire Wire Line
	4800 4800 5050 4800
Connection ~ 4800 4800
Wire Wire Line
	5150 3950 5150 4250
Wire Wire Line
	5050 4250 5900 4250
Connection ~ 5050 4250
Wire Wire Line
	3400 2650 3950 2650
Connection ~ 3500 2650
Wire Wire Line
	4350 3350 4400 3350
Connection ~ 4350 3350
Connection ~ 4250 5050
Wire Wire Line
	5150 3750 5150 3600
Wire Wire Line
	4900 3600 5900 3600
Wire Wire Line
	5900 3600 5900 4250
Connection ~ 5150 4250
Wire Wire Line
	5050 4800 5050 4250
Wire Wire Line
	3950 3750 3500 3750
Wire Wire Line
	3500 3750 3500 3350
Wire Wire Line
	3500 3350 4050 3350
Wire Wire Line
	4050 3350 4050 2750
Wire Wire Line
	4050 2750 4100 2750
Wire Wire Line
	4000 3200 4000 2650
Wire Wire Line
	4000 2650 4100 2650
Connection ~ 3500 3200
Wire Wire Line
	4100 2350 4100 2250
Wire Wire Line
	4100 2250 4850 2250
Wire Wire Line
	4850 2250 4850 2350
Wire Wire Line
	4850 2350 4950 2350
Wire Wire Line
	4100 2450 4050 2450
Wire Wire Line
	4050 2450 4050 2200
Wire Wire Line
	4050 2200 4800 2200
Wire Wire Line
	4800 2200 4800 2550
Wire Wire Line
	4800 2550 4950 2550
Wire Wire Line
	4100 2550 4000 2550
Wire Wire Line
	4000 2550 4000 2150
Wire Wire Line
	4000 2150 4750 2150
Wire Wire Line
	4750 2150 4750 2750
Wire Wire Line
	4750 2750 4950 2750
Wire Wire Line
	3950 2650 3950 2100
Wire Wire Line
	3950 2100 4950 2100
Wire Wire Line
	4950 2100 4950 2250
Wire Wire Line
	4100 2850 3900 2850
Wire Wire Line
	3900 2850 3900 2050
Wire Wire Line
	3900 2050 4700 2050
Wire Wire Line
	4700 2050 4700 2450
Wire Wire Line
	4700 2450 4950 2450
Wire Wire Line
	4950 2650 4900 2650
Wire Wire Line
	4900 2650 4900 3600
Connection ~ 5150 3600
Wire Wire Line
	4350 3350 4350 3300
Wire Wire Line
	4350 3300 4450 3300
Wire Wire Line
	4450 3300 4450 2950
Wire Wire Line
	4450 2950 4950 2950
Wire Wire Line
	4950 2950 4950 2850
$EndSCHEMATC
