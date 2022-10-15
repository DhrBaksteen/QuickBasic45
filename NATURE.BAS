DECLARE SUB wipe ()
DECLARE SUB testEnd ()
DECLARE SUB drawSegment (x!, y!, l!, a!)
DECLARE FUNCTION rad! (a!)

SCREEN 3: RANDOMIZE TIMER

CONST PI = 3.14159
CONST ANGLE = 30
CONST SCALE = .8

DO
    CLS

    x = 15 + INT(RND * 20)
    WHILE x < 720
        l = 10 + INT(RND * 5)
        y = 348 + l - INT(RND * 5)
    
        drawSegment x, y, l, 270
        x = x + 5 + INT(RND * 15)
    WEND

    x = 35 + INT(RND * 20)
    WHILE x < 720
        y = 358 - INT(RND * 20)
        l = 18 + INT(RND * 5)
    
        drawSegment x, y, l, 270
        x = x + 35 + INT(RND * 20)
    WEND

    x = 60 + INT(RND * 40)
    WHILE x < 720
        y = 300 - INT(RND * 20)
        l = 30 + INT(RND * 25)

        drawSegment x, y, l, 270
        x = x + 80 + INT(RND * 120)
    WEND


    t! = TIMER
    DO
        testEnd
    LOOP UNTIL TIMER > t! + 10

    wipe
LOOP

SUB drawSegment (x, y, l, a)

    testEnd

    aD = 10 + RND * 35
    sD = .5 + RND * .45

    x1 = x + COS(rad(a)) * l
    y1 = y + SIN(rad(a)) * l
    l1 = l * sD

    IF x1 >= 0 AND y1 >= 0 AND x1 < 720 AND y1 < 348 THEN
        LINE (x, y)-(x1, y1)
       
        IF l1 >= 5 THEN
            drawSegment x1, y1, l1, a + aD

            IF a >= 20 AND RND < .4 THEN
                drawSegment x1, y1, l1, a
            END IF

            drawSegment x1, y1, l1, a - aD
        END IF
    END IF

END SUB

FUNCTION rad (a)

    rad = a * (PI / 180)

END FUNCTION

SUB testEnd

    IF INKEY$ <> "" THEN
        SCREEN 0
        PRINT "More Nature Fractals for the Tulip Compact 2"
        PRINT "Maarten Janssen, 2022-03-31"
        END
    END IF

END SUB

SUB wipe

    SELECT CASE INT(RND * 4)
        CASE 0
            FOR i = 0 TO 720 STEP 20
                LINE (0, 0)-(i, 348), 0, BF
                testEnd
            NEXT i
        CASE 1
            FOR i = 720 TO 0 STEP -20
                LINE (720, 0)-(i, 348), 0, BF
                testEnd
            NEXT i
        CASE 2
            FOR i = 0 TO 350 STEP 10
                LINE (0, 0)-(719, i), 0, BF
                testEnd
            NEXT i
        CASE ELSE
            FOR i = 350 TO 0 STEP -10
                LINE (0, 350)-(719, i), 0, BF
                testEnd
            NEXT i
    END SELECT

END SUB


