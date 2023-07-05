10 DIM PN$(2): DIM HP(2): DIM PB(2): DIM PD(2)
20 DIM PW(2, 3): DIM PW$(2, 3): DIM PA(2, 3): DIM PU(2, 3)
30 DIM SN$(10): DIM SP(10): DIM SB(10)
40 RANDOMIZE TIMER
50 DEF FNRAND (N) = INT(RND * N) + 1
60 SN$(1) = "Sjeoe trowne ekcoe pionte"
70 SN$(2) = "Twywe klwozen anesye oncwye"
80 SN$(3) = "Anfdor ineowps kwobejinu wibli"
90 SN$(4) = "Qeuwn opnixr"
100 SN$(5) = "Iwo wendona sjeirj eijwn"
110 SN$(6) = "Misneb sberknev visbea"
120 SN$(7) = "Adnfieer unwowpex poriha yuvba"
130 SN$(8) = "Peownsei wnir a sdorg jazvir"
140 SN$(9) = "Kwonem uezrith moziuek"
150 SN$(10) = "Bwine zbirne inzeki"
160 REM Start game
170 CLS
180 PRINT "Player 1, enter your name:"
190 INPUT PN$(1)
200 PRINT "Player 2, enter your name:"
210 INPUT PN$(2)
220 CLS
230 PRINT "Welcome, " + PN$(1) + " and " + PN$(2) + "!"
240 PRINT
250 PRINT "You are standing in the middle of a forest clearing. It's a warm summer evening"
260 PRINT "and all you can hear is the sound of the wind throught the trees, crickets"
270 PRINT "chirping and the occasional bird in the distance. Tonight is the night you will"
280 PRINT "finally settle the petty argument the two of you had last year in the local"
290 PRINT "tavern to decide who would win in a battle!"
300 PRINT
310 PRINT
320 W = 1: GOSUB 3580
330 HP(1) = 100: PB(1) = 0: PD(1) = 1: PW(1, 1) = 1: PW$(1, 1) = WN$: PA(1, 1) = WA: PU(1, 1) = WU
340 HP(2) = 100: PB(2) = 0: PD(2) = 1: PW(2, 1) = 1: PW$(2, 1) = WN$: PA(2, 1) = WA: PU(2, 1) = WU
350 PW(1, 2) = 0: PW(1, 3) = 0: PW(2, 2) = 0: PW(2, 3) = 0
360 FOR I = 1 TO 10: SP(I) = FNRAND(10): NEXT I
370 T = FNRAND(2)
380 PRINT PN$(T) + " will attack first."
390 PRINT "Let the battle begin!"
400 GOSUB 3910
410 REM *** Battle! ***
420 CLS
430 F = 3 - T
440 PRINT PN$(T) + ", it's your turn."
450 PRINT
460 PRINT "Choose your weapon:"
470 FOR I = 1 TO 3
480 IF PW(T, I) > 0 THEN PRINT STR$(I) + ". " + PW$(T, I)
490 NEXT I
500 PRINT " 4. Search for a better weapon"
510 INPUT H
520 IF H = 4 THEN GOSUB 1010: GOTO 570
530 IF H < 1 OR H > 3 THEN PRINT : GOTO 460
540 IF PW(T, H) = 0 THEN PRINT : GOTO 460
550 W = PW(T, H): D = 1
560 IF W >= 12 THEN GOSUB 2700 ELSE GOSUB 810
570 IF HP(F) <= 0 THEN GOTO 680
580 IF HP(T) <= 0 THEN T = F: F = 3 - T: GOTO 680
590 PRINT
600 FOR I = 1 TO 2
610 PRINT PN$(I) + "'s health:"; HP(I)
620 NEXT I
630 IF PD(T) > 1 THEN PD(T) = PD(T) - 1
640 IF PD(T) < 1 THEN PD(T) = PD(T) + 1
650 T = F
660 GOSUB 3910
670 GOTO 410
680 PRINT
690 PRINT PN$(F) + " has been defeated!"
700 PRINT PN$(T) + " survives with"; HP(T); "HP."
710 PRINT
720 PRINT "Do you want a rematch, " + PN$(F) + "? [Y/n]"
730 INPUT Y$
740 IF Y$ = "N" OR Y$ = "n" THEN END
750 PRINT
760 PRINT "The sky lights up with a bright blue flash"
770 PRINT PN$(F) + " is resurrected!"
780 GOSUB 3910
790 CLS
800 GOTO 320
810 REM *** BATTLE ***
820 GOSUB 3580
830 PRINT
840 PRINT PN$(T) + " attacks " + PN$(F) + " with " + WN$ + "."
850 PU(T, H) = PU(T, H) - 1
860 IF FNRAND(100) <= WF THEN GOTO 1490
870 D = INT(PA(T, H)) + PB(T)
880 D1 = FNRAND(6)
890 IF FNRAND(100) >= WH THEN PRINT PN$(T) + " missed!": GOTO 980
900 IF PD(F) >= D1 THEN PRINT PN$(F) + " dodged!": GOTO 980
910 PA(T, H) = PA(T, H) - WD
920 GOSUB 2120
930 IF D = 0 THEN GOTO 980
940 IF FNRAND(100) <= WC THEN PRINT "Critical hit!": D = D * 2
950 IF PD(F) > 0 AND D1 = 6 THEN PRINT PN$(F) + " blocked!": D = INT(D / 2)
960 PRINT PN$(F); " takes"; D; "damage!"
970 HP(F) = HP(F) - D
980 IF PU(T, H) <= 0 OR PA(T, H) <= 0 THEN PW(T, H) = 0
990 GOSUB 2480
1000 RETURN
1010 REM *** SEARCH FOR WEAPON ***
1020 IF PW(T, 2) = 0 OR PW(T, 3) = 0 THEN GOTO 1130
1030 PRINT
1040 PRINT PN$(T) + "'s hands are full!"
1050 PRINT "Choose weapon to drop:"
1060 PRINT " 2. " + PW$(T, 2)
1070 PRINT " 3. " + PW$(T, 3)
1080 PRINT " 0. Nevermind"
1090 INPUT H
1100 IF H = 0 THEN RETURN
1110 IF H < 2 OR H > 3 THEN PRINT : GOTO 1050
1120 PW(T, H) = 0
1130 PRINT : PRINT PN$(T) + " searches their surroundings..."
1140 IF PD(T) > 3 OR FNRAND(100) > 15 THEN GOTO 1210
1150 Z = T: T = F: F = Z: D = 0
1160 H = FNRAND(3): W = PW(T, H)
1170 IF W = 0 OR W >= 12 THEN GOTO 1160
1180 PRINT : PRINT PN$(T) + " sneaks up on " + PN$(F) + "!"
1190 GOSUB 810
1200 Z = T: T = F: F = Z: D = 1
1210 W = FNRAND(14) + 1
1220 GOSUB 3580
1230 IF FNRAND(6) < WL THEN GOTO 1330
1240 PRINT
1250 PRINT PN$(T) + " found " + WN$ + "!"
1260 IF PW(T, 2) = 0 THEN H = 2 ELSE H = 3
1270 PW(T, H) = W
1280 PW$(T, H) = WN$
1290 PA(T, H) = WA + (WV - INT(WV / 2))
1300 PU(T, H) = WU
1310 GOSUB 1360
1320 RETURN
1330 PRINT
1340 PRINT PN$(T) + "'s search turns up empty."
1350 RETURN
1360 REM *** WEAPON FOUND ***
1370 IF W <> 7 THEN GOTO 1410
1380 PRINT "A tarnished sticker on the device reads: 'Property of D. Guy'."
1390 PRINT "'Well Mr. Guy, it's mine now!', " + PN$(T) + " smiles..."
1400 RETURN
1410 IF W <> 4 THEN GOTO 1440
1420 PRINT "'Better than nothing I guess...', " + PN$(T) + " mumbles..."
1430 RETURN
1440 IF W < 12 THEN GOTO 1480
1450 A = FNRAND(10)
1460 IF A = 1 THEN PRINT "I hope you know what you're doing..."
1470 IF A = 2 THEN PRINT "It looks interesting..."
1480 RETURN
1490 REM *** WEAPON FAILED ***
1500 D = 0
1510 IF W <> 8 THEN GOTO 1680
1520 IF FNRAND(10) < 4 THEN GOTO 1640
1530 PRINT "It would be immediatley obvious to anyone, except for " + PN$(T) + " perhaps,"
1540 PRINT "but this vicious dog is just a mere puppy!"
1550 PRINT "Full of enthousiasm it starts running toward " + PN$(F) + "."
1560 PRINT PN$(F) + " plays with the dog for a while..."
1570 PW(T, H) = 0: FH = 0
1580 IF PW(F, 3) = 0 THEN FH = 3
1590 IF PW(F, 2) = 0 THEN FH = 2
1600 IF FH = 0 OR FNRAND(10) > 3 THEN PRINT "The dog runs off.": RETURN
1610 PW(F, FH) = W: PW$(F, FH) = WN$: PA(F, FH) = WA + (WV - INT(WV / 2)): PU(F, FH) = WU
1620 PRINT "The dog decides to stay with " + PN$(F) + "."
1630 GOTO 2070
1640 PRINT "Maybe " + PN$(T) + " forgot to feed this sweet doggo,"
1650 PRINT "because it immediately bites " + PN$(T) + " in the leg and refuses to let go!"
1660 D = INT(PA(T, H)) + PB(T)
1670 GOTO 2070
1680 IF W <> 7 THEN 1740
1690 PRINT PN$(T) + " failed to notice that the cell pack of this BFG is badly damaged."
1700 PRINT "As " + PN$(T) + " squeezes the trigger the BFG starts to violently shake and make alarming noises until it explodes in a bright green flash!"
1710 PRINT PN$(T) + " is vaporized!"
1720 HP(T) = 0
1730 GOTO 2070
1740 IF W <> 5 THEN GOTO 1890
1750 IF FNRAND(10) < 4 THEN GOTO 1810
1760 PRINT PN$(T) + " tries to intimidate " + PN$(F) + " with a knife trick."
1770 PRINT "Alas, the dagger slips and cuts " + PN$(T) + " in the finger."
1780 PRINT PN$(F) + " is not impressed..."
1790 D = 1
1800 GOTO 2070
1810 PRINT PN$(T) + " makes a run-up to throw a dagger at " + PN$(F) + ", but stumbles on a loose rock. "
1820 IF FNRAND(10) < 2 THEN GOTO 1860
1830 PRINT PN$(T) + " hurts their knee in the fall."
1840 D = 2
1850 GOTO 2070
1860 PRINT "The dagger stabs " + PN$(T) + " in the back!"
1870 D = INT(PA(T, H)) + PB(T)
1880 GOTO 2070
1890 IF W <> 4 THEN GOTO 1930
1900 PRINT "It snaps before " + PN$(T) + " can even attack!"
1910 PW(T, H) = 0
1920 GOTO 2070
1930 IF W <> 2 THEN GOTO 1970
1940 PRINT "As " + PN$(T) + " lifts the wooden sword it breaks in two!"
1950 PW(T, H) = 0
1960 GOTO 2070
1970 IF W <> 6 THEN GOTO 2030
1980 PRINT PN$(T) + " makes a run-up and throws the stone with all the force in their body!"
1990 PRINT "It lands right in front of " + PN$(T) + "'s feet."
2000 PRINT PN$(F) + " laughs at " + PN$(T) + " uncontrolably!"
2010 PW(T, H) = 0
2020 GOTO 2070
2030 IF W <> 10 THEN GOTO 2070
2040 PRINT "By accident " + PN$(T) + " hits themselves on the thumb!"
2050 PRINT PN$(F) + " laughs at " + PN$(T) + "'s incompetence as they cry in pain."
2060 D = 2
2070 IF D = 0 THEN RETURN
2080 PRINT
2090 PRINT PN$(T) + " takes"; D; "damage!"
2100 HP(T) = HP(T) - D
2110 RETURN
2120 REM *** ATTACK HIT ***
2130 IF W <> 8 THEN GOTO 2270
2140 FH = 0
2150 IF PW(F, 2) = 11 THEN FH = 2
2160 IF PW(F, 3) = 11 THEN FH = 3
2170 IF FH = 0 THEN GOTO 2250
2180 PRINT "The dog is instantly attracted to the sausage in " + PN$(F) + "'s hand. With a big *chomp* the sausage is gone."
2190 PW(F, FH) = 0: D = 0
2200 IF FNRAND(10) > 3 THEN RETURN
2210 PW(T, H) = 0
2220 PW(F, FH) = W: PW$(F, FH) = WN$: PA(F, FH) = WA + (WV - INT(WV / 2)): PU(F, FH) = WU
2230 PRINT "The dog decides to stay with " + PN$(F) + "."
2240 RETURN
2250 PRINT "The dog charges toward " + PN$(F) + " with pure rage in its eyes!"
2260 RETURN
2270 IF W <> 7 THEN GOTO 2320
2280 PRINT PN$(T) + " squeezes the trigger of the BFG-9000..."
2290 PRINT "It starts to make a buzzing sound as it charges..."
2300 PRINT "A bright green beam of energy spreads across the battlefield!"
2310 RETURN
2320 IF W <> 6 THEN GOTO 2350
2330 PRINT "The stone flies through the air..."
2340 RETURN
2350 IF W <> 10 OR FNRAND(10) > 1 THEN GOTO 2390
2360 PRINT "The hammer head detatches from the handle and flies through the air..."
2370 WC = 100: D1 = 0: D = D + 5: PU(T, H) = 0
2380 RETURN
2390 IF W <> 9 THEN GOTO 2430
2400 PRINT "It's really heavy!"
2410 PA(T, 1) = PA(T, 1) + 1
2420 RETURN
2430 IF W <> 1 THEN GOTO 2470
2440 IF FNRAND(100) > 2 THEN GOTO 2470
2450 PRINT "An absolute rage takes a hold of " + PN$(T) + "!"
2460 D = 35
2470 RETURN
2480 REM *** ATTACK END ***
2490 DH = 0
2500 IF PW(T, 2) = 8 THEN DH = 2
2510 IF PW(T, 3) = 8 THEN DH = 3
2520 IF W <> 4 OR DH = 0 OR FNRAND(10) > 4 THEN GOTO 2570
2530 PRINT : PRINT "The dog is instantly attracted to the tree branch!"
2540 TW = W: TH = H: W = 8: H = DH
2550 GOSUB 810
2560 W = TW: H = TH
2570 IF W = 8 AND FNRAND(10) < 4 THEN PW(T, H) = 0
2580 IF PW(T, H) > 0 THEN RETURN
2590 IF W = 2 THEN PRINT : PRINT "The wooden sword is damaged beyond repair."
2600 IF W = 3 THEN PRINT : PRINT "The blade of the sword has become too blunt to use."
2610 IF W = 4 THEN PRINT : PRINT "The tree branch snaps in two."
2620 IF W = 5 THEN PRINT : PRINT "The dagger is lost."
2630 PW(T, H) = 0
2640 IF W = 7 THEN PRINT : PRINT "The cell pack of the BFG has depleated."; ""
2650 IF W = 8 THEN PRINT : PRINT "The dog runs off."
2660 IF W = 11 THEN PRINT : PRINT "The sausage has been reduced to minced meat."
2670 IF W = 10 THEN PRINT : PRINT "The hammer is no longer usable."
2680 IF W = 9 THEN PRINT : PRINT "The handle of the battle axe breaks."
2690 RETURN
2700 REM *** Spellbooks ***
2710 NS = FNRAND(4) + 1
2720 FOR I = 1 TO NS
2730 SB(I) = FNRAND(10)
2740 FOR J = 1 TO I - 1
2750 IF SB(I) = SB(J) THEN GOTO 2730
2760 NEXT J
2770 NEXT I
2780 PRINT
2790 PRINT "Clueless " + PN$(T) + " starts randomly flipping through the pages of the spellbook..."
2800 PRINT "What spell to utter?"
2810 FOR I = 1 TO NS
2820 PRINT STR$(I) + ". " + SN$(SB(I))
2830 NEXT I
2840 INPUT S
2850 PRINT
2860 IF S < 1 OR S > NS THEN GOTO 2800
2870 S = SP(SB(S))
2880 IF S > 1 THEN GOTO 2910
2890 PRINT "It seems to do nothing..."
2900 GOTO 3530
2910 IF S > 2 THEN GOTO 2970
2920 B = FNRAND(10)
2930 PB(T) = PB(T) + B
2940 PRINT PN$(T) + "'s eyes glow red!"
2950 PRINT "Attack strength is increased by"; B
2960 GOTO 3530
2970 IF S > 3 THEN GOTO 3030
2980 PRINT PN$(F) + " drops to the ground and screams in pain!"
2990 D = FNRAND(40)
3000 PRINT PN$(F); " takes"; D; "damage!"
3010 HP(F) = HP(F) - D
3020 GOTO 3530
3030 IF S > 4 THEN GOTO 3090
3040 A = FNRAND(20)
3050 HP(T) = HP(T) + A
3060 PRINT "A blue mist appears around " + PN$(T) + "..."
3070 PRINT PN$(T) + " receives"; A; "HP."
3080 GOTO 3530
3090 IF S > 5 THEN GOTO 3150
3100 A = FNRAND(20)
3110 HP(F) = HP(F) + A
3120 PRINT PN$(T) + " heals " + PN$(F) + " by"; A; "HP."
3130 PRINT PN$(F) + " grins at " + PN$(T) + ". 'You are too kind!'"
3140 GOTO 3530
3150 IF S > 6 THEN GOTO 3280
3160 IF PW(T, 2) <> 11 AND PW(T, 3) <> 11 THEN GOTO 3210
3170 IF PW(T, 2) = 11 THEN PA(T, 2) = 25
3180 IF PW(T, 3) = 11 THEN PA(T, 3) = 25
3190 PRINT PN$(T) + " is surrounded by a strong smell of salami!"
3200 GOTO 3530
3210 IF FNRAND(5) < 2 THEN GOTO 3250
3220 PA(T, 1) = PA(T, 1) * 2
3230 PRINT PN$(T) + "'s firts are shaking!"
3240 GOTO 3530
3250 PRINT "All of a sudden " + PN$(T) + "'s hands are empty!"
3260 PW(T, 2) = 0: PW(T, 3) = 0
3270 RETURN
3280 IF S > 7 THEN GOTO 3330
3290 PRINT "Poof!"
3300 PRINT "All weapons disappear from " + PN$(F) + "'s hands!"
3310 PW(F, 2) = 0: PW(F, 3) = 0
3320 GOTO 3530
3330 IF S > 8 THEN GOTO 3460
3340 PW(T, H) = 0
3345 Z = HP(1): HP(1) = HP(2): HP(2) = Z
3350 Z = PB(1): PB(1) = PB(2): PB(2) = Z
3360 FOR I = 1 TO 3
3370 Z = PW(1, I): PW(1, I) = PW(2, I): PW(2, I) = Z
3380 Z = PA(1, I): PA(1, I) = PA(2, I): PA(2, I) = Z
3390 Z = PU(1, I): PU(1, I) = PU(2, I): PU(2, I) = Z
3400 Z$ = PW$(1, I): PW$(1, I) = PW$(2, I): PW$(2, I) = Z$
3410 NEXT I
3420 PRINT "Lightning strikes!"
3430 PRINT PN$(T) + " and " + PN$(F) + " fall to the ground..."
3440 PRINT "When they wake up it seems " + PN$(T) + " and " + PN$(F) + " have switched bodies!"
3441 PRINT
3442 PRINT "The spellbook vanishes..."
3450 RETURN
3460 IF S > 9 THEN GOTO 3500
3470 A = FNRAND(2): PA(A, 1) = 1: PB(A) = 0
3480 PRINT PN$(A) + "'s hands go limp!"
3490 GOTO 3530
3500 PD(T) = 7: PD(F) = -2
3510 PRINT PN$(T) + " starts feeling dizzy as their vision turns blurry..."
3520 PRINT PN$(T) + " is now temporary invisible!"
3530 IF FNRAND(10) < 4 THEN RETURN
3540 PRINT
3550 PRINT "The spellbook vanishes..."
3560 PW(T, H) = 0
3570 RETURN
3580 REM *** GET WEAPON DATA ***
3590 RESTORE
3600 FOR I = 1 TO W - 1
3610 FOR J = 1 TO 8
3620 READ A
3630 NEXT J
3640 READ A$
3650 NEXT I
3660 READ WA
3670 READ WH
3680 READ WC
3690 READ WV
3700 READ WF
3710 READ WD
3720 READ WU
3730 READ WL
3740 READ WN$
3750 RETURN
3760 DATA 3,80,3,0,0,-0.5,100,0,"a Fist"
3770 DATA 10,70,10,4,10,2,6,1,"a Wooden Sword"
3780 DATA 15,40,7,4,0,1,4,3,"an Iron Sword"
3790 DATA 4,70,20,2,25,1,10,1,"a Tree Branch"
3800 DATA 10,70,30,6,20,1,4,2,"a Dagger"
3810 DATA 5,60,5,4,15,0,1,2,"a Stone"
3820 DATA 50,80,40,20,10,0,1,6,"a BFG-9000"
3830 DATA 12,80,20,6,40,0,3,3,"a Vicious Dog"
3840 DATA 15,50,10,4,0,1,5,4,"a Battle Axe"
3850 DATA 5,50,5,4,10,2,5,2,"an Old Hammer"
3860 DATA 2,80,80,0,0,3,5,2,"a Smoked Sausage"
3870 DATA 0,0,0,0,0,0,1,3,"a Blue Spellbook"
3880 DATA 0,0,0,0,0,0,1,3,"a Tranished Spellbook"
3890 DATA 0,0,0,0,0,0,1,3,"an Emerald Spellbook"
3900 DATA 0,0,0,0,0,0,1,3,"a Bloody Spellbook"
3910 PRINT : PRINT : PRINT "<PRESS A KEY>"
3920 K$ = INKEY$
3930 IF K$ <> "" THEN GOTO 3920
3940 K$ = INKEY$
3950 IF K$ = "" THEN GOTO 3940
3960 RETURN

