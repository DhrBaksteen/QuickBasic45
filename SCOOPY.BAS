DECLARE SUB startLevel ()
DECLARE SUB nextLevel ()
DECLARE SUB drawScoopy ()
DECLARE SUB removeAll ()
DECLARE SUB autoScoop ()
DECLARE SUB drawRubble ()
DECLARE SUB drawBoss ()
DECLARE SUB gameOver ()
DECLARE SUB soundFx (nr!)
DECLARE SUB title ()
DECLARE SUB background ()

SCREEN 7, , 1, 0
RANDOMIZE TIMER

DIM SHARED level, score, hiScore, gameEnded
DIM SHARED back(488)
DIM SHARED x, y, dir, hoekA, hoekB, hoekC, doScoop, scoopCount, scoop
DIM SHARED rubbleX(10), rubbleY(10), rubbleS(10)
DIM SHARED smokeX(3), smokeY(3), smokeS(3)
DIM SHARED smokeB1(5), smokeB2(5), smokeB3(5)
DIM SHARED bossX, bossY, bossF, bossS, bossD, bossT, bossB(250)
DIM SHARED river

CONST true = -1
CONST false = NOT true


DO
    title

    level = 1
    score = 0
    gameEnded = false
    startLevel
   
    DO
        drawScoopy
        IF bossS > 0 THEN drawBoss
        IF score > hiScore THEN hiScore = score
        LOCATE 25, 1: PRINT " Level:    Score:       Hi-Score:       ";
        LOCATE 25, 8: PRINT level;
        LOCATE 25, 18: PRINT score;
        LOCATE 25, 34: PRINT hiScore;

        PCOPY 1, 0
        removeAll

        key$ = UCASE$(INKEY$)
        IF key$ <> "" THEN
            SELECT CASE key$
                CASE CHR$(0) + "K"
                    IF x > 52 THEN x = x - 2: left = false
                    IF dir = 0 THEN x = x - 40
                    dir = 1
                CASE CHR$(0) + "M"
                    IF river = 20 AND x = 294 AND y > 155 AND y < 165 THEN nextLevel
                    IF x < 294 THEN x = x + 2: right = false
                    IF dir = 1 THEN x = x + 40
                    dir = 0
                CASE CHR$(0) + "P"
                    IF y < 174 THEN y = y + 2: down = false
                CASE CHR$(0) + "H"
                    IF y > 70 THEN y = y - 2: up = flase
                CASE CHR$(32)
                    doScoop = true
                CASE CHR$(27)
                    gameEnded = true
            END SELECT
        END IF

        IF doScoop THEN autoScoop

        WAIT &H3DA, 8
        WAIT &H3DA, 8, 8
    LOOP UNTIL gameEnded
LOOP


DATA mb,o3,ms,t160,>c16,<p4
DATA a16,p4,a16,a+8,a16,a+8
DATA >c16,<a8,g16,p3,>c16<
DATA p8,a16,p4,a16,a+8,a16
DATA a+8,a16,p2>,c16,<p4
DATA a16,p4,a16,a+8,a16,a+8
DATA >c16,<a8,g16,p3,>c16<
DATA p8,a16,p4,a16,a+8,a16
DATA p8,f16,p2,*

SUB autoScoop

    IF scoopCount = 0 THEN
        IF hoekB > 20 THEN hoekB = hoekB - 2
        IF hoekC > 0 THEN hoekC = hoekC - 2
        IF hoekB = 20 AND hoekC = 0 THEN scoopCount = 1
    END IF

    IF scoopCount = 1 THEN
        IF hoekA < 54 THEN hoekA = hoekA + 2
        IF hoekA > 40 AND hoekB < 50 THEN hoekB = hoekB + 2
        IF hoekB > 45 AND hoekC < 80 THEN hoekC = hoekC + 2
        IF hoekA = 54 AND hoekB = 50 AND hoekC = 6 THEN
            scoop = -1
            FOR i = 0 TO 9
                IF rubbleX(i) >= x - 29 AND rubbleX(i) <= x - 15 AND rubbleY(i) >= y + 10 AND rubbleY(i) <= y + 17 AND rubbleS(i) = 0 THEN
                    scoop = i
                    LINE (rubbleX(i), rubbleY(i))-(rubbleX(i) + 10, rubbleY(i) - 10), 2, BF
                    rubbleS(i) = 1
                    drawRubble
                    soundFx 1
                    i = 9
                END IF
            NEXT i
        END IF
        IF hoekA = 54 AND hoekB = 50 AND hoekC = 80 THEN scoopCount = 2
    END IF

    IF scoopCount = 2 THEN
        IF hoekA > 20 THEN hoekA = hoekA - 2
        IF hoekA = 20 AND hoekB = 50 AND hoekC = 80 THEN
            scoopCount = 3
            IF scoop = -1 THEN scoopCount = 0
            doScoop = false
        END IF
    END IF

    IF scoopCount = 3 THEN
        IF hoekA > -4 THEN hoekA = hoekA - 2
        IF hoekA < 10 AND hoekB > 20 THEN hoekB = hoekB - 2
        IF hoekB > 15 AND hoekC > -30 THEN hoekC = hoekC - 2
        IF hoekA = -4 AND hoekB = 20 AND hoekC = 40 AND scoop > -1 THEN
            IF x > 276 THEN
                river = river + 2
                LINE (270, 170)-(270 + river, 180), 7, BF
                score = score + 10
                soundFx 2
            ELSE
                soundFx 3
                rubbleX(scoop) = x - 18
                IF rubbleX(scoop) - dir * 10 > bossX - 12 AND rubbleX(scoop) - dir * 10 < bossX + 7 AND y - 10 < bossY AND y + 15 > bossY THEN
                    score = score + 25
                    soundFx 4
                    bossT = 750
                END IF
                IF dir = 1 THEN rubbleX(scoop) = rubbleX(scoop) - 10
                rubbleY(scoop) = y + 15
                rubbleS(scoop) = 0
                drawRubble
            END IF
            scoop = -1
        END IF
        IF hoekA = -4 AND hoekB = 20 AND hoekC = -30 THEN scoopCount = 4
    END IF

    IF scoopCount = 4 THEN
        IF hoekA < 6 THEN hoekA = hoekA + 2
        IF hoekB < 40 THEN hoekB = hoekB + 2
        IF hoekC < 64 THEN hoekC = hoekC + 2
        IF hoekA = 6 AND hoekB = 40 AND hoekC = 64 THEN
            scoopCount = 0
            doScoop = false
        END IF
    END IF

END SUB

SUB background

    LINE (0, 75)-(320, 200), 2, BF
    LINE (0, 0)-(320, 55), 1, BF
    LINE (0, 55)-(320, 70), 9, BF
    LINE (0, 70)-(320, 75), 11, BF
    LINE (0, 68)-(320, 68), 11
    LINE (0, 65)-(320, 65), 11
    LINE (0, 53)-(320, 53), 9
    LINE (0, 50)-(320, 50), 9

    CIRCLE (270, 20), 15, 14
    PAINT (270, 20), 14

    CIRCLE (70, 30), 50, 15, , , .1
    PAINT (70, 30), 15
    CIRCLE (70, 30), 50, 7, 3.5, 6.2, .1

    CIRCLE (120, 20), 30, 15, , , .1
    PAINT (120, 20), 15
    CIRCLE (120, 20), 30, 7, 3.5, 6.2, .1

    CIRCLE (220, 40), 70, 15, , , .05
    PAINT (220, 40), 15
    CIRCLE (220, 40), 70, 7, 3.5, 6.2, .05

END SUB

SUB drawBoss

    IF dir = 0 THEN p = 40 ELSE p = 0
    IF x - p > bossX THEN bossX = bossX + bossS: bossD = 0
    IF x - p < bossX THEN bossX = bossX - bossS: bossD = 1
    IF y > bossY THEN bossY = bossY + bossS
    IF y < bossY THEN bossY = bossY - bossS

    IF bossT = 0 AND x - p - 10 < bossX AND x - p + 10 > bossX AND y - 10 < bossY AND y + 10 > bossY THEN
        gameOver
    END IF
   
    IF bossT > 0 THEN
        bossT = bossT - 1
        IF bossT = 0 THEN
            bossX = 11: bossY = 120
            GET (bossX - 10, bossY)-(bossX + 10, bossY + 25), bossB
            soundFx 5
        END IF
    ELSE
        IF bossX MOD 1 = 0 OR bossY MOD 1 = 0 THEN
            GET (bossX - 10, bossY)-(bossX + 10, bossY + 25), bossB

            PSET (bossX, bossY)
            IF bossF < 10 THEN
                IF bossD = 0 THEN
                    DRAW "c14r2f1l4d1r6l6d1c12d4r4u2r1h1u1l4bf1p12,12d4r2d1c1r1d7l5u7r5g2bl1p1,1c0d4c12r1bd2c1l2f1d1g1d1r1u1e1u1r1u1d3f1d1r1u1h1u1d4c6r2bl6bu1h1f1r1"
                ELSE
                    DRAW "c14l2g1r4d1l6r6d1c12d4l4u2l1e1u1r4bg1p12,12d4l2d1c1l1d7r5u7l5f2br1p1,1c0d4c12l1bd2c1r2g1d1f1d1l1u1h1u1l1u1d3g1d1l1u1e1u1d4c6l2br6bu1e1g1l1"
                END IF
                bossF = bossF + 1
            ELSE
                IF bossD = 0 THEN
                    DRAW "c14r2f1l4d1r6l6d1c12d4r4u2r1h1u1l4bf1p12,12d4r2d1c1r1d7l5u7r5g2bl1p1,1c0f3r1c1u1f1c12g1bg2c1l3f1d4r1u4d5c6l1r2"
                ELSE
                    DRAW "c14l2g1r4d1l6r6d1c12d4l4u2l1e1u1r4bg1p12,12d4l2d1c1l1d7r5u7l5f2br1p1,1c0g3l1c1u1g1c12f1bf2c1r3g1d4l1u4d5c6r1l2"
                END IF
                bossF = bossF + 1
                IF bossF = 20 THEN bossF = 0
            END IF

            IF bossD = 0 THEN
                PSET (bossX + 2, bossY + 4), 0
            ELSE
                PSET (bossX - 2, bossY + 4), 0
            END IF
        END IF
    END IF

END SUB

SUB drawRubble

    FOR i = 0 TO 9
        IF rubbleS(i) = 0 THEN
            PSET (rubbleX(i), rubbleY(i))
            DRAW "c6r10u1l1h2l1g2u2h1l1d2g1br1p6,6br4p6,6"
        END IF
    NEXT i

END SUB

SUB drawScoopy

    IF x + 12 < 307 THEN
        GET (x - 51, y - 40)-(x + 12, y + 20), back
    ELSE
        GET (256, y - 40)-(319, y + 20), back
    END IF

    IF dir = 1 THEN
        PSET (x, y)
        DRAW "ta=" + VARPTR$(hoekA)
        DRAW "c8l1u7h12u1f12h12u1f14d7l1u7d7l1u7h12u1"
        b = hoekA + hoekB
        DRAW "ta=" + VARPTR$(b)
        DRAW "c8l1g1l12h1r14h1l12g1l1"
        c = b + hoekC
        DRAW "ta=" + VARPTR$(c)
        DRAW "c8u3h1l3g4d3u1r8u2bd1bl3bu2p8,8"
        PSET (x - 5, y - 3)
        DRAW "Ta0c14r7d7r8d5l15u11br2p14,14 c11r3d5g2l1u6br1p11,11 bd7br12c1l9r9bd2l7br8bu3c8e1u2l1d2bd7"
        DRAW "c8l17g1d2f1r17e1u2l1c7l2d2r2u2d1l2d1bl13l2u2r2d2u1l1"
    ELSE
        PSET (x - 39, y)
        a = -hoekA
        DRAW "ta=" + VARPTR$(a)
        DRAW "c8r1u7e12u1g12e12u1g14d7r1u7d7r1u7e12u1"
        b = a + -hoekB
        DRAW "ta=" + VARPTR$(b)
        DRAW "c8r1f1r12e1l14e1r12f1r1"
        c = b + -hoekC
        DRAW "ta=" + VARPTR$(c)
        DRAW "c8u3e1r3f4d3u1l8u2bd1br3bu2p8,8"
        PSET (x - 34, y - 3)
        DRAW "Ta0c14l7d7l8d5r15u11bl2p14,14 c11l3d5f2r1u6bl1p11,11 bd7bl12c1r9l9bd2r7bl8bu3c8h1u2r1d2bd7"
        DRAW "c8r17f1d2g1l17h1u2r1c7r2d2l2u2d1r2d1br13r2u2l2d2u1r1"
    END IF

    FOR i = 0 TO 2
        IF smokeS(i) = 0 THEN
            smokeS(i) = INT(RND * 10) + 5
            IF dir = 1 THEN
                smokeX(i) = x + 11
                smokeY(i) = y
            ELSE
                smokeX(i) = x - 51
                smokeY(i) = y
            END IF
        ELSE
            smokeY(i) = smokeY(i) - 1
            smokeS(i) = smokeS(i) - 1
        END IF
    NEXT i

    GET (smokeX(0), smokeY(0))-(smokeX(0) + 1, smokeY(0) + 1), smokeB1
    GET (smokeX(1), smokeY(1))-(smokeX(1) + 1, smokeY(1) + 1), smokeB2
    GET (smokeX(2), smokeY(2))-(smokeX(2) + 1, smokeY(2) + 1), smokeB3

    FOR i = 0 TO 2
        LINE (smokeX(i), smokeY(i))-(smokeX(i) + 1, smokeY(i) + 1), 7, BF
    NEXT i

END SUB

SUB gameOver

    SCREEN , , 0, 0
    PLAY "mbo3mst160>c16<p4a16p4a16a+8a16a+8>c16<a8gf16p8a16>p8f16"
    LOCATE 8, 15: COLOR 15, 0: PRINT "Game  Over"

    tijd! = TIMER
    DO: LOOP UNTIL TIMER > (tijd! + 5)

    gameEnded = true

END SUB

SUB nextLevel

    FOR x = 294 TO 350 STEP 1
        IF bossS > 0 THEN drawBoss
        drawScoopy
        PCOPY 1, 0
        LINE (230, 140)-(269, 185), 2, BF
        removeAll
    NEXT x

    PCOPY 1, 0
    PLAY "o3t160mbf16p32g16p32a16p32>c16p32f16"
    tijd! = TIMER
    DO: LOOP UNTIL TIMER > (tijd! + 3)

    level = level + 1
    startLevel

END SUB

SUB removeAll

    IF bossS > 0 AND bossT = 0 AND (bossX MOD 1 = 0 OR bossY MOD 1 = 0) THEN
        PUT (bossX - 10, bossY), bossB, PSET
    END IF

    PUT (smokeX(0), smokeY(0)), smokeB1, PSET
    PUT (smokeX(1), smokeY(1)), smokeB2, PSET
    PUT (smokeX(2), smokeY(2)), smokeB3, PSET

    IF x + 12 < 307 THEN
        PUT (x - 51, y - 40), back, PSET
    ELSE
        PUT (256, y - 40), back, PSET
    END IF

END SUB

SUB soundFx (nr)

    SELECT CASE nr
        CASE 1
            FOR i = 750 TO 2500 STEP 250
                SOUND i, .1
            NEXT i
        CASE 2
            FOR i = 2500 TO 750 STEP -250
                SOUND i, .1
            NEXT i
        CASE 3
            FOR i = 0 TO 49
                SOUND INT(RND * 2500) + 37, .03
            NEXT i
        CASE 4
            FOR i = 1000 TO 2500 STEP 50
                SOUND i, .1
                SOUND 3500 - i, .1
            NEXT i
        CASE 5
            FOR i = 0 TO 4
                SOUND 500, 1
                SOUND 2000, 1
            NEXT
        CASE ELSE
    END SELECT

END SUB

SUB startLevel

    x = 180: y = 100: dir = 0: scoop = -1
    bossX = 11: bossY = 120: bossT = 0
    hoekA = 0: hoekB = 20: hoekC = 0
    doScoop = false: scoopCount = 0

    SELECT CASE level
        CASE 1
            bossS = 0
        CASE 2, 3
            bossS = .1
        CASE 4, 5
            bossS = .2
        CASE 6, 7
            bossS = .3
        CASE 8
            bossS = .4
        CASE 9
            bossS = .5
        CASE 10
            bossS = .6
        CASE 11
            bossS = .7
        CASE 12
            bossS = .8
        CASE 13
            bossS = .9
        CASE ELSE
            bossS = 1
    END SELECT
   
    FOR i = 0 TO 9
        rubbleX(i) = INT(RND * 210) + 30
        rubbleY(i) = INT(RND * 80) + 100
        rubbleS(i) = 0
    NEXT i
    river = 0

    SCREEN , , 1, 0: CLS
    background
    LINE (270, 76)-(290, 200), 1, BF
   
    drawRubble

    DO: LOOP UNTIL INKEY$ = ""

END SUB

SUB title

    RESTORE

    SCREEN , , 1, 0: CLS
    background
    GOSUB drawLogo
    LOCATE 19, 15: COLOR 14, 2: PRINT "PRESS  SPACE"
    LOCATE 22, 2: COLOR 1, 2: PRINT "Programmed by Maarten Janssen"
    LOCATE 23, 2: PRINT "in QuickBASIC 4.5 :)"
    LOCATE 24, 2: PRINT "Copyright (c) 2005";
    PCOPY 1, 0

    tijd! = TIMER
    part = 0

    DO
        READ mus$
        IF mus$ = "*" THEN RESTORE: READ mus$
        PLAY mus$
        key$ = INKEY$
        IF key$ = CHR$(27) THEN
            COLOR 7, 0
            SCREEN 0
            WIDTH 80, 25
            SOUND 0, 0
            END
        END IF
        IF TIMER > tijd! + 8 THEN
            part = part + 1
            SELECT CASE part
                CASE 1
                    LOCATE 22, 2: COLOR 15, 2: PRINT "Today is a great day for construction"
                    LOCATE 23, 2:              PRINT "worker Dan! His boss Mr. Mack has    "
                    LOCATE 24, 2:              PRINT "bought a new excavator which Dan     ";
                CASE 2
                    LOCATE 22, 2: COLOR 15, 2: PRINT "thinks is a really cool toy!         "
                    LOCATE 23, 2:              PRINT "So he will try to steel it so he can "
                    LOCATE 24, 2:              PRINT "play with it at home...              ";
                CASE 2
                    LOCATE 22, 2: COLOR 15, 2: PRINT "Obviously Mr. Mack isn't too pleased "
                    LOCATE 23, 2:              PRINT "witht this so he will try to stop Dan"
                    LOCATE 24, 2:              PRINT "from steeling it.                    ";
                CASE 3
                    LOCATE 22, 2: COLOR 15, 2: PRINT "In order for Dan to escape his boss  "
                    LOCATE 23, 2:              PRINT "he has to get over the river on the  "
                    LOCATE 24, 2:              PRINT "right side of the construction yard. ";
                CASE 4
                    LOCATE 22, 2: COLOR 15, 2: PRINT "To do this he has to scoop up rubble "
                    LOCATE 23, 2:              PRINT "which is scattered all over the      "
                    LOCATE 24, 2:              PRINT "construction yard and drop it in the ";
                CASE 5
                    LOCATE 22, 2: COLOR 15, 2: PRINT "river to make a bridge for him to    "
                    LOCATE 23, 2:              PRINT "drive over. If Mr. Mack gets too     "
                    LOCATE 24, 2:              PRINT "close Dan can also choose to drop his";
                CASE 6
                    LOCATE 22, 2: COLOR 15, 2: PRINT "load on his boss to disable him for a"
                    LOCATE 23, 2:              PRINT "short while.                         "
                    LOCATE 24, 2: COLOR 11, 2: PRINT "                           Good Luck!";
                CASE 7
                    LOCATE 22, 2: COLOR 1, 2: PRINT "Programmed by Maarten Janssen        "
                    LOCATE 23, 2:             PRINT "in QuickBASIC 4.5 :)                 "
                    LOCATE 24, 2:             PRINT "Copyright (c) 2005                   ";
                CASE 8
                    part = 0
            END SELECT
            PCOPY 1, 0
            tijd! = TIMER
        END IF
    LOOP UNTIL key$ = CHR$(32)

    SOUND 0, 0
    COLOR 15, 0
    CLS

    EXIT SUB
   
drawLogo:
    s$ = "r20f10d10l10u5h5l10g5d10f30d20g10l20h10u10r10d5f5r10e5u10h30u20e9"
    c$ = "r20f10d10l10u5h5l10g5d55f5r10e5u5r10d10g10l20h10u65e10"
    o$ = "r20f10d65g10l20h10u65e10g10d5br10e5r10f5d55g5l10h5u55"
    p$ = "bl10d85r10u45r20e10u20h10l30r10bd10r15f5d10g5l15u20"
    y$ = "bl10d20f15d50r10u50e15u20l10d15g10h10u15l10"

    PSET (25, 50), 8
    DRAW s$
    PAINT (35, 55), 8
    PSET (20, 45), 15
    DRAW s$
    PAINT (30, 50), 7, 15

    PSET (75, 50), 8
    DRAW c$
    PAINT (75, 55), 8
    PSET (70, 45), 15
    DRAW c$
    PAINT (70, 50), 7, 15
                    
    PSET (125, 50), 8
    DRAW o$
    PAINT (125, 55), 8
    PSET (120, 45), 15
    DRAW o$
    PAINT (120, 50), 7, 15
   
    PSET (175, 50), 8
    DRAW o$
    PAINT (175, 55), 8
    PSET (170, 45), 15
    DRAW o$
    PAINT (170, 50), 7, 15
   
    PSET (225, 50), 8
    DRAW p$
    PAINT (225, 55), 8
    PSET (220, 45), 15
    DRAW p$
    PAINT (220, 50), 7, 15
   
    PSET (275, 50), 8
    DRAW y$
    PAINT (270, 55), 8
    PSET (270, 45), 15
    DRAW y$
    PAINT (265, 50), 7, 15
RETURN


END SUB

