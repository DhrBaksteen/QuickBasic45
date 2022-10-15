SCREEN 7

pi = 3.141593

a = .33

FOR i = 0 TO 10 STEP 2
    IF i = 10 THEN a = 320
    CIRCLE (150, 50), 40, 15, , , 1 + a
    CIRCLE (150, 50), 40, 15, , , i / 10
    a = a + a
NEXT i


FOR i = 0 TO pi * 2 STEP .05
    IF i < 4.1 OR i > 5.1 THEN
        x1 = COS(i) * 70 + 147
        x2 = COS(i + .1) * 70 + 147
        y1 = SIN(i) * 20 + 90 - x1 / 3.33
        y2 = SIN(i + .1) * 20 + 90 - x2 / 3.33
        LINE (x1 - 1, y1 - 1)-(x2 + 1, y2 + 1), 0, BF
    END IF
NEXT i

CIRCLE (210, 35), 10, 15
PAINT (210, 35), 15


FOR i = 0 TO pi * 2 STEP .05
    IF i < 4.1 OR i > 5.1 THEN
        x1 = COS(i) * 70 + 147
        x2 = COS(i + .1) * 70 + 147
        y1 = SIN(i) * 20 + 90 - x1 / 3.33
        y2 = SIN(i + .1) * 20 + 90 - x2 / 3.33
        LINE (x1, y1)-(x2, y2), 15
        LINE (x1 + 1, y1)-(x2 + 1, y2), 15
    END IF
NEXT i

y = 130
FOR i = 0 TO 5
    LINE (0, y)-(320, y), 15
    y = y * 1.1
NEXT i

FOR i = 0 TO 160
    LINE (160 + i * 10, 130)-(160 + i * 40, 200), 15
    LINE (160 - i * 10, 130)-(160 - i * 40, 200), 15
NEXT i
 
SLEEP

