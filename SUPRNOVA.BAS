DEFINT A-Z
DECLARE SUB delay (tDelay#, tStart#)
DECLARE SUB createSupernova (i)
DECLARE SUB updateSupernova (i)

TYPE Supernova
    x AS INTEGER
    y AS INTEGER
    x1 AS INTEGER
    x2 AS INTEGER
    y1 AS INTEGER
    y2 AS INTEGER
    life AS INTEGER
    stage AS INTEGER
    time AS DOUBLE
END TYPE

DIM SHARED nova(10) AS Supernova
DIM SHARED blips

IF LCASE$(COMMAND$) = "/?" THEN
    COLOR 7
    PRINT "SUPERNOVA a screen saver by Maarten Janssen in March 2020"
    PRINT
    PRINT "Options:"
    PRINT "  /blip - Play a random *blip* sound when a star explodes."
    PRINT
    END
ELSEIF LCASE$(COMMAND$) = "/blip" THEN
    blips = 1
END IF

CLS : RANDOMIZE TIMER

FOR i = 0 TO 49
    t# = TIMER

    x = INT(RND * 80) + 1
    y = INT(RND * 25) + 1
    c = INT(RND * 14) + 1
    LOCATE y, x: COLOR c: PRINT CHR$(249);

    delay .02#, t#
NEXT i

FOR i = 0 TO 9
    createSupernova i
NEXT i

t# = TIMER

DO
    FOR i = 0 TO 9
        updateSupernova i
    NEXT i
LOOP UNTIL INKEY$ <> ""

COLOR 7
CLS
PRINT "Bye bye."
PRINT

SUB createSupernova (i)
   
    nova(i).x = INT(RND * 80) + 1
    nova(i).y = INT(RND * 25) + 1
    nova(i).x1 = nova(i).x - 1
    nova(i).x2 = nova(i).x + 1
    nova(i).y1 = nova(i).y - 1
    nova(i).y2 = nova(i).y + 1
    nova(i).life = INT(RND * 20) + 8
    nova(i).stage = 0
    nova(i).time = TIMER + RND * 5
   
END SUB

DEFSNG A-Z
SUB delay (tDelay#, tStart#)

    tDelay# = tDelay# + tStart#

    DO
        IF INKEY$ <> "" THEN
            COLOR 7
            CLS
            PRINT "Bye bye."
            PRINT
            END
        END IF
    LOOP UNTIL TIMER > tDelay#

END SUB

DEFINT A-Z
SUB updateSupernova (i)

    IF TIMER > nova(i).time THEN
        SELECT CASE nova(i).stage
            CASE 0
                nova(i).stage = nova(i).stage + 1
                nova(i).time = nova(i).time + .2#

            CASE 1
                nova(i).stage = nova(i).stage + 1
                nova(i).time = nova(i).time + .1#

            CASE 2
                nova(i).stage = nova(i).stage + 1
                nova(i).time = nova(i).time + (RND * .5#) + .25#

            CASE 3
                c = INT(RND * 14) + 1
                LOCATE nova(i).y, nova(i).x: COLOR c: PRINT CHR$(249);
                nova(i).stage = nova(i).stage + 1
                nova(i).time = nova(i).time + .05#
                IF blips = 1 THEN
                    SELECT CASE INT(RND * 3)
                        CASE 0: PLAY "mbo5t200l64c>cb"
                        CASE 1: PLAY "mbo5t200l64e>fb"
                        CASE 2: PLAY "mbo6t200l64dgb"
                    END SELECT
                END IF

            CASE 4
                IF nova(i).life > 6 THEN
                    COLOR 15
                ELSEIF nova(i).life > 2 THEN
                    COLOR 7
                ELSE
                    COLOR 8
                END IF

                nova(i).life = nova(i).life - 1
                nova(i).time = nova(i).time + .05#
                d = 0


                IF nova(i).x1 > 0 THEN
                    LOCATE nova(i).y, nova(i).x1: PRINT " ";
                    nova(i).x1 = nova(i).x1 - 2
                    IF nova(i).life > 0 AND nova(i).x1 > 0 THEN
                        LOCATE nova(i).y, nova(i).x1: PRINT CHR$(249);
                    END IF
                ELSE
                    d = d + 1
                END IF

                IF nova(i).x2 < 81 THEN
                    LOCATE nova(i).y, nova(i).x2: PRINT " ";
                    nova(i).x2 = nova(i).x2 + 2
                    IF nova(i).life > 0 AND nova(i).x2 < 81 THEN
                        LOCATE nova(i).y, nova(i).x2: PRINT CHR$(249);
                    END IF
                ELSE
                    d = d + 1
                END IF

                IF nova(i).y1 > 0 THEN
                    LOCATE nova(i).y1, nova(i).x: PRINT " ";
                    nova(i).y1 = nova(i).y1 - 1
                    IF nova(i).life > 0 AND nova(i).y1 > 0 THEN
                        LOCATE nova(i).y1, nova(i).x: PRINT CHR$(249);
                    END IF
                ELSE
                    d = d + 1
                END IF

                IF nova(i).y2 < 26 THEN
                    LOCATE nova(i).y2, nova(i).x: PRINT " ";
                    nova(i).y2 = nova(i).y2 + 1
                    IF nova(i).life > 0 AND nova(i).y2 < 26 THEN
                        LOCATE nova(i).y2, nova(i).x: PRINT CHR$(249);
                    END IF
                ELSE
                    d = d + 1
                END IF

                IF nova(i).life = 0 OR d = 4 THEN
                    createSupernova i
                END IF
        END SELECT
    ELSE
        SELECT CASE nova(i).stage
            CASE 1
                LOCATE nova(i).y, nova(i).x: COLOR 15: PRINT CHR$(249);
            CASE 2
                LOCATE nova(i).y, nova(i).x: COLOR 15: PRINT "*";
            CASE 3
                LOCATE nova(i).y, nova(i).x: COLOR 15: PRINT CHR$(15);
            CASE 4
        END SELECT
    END IF

END SUB

