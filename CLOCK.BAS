DECLARE SUB drawBigTick (x!, y!, r!, a!)
DECLARE SUB drawHand (x!, y!, a!, l!, c!)
SCREEN 3

' When drawing a line around an angle with radius R then
' for the Y coordinate R = R * 0.64

CONST PI = 3.14159
CONST PI2 = PI * 2
CONST DEG = PI2 / 360
CONST DEG90 = -PI / 2
CONST SEG60 = PI2 / 60
CONST SEG12 = PI2 / 12

CIRCLE (360, 100), 110
CIRCLE (360, 100), 100

CIRCLE (360, 100), 115, 1, PI, 0
LINE (475, 100)-(495, 100)
LINE -(550, 190)
LINE -(175, 190)
LINE -(225, 100)
LINE -(245, 100)

CIRCLE (360, 105), 120, 1, PI, 0, .61
LINE (480, 105)-(490, 105)
LINE -(540, 185)
LINE -(185, 185)
LINE -(230, 105)
LINE -(240, 105)

PAINT (465, 100)
PAINT (485, 102)

FOR i = 0 TO PI2 STEP SEG12
    drawBigTick 360, 100, 94, i
NEXT i

FOR i = 0 TO PI2 STEP SEG60
    LINE (360 + COS(i) * 87, 100 + SIN(i) * 56)-(360 + COS(i) * 90, 100 + SIN(i) * 58)
NEXT i

DO
    so = ss
    hh = VAL(LEFT$(TIME$, 2)) MOD 12
    mm = VAL(MID$(TIME$, 4, 2))
    ss = VAL(RIGHT$(TIME$, 2))

    IF ss <> so THEN
        hao = ha: ha = DEG90 + (hh * SEG12) + ((mm / 60) * SEG12)
        mao = ma: ma = DEG90 + (mm * SEG60)
        sao = sa: sa = DEG90 + (ss * SEG60)

        LOCATE 13, 24: PRINT TIME$
        LOCATE 13, 49: PRINT DATE$
       
        LINE (360, 100)-(360 + COS(sao) * 80, 100 + SIN(sao) * 51), 0
        LINE (360, 100)-(360 + COS(sa) * 80, 100 + SIN(sa) * 51), 1
       
        IF ha <> hao THEN
            drawHand 360, 100, hao, 45, 0
        END IF
        drawHand 360, 100, ha, 45, 1
       
        IF ma <> mao THEN
            drawHand 360, 100, mao, 70, 0
        END IF
        drawHand 360, 100, ma, 70, 1
    END IF
LOOP UNTIL INKEY$ <> ""

SCREEN 0
PRINT "PC Clock for the Tulip Compact 2"
PRINT "Maarten Janssen, 2022-09-14"

SUB drawBigTick (x, y, r, a)

    r1 = r
    r1y = r * .64

    r2 = r - 10
    r2y = r2 * .64

    x1 = x + COS(a - DEG) * r1
    y1 = y + SIN(a - DEG) * r1y
    x2 = x + COS(a + DEG) * r1
    y2 = y + SIN(a + DEG) * r1y
    x3 = x + COS(a + DEG) * r2
    y3 = y + SIN(a + DEG) * r2y
    x4 = x + COS(a - DEG) * r2
    y4 = y + SIN(a - DEG) * r2y
    xp = x + COS(a) * (r - 2.5)
    yp = y + SIN(a) * (r - 2.5) * .64
  
    LINE (x1, y1)-(x2, y2)
    LINE -(x3, y3)
    LINE -(x4, y4)
    LINE -(x1, y1)
    PAINT (xp, yp)

END SUB

SUB drawHand (x, y, a, l, c)

    x1 = x + COS(a - DEG90) * 5
    y1 = y + SIN(a - DEG90) * 3
    x2 = x + COS(a) * l
    y2 = y + SIN(a) * (l * .64)
    x3 = x + COS(a + DEG90) * 5
    y3 = y + SIN(a + DEG90) * 3
    x4 = x + COS(a + PI) * 5
    y4 = y + SIN(a + PI) * 3
   
    LINE (x1, y1)-(x2, y2), c
    LINE -(x3, y3), c
    LINE -(x4, y4), c
    LINE -(x1, y1), c

END SUB

