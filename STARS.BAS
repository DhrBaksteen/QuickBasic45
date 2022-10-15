DECLARE SUB drawStar (i%)
DECLARE SUB createStar (i%)
DEFINT A-Z
DECLARE SUB init ()
DECLARE SUB drawStars ()
DECLARE SUB updateStars ()

SCREEN 7: RANDOMIZE TIMER

TYPE star
    x AS INTEGER
    y AS INTEGER
    c AS INTEGER
    l AS INTEGER
    t AS DOUBLE
    dt AS DOUBLE
END TYPE

DIM SHARED nStars
IF COMMAND$ <> "" THEN
    nStars = VAL(COMMAND$)
ELSE
    nStars = 50
END IF

DIM SHARED stars(nStars) AS star
DIM SHARED sprites(100, 7, 5)

init

WHILE INKEY$ = ""
    updateStars
WEND

SCREEN 0: WIDTH 80
PRINT "By Maarten Janssen 2020-06-08"

DATA 15,0,0,0,0
DATA 0,1,9,11,15
DATA 0,4,12,14,15
DATA 0,8,7,11,15
DATA 0,5,13,7,15
DATA 0,2,10,14,15
DATA 0,8,3,11,15

stars:
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,1,2,1,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0

DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,2,0,0,0,0,0
DATA 0,0,0,1,2,3,2,1,0,0,0
DATA 0,0,0,0,0,2,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0

DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,2,0,0,0,0,0
DATA 0,0,1,1,2,3,2,1,1,0,0
DATA 0,0,0,0,0,2,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0

DATA 0,0,0,0,0,0,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,1,0,2,0,1,0,0,0
DATA 0,0,0,0,2,3,2,0,0,0,0
DATA 0,1,1,2,3,4,3,2,1,1,0
DATA 0,0,0,0,2,3,2,0,0,0,0
DATA 0,0,0,1,0,2,0,1,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,0,0,0,0,0,0

DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,1,0,0,2,0,0,1,0,0
DATA 0,0,0,2,0,3,0,2,0,0,0
DATA 0,0,0,0,4,4,4,0,0,0,0
DATA 1,1,2,3,4,4,4,3,2,1,1
DATA 0,0,0,0,3,4,3,0,0,0,0
DATA 0,0,0,2,0,3,0,2,0,0,0
DATA 0,0,1,0,0,2,0,0,1,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0
DATA 0,0,0,0,0,1,0,0,0,0,0

SUB createStar (i)

    stars(i).x = INT(RND * 309)
    stars(i).y = INT(RND * 189)
    stars(i).c = INT(RND * 6) + 1
    stars(i).l = INT(RND * 9)
    stars(i).dt = RND * .1
    stars(i).t = TIMER + stars(i).dt

END SUB

SUB drawStar (i)

    l = stars(i).l
    IF l > 4 THEN l = 9 - stars(i).l
    PUT (stars(i).x, stars(i).y), sprites(0, stars(i).c, l), XOR

END SUB

SUB drawStars

    FOR i = 0 TO nStars - 1
        l = stars(i).l
        IF l > 4 THEN l = 9 - stars(i).l
        PUT (stars(i).x, stars(i).y), sprites(0, stars(i).c, l), XOR
    NEXT i

    PCOPY 1, 0

END SUB

SUB init

    SCREEN 7
    PRINT "One moment..."
    SCREEN , , 1, 0

    DIM pals(7, 5)
    FOR i = 0 TO 6
        FOR j = 0 TO 4
            READ c
            pals(i, j) = c
        NEXT j
    NEXT i

    FOR i = 0 TO 6
        RESTORE stars
        FOR j = 0 TO 54
            FOR k = 0 TO 10
                READ c
                PSET (i * 11 + k, j), pals(i, c)
            NEXT k
        NEXT j

        FOR j = 0 TO 4
            GET (i * 11, j * 11)-(i * 11 + 10, j * 11 + 10), sprites(0, i, j)
        NEXT j
    NEXT i

    SCREEN , , 0, 0: CLS

    FOR i = 0 TO nStars - 1
        createStar i
        drawStar i
    NEXT i
END SUB

SUB updateStars

    FOR i = 0 TO nStars - 1
        IF TIMER >= stars(i).t THEN
            drawStar i

            IF stars(i).l = 9 THEN
                createStar i
            ELSE
                stars(i).l = stars(i).l + 1
                stars(i).t = TIMER + stars(i).dt
            END IF

            drawStar i
        END IF
    NEXT i

END SUB

