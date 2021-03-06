EESchema Schematic File Version 4
EELAYER 30 0
EELAYER END
$Descr A4 11693 8268
encoding utf-8
Sheet 1 1
Title "test"
Date "2020-11-05"
Rev "v1.1"
Comp "nerdyscout"
Comment1 ""
Comment2 ""
Comment3 ""
Comment4 ""
$EndDescr
$Comp
L Device:C C1
U 1 1 5FA45E53
P 2750 2750
F 0 "C1" V 2450 2775 50  0000 C CNN
F 1 "100nF" V 2550 2775 50  0000 C CNN
F 2 "Capacitor_SMD:C_1206_3216Metric" H 2788 2600 50  0001 C CNN
F 3 "~" H 2750 2750 50  0001 C CNN
F 4 "CL10B104JB8NNND" H 2750 2750 50  0001 C CNN "MPN"
	1    2750 2750
	1    0    0    -1  
$EndComp
$Comp
L Graphic:Logo_Open_Hardware_Small LOGO1
U 1 1 5FAEE719
P 10750 6875
F 0 "LOGO1" H 10750 7150 50  0001 C CNN
F 1 "Logo_Open_Hardware_Small" H 10750 6650 50  0001 C CNN
F 2 "Symbol:KiCad-Logo2_5mm_SilkScreen" H 10750 6875 50  0001 C CNN
F 3 "~" H 10750 6875 50  0001 C CNN
F 4 "-" H 10750 6875 50  0001 C CNN "MPN"
	1    10750 6875
	1    0    0    -1  
$EndComp
$Comp
L Regulator_Linear:TLV70233_SOT23-5 U1
U 1 1 5FFCCB8C
P 3500 2600
F 0 "U1" H 3500 2942 50  0000 C CNN
F 1 "TLV70233_SOT23-5" H 3500 2851 50  0000 C CNN
F 2 "Package_TO_SOT_SMD:SOT-23-5" H 3500 2925 50  0001 C CIN
F 3 "http://www.ti.com/lit/ds/symlink/tlv702.pdf" H 3500 2650 50  0001 C CNN
F 4 "TLV70233PDBVT" H 3500 2600 50  0001 C CNN "MPN"
	1    3500 2600
	1    0    0    -1  
$EndComp
$Comp
L Device:C C2
U 1 1 5FFD1BA2
P 4250 2750
F 0 "C2" V 3950 2775 50  0000 C CNN
F 1 "100nF" V 4050 2775 50  0000 C CNN
F 2 "Capacitor_SMD:C_1206_3216Metric" H 4288 2600 50  0001 C CNN
F 3 "~" H 4250 2750 50  0001 C CNN
F 4 "CL10B104JB8NNND" H 4250 2750 50  0001 C CNN "MPN"
	1    4250 2750
	-1   0    0    1   
$EndComp
Wire Wire Line
	2750 2600 2750 2500
Wire Wire Line
	2750 2500 3100 2500
Wire Wire Line
	3200 2600 3100 2600
Wire Wire Line
	3100 2600 3100 2500
Connection ~ 3100 2500
Wire Wire Line
	3100 2500 3200 2500
Wire Wire Line
	3800 2500 4250 2500
Wire Wire Line
	4250 2500 4250 2600
$Comp
L power:GND #PWR0101
U 1 1 5FFD5BC7
P 2750 3000
F 0 "#PWR0101" H 2750 2750 50  0001 C CNN
F 1 "GND" H 2755 2827 50  0000 C CNN
F 2 "" H 2750 3000 50  0001 C CNN
F 3 "" H 2750 3000 50  0001 C CNN
	1    2750 3000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0102
U 1 1 5FFD5EEA
P 3500 3000
F 0 "#PWR0102" H 3500 2750 50  0001 C CNN
F 1 "GND" H 3505 2827 50  0000 C CNN
F 2 "" H 3500 3000 50  0001 C CNN
F 3 "" H 3500 3000 50  0001 C CNN
	1    3500 3000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0103
U 1 1 5FFD614E
P 4250 3000
F 0 "#PWR0103" H 4250 2750 50  0001 C CNN
F 1 "GND" H 4255 2827 50  0000 C CNN
F 2 "" H 4250 3000 50  0001 C CNN
F 3 "" H 4250 3000 50  0001 C CNN
	1    4250 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 3000 4250 2900
Wire Wire Line
	3500 3000 3500 2900
Wire Wire Line
	2750 3000 2750 2900
$Comp
L power:PWR_FLAG #FLG0101
U 1 1 5FFD710C
P 2750 2400
F 0 "#FLG0101" H 2750 2475 50  0001 C CNN
F 1 "PWR_FLAG" H 2750 2573 50  0000 C CNN
F 2 "" H 2750 2400 50  0001 C CNN
F 3 "~" H 2750 2400 50  0001 C CNN
	1    2750 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	2750 2400 2750 2500
Connection ~ 2750 2500
$Comp
L power:PWR_FLAG #FLG0102
U 1 1 5FFD7706
P 3100 3000
F 0 "#FLG0102" H 3100 3075 50  0001 C CNN
F 1 "PWR_FLAG" H 3100 3173 50  0000 C CNN
F 2 "" H 3100 3000 50  0001 C CNN
F 3 "~" H 3100 3000 50  0001 C CNN
	1    3100 3000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0104
U 1 1 5FFD7962
P 3100 3000
F 0 "#PWR0104" H 3100 2750 50  0001 C CNN
F 1 "GND" H 3105 2827 50  0000 C CNN
F 2 "" H 3100 3000 50  0001 C CNN
F 3 "" H 3100 3000 50  0001 C CNN
	1    3100 3000
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0105
U 1 1 5FFD7CFF
P 4250 2400
F 0 "#PWR0105" H 4250 2250 50  0001 C CNN
F 1 "+3.3V" H 4265 2573 50  0000 C CNN
F 2 "" H 4250 2400 50  0001 C CNN
F 3 "" H 4250 2400 50  0001 C CNN
	1    4250 2400
	1    0    0    -1  
$EndComp
Wire Wire Line
	4250 2400 4250 2500
Connection ~ 4250 2500
$Comp
L Interface_USB:FT230XQ U2
U 1 1 5FFDA0AC
P 7850 3600
F 0 "U2" H 7350 4200 50  0000 C CNN
F 1 "FT230XQ" H 8250 3000 50  0000 C CNN
F 2 "Package_DFN_QFN:QFN-16-1EP_4x4mm_P0.65mm_EP2.1x2.1mm" H 9200 3000 50  0001 C CNN
F 3 "https://www.ftdichip.com/Support/Documents/DataSheets/ICs/DS_FT230X.pdf" H 7850 3600 50  0001 C CNN
F 4 "FT230XQ-R" H 7850 3600 50  0001 C CNN "MPN"
	1    7850 3600
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0106
U 1 1 5FFDB41D
P 7850 4500
F 0 "#PWR0106" H 7850 4250 50  0001 C CNN
F 1 "GND" H 7855 4327 50  0000 C CNN
F 2 "" H 7850 4500 50  0001 C CNN
F 3 "" H 7850 4500 50  0001 C CNN
	1    7850 4500
	1    0    0    -1  
$EndComp
Wire Wire Line
	7850 4500 7850 4400
Wire Wire Line
	7950 4300 7950 4400
Wire Wire Line
	7950 4400 7850 4400
Connection ~ 7850 4400
Wire Wire Line
	7850 4400 7850 4300
Wire Wire Line
	7850 4400 7750 4400
Wire Wire Line
	7750 4400 7750 4300
$Comp
L power:+3.3V #PWR0107
U 1 1 5FFDCADE
P 7750 2700
F 0 "#PWR0107" H 7750 2550 50  0001 C CNN
F 1 "+3.3V" H 7765 2873 50  0000 C CNN
F 2 "" H 7750 2700 50  0001 C CNN
F 3 "" H 7750 2700 50  0001 C CNN
	1    7750 2700
	1    0    0    -1  
$EndComp
Wire Wire Line
	7750 2700 7750 2750
Wire Wire Line
	7750 2750 7950 2750
Wire Wire Line
	7950 2750 7950 2900
Connection ~ 7750 2750
Wire Wire Line
	7750 2750 7750 2900
NoConn ~ 8550 4000
NoConn ~ 8550 3900
NoConn ~ 8550 3800
NoConn ~ 8550 3700
NoConn ~ 8550 3500
NoConn ~ 8550 3400
NoConn ~ 8550 3300
NoConn ~ 8550 3200
NoConn ~ 7150 3200
NoConn ~ 7150 3500
NoConn ~ 7150 3600
NoConn ~ 7150 3800
$Comp
L Device:R R1
U 1 1 5FFDF335
P 5000 2750
F 0 "R1" H 5070 2841 50  0000 L CNN
F 1 "R" H 5070 2750 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 4930 2750 50  0001 C CNN
F 3 "~" H 5000 2750 50  0001 C CNN
F 4 "var1" H 5070 2659 50  0000 L CNN "VARIANT"
	1    5000 2750
	1    0    0    -1  
$EndComp
$Comp
L Device:R R2
U 1 1 5FFDFF26
P 5500 2750
F 0 "R2" H 5570 2841 50  0000 L CNN
F 1 "R" H 5570 2750 50  0000 L CNN
F 2 "Resistor_SMD:R_0805_2012Metric" V 5430 2750 50  0001 C CNN
F 3 "~" H 5500 2750 50  0001 C CNN
F 4 "1" H 5500 2750 50  0001 C CNN "MPN"
F 5 "var2" H 5570 2659 50  0000 L CNN "VARIANT"
	1    5500 2750
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0108
U 1 1 5FFE09E2
P 5000 2400
F 0 "#PWR0108" H 5000 2250 50  0001 C CNN
F 1 "+3.3V" H 5015 2573 50  0000 C CNN
F 2 "" H 5000 2400 50  0001 C CNN
F 3 "" H 5000 2400 50  0001 C CNN
	1    5000 2400
	1    0    0    -1  
$EndComp
$Comp
L power:+3.3V #PWR0109
U 1 1 5FFE0D34
P 5500 2400
F 0 "#PWR0109" H 5500 2250 50  0001 C CNN
F 1 "+3.3V" H 5515 2573 50  0000 C CNN
F 2 "" H 5500 2400 50  0001 C CNN
F 3 "" H 5500 2400 50  0001 C CNN
	1    5500 2400
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0110
U 1 1 5FFE0FD2
P 5000 3000
F 0 "#PWR0110" H 5000 2750 50  0001 C CNN
F 1 "GND" H 5005 2827 50  0000 C CNN
F 2 "" H 5000 3000 50  0001 C CNN
F 3 "" H 5000 3000 50  0001 C CNN
	1    5000 3000
	1    0    0    -1  
$EndComp
$Comp
L power:GND #PWR0111
U 1 1 5FFE125B
P 5500 3000
F 0 "#PWR0111" H 5500 2750 50  0001 C CNN
F 1 "GND" H 5505 2827 50  0000 C CNN
F 2 "" H 5500 3000 50  0001 C CNN
F 3 "" H 5500 3000 50  0001 C CNN
	1    5500 3000
	1    0    0    -1  
$EndComp
Wire Wire Line
	5000 3000 5000 2900
Wire Wire Line
	5500 3000 5500 2900
Wire Wire Line
	5500 2600 5500 2400
Wire Wire Line
	5000 2600 5000 2400
$EndSCHEMATC
