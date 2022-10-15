DECLARE SUB TakeAction ()
DECLARE SUB PlaceBets ()
DECLARE SUB DealCards ()
DECLARE SUB SetupScreen ()
DEFINT A-Z
DECLARE SUB LoadBMP (Data$, xSize%, ySize%, Top%, Left%)
DECLARE FUNCTION ColorFix% (Col%)
DECLARE SUB UpdateMouse (How%)
DECLARE SUB LoadMouse ()
DECLARE SUB MouseDriver (AX%, Bx%, Cx%, dx%, lb%, RB%, EX%)
DECLARE SUB Box (x%, y%, Length%, Height%, Shadow%)
DECLARE SUB Button (x%, y%, Length%, Height%, Caption$, Status%)
DECLARE SUB Text (x%, y%, Caption$)
DECLARE FUNCTION Bin$ (Dec%)
DECLARE SUB ProcBar (x%, y%, Length%, Height%, Position%)
DECLARE SUB Shuffle ()
DECLARE SUB Game ()
DECLARE SUB IncCard ()
DECLARE SUB DrawCard (Number, CardLeft, CardTop)
SCREEN 12: RANDOMIZE TIMER

DIM SHARED Cursor(437), CMask(437), CBack(437), MXNow, MYNow
DIM SHARED Cards(5, 52), ThisPack, ThisCard, BackPic
DIM SHARED Players, Name$(3), Money(3), Bet(3), Count(4), Status(3), Insurance(3), PlayerCards(4, 10)

CONST true = -1
CONST False = NOT true

BackPic = 1
ThisCard = 1: ThisPack = 1: Players = 3

MouseDriver 3, 0, 0, 0, 0, 0, 1
LoadMouse

SetupScreen
Shuffle
PlaceBets
DealCards
TakeAction
UpdateMouse 1
DO
    UpdateMouse 0
LOOP UNTIL INKEY$ <> ""



DATA 55,89,E5,8B,5E,0C,8B,07,50,8B,5E,0A,8B,07,50,8B
DATA 5E,08,8B,0F,8B,5E,06,8B,17,5B,58,1E,07,CD,33,53
DATA 8B,5E,0C,89,07,58,8B,5E,0A,89,07,8B,5E,08,89,0F
DATA 8B,5E,06,89,17,5D,CA,08,00

DATA 2,2,2,2,2,2,2,8,8,2,2,2,2,2,2,2,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,2,2,2,2,2,2,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,2,2,2,2,2,2,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,2,2,2,2,2,2,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,2,2,2,2,2,2,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,8,8,2,2,2,2,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,1,7,0,8,8,2,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,1,7,0,1,7,0,2,2,2
DATA 2,2,2,2,2,2,8,1,7,0,1,7,0,1,7,0,8,8,2
DATA 8,8,0,2,2,2,8,1,7,0,1,7,0,1,7,0,1,7,0
DATA 8,1,7,0,2,2,8,1,1,8,1,1,8,1,7,0,1,7,0
DATA 2,8,1,7,0,2,8,1,1,1,1,1,1,1,1,8,1,7,0
DATA 2,8,1,1,7,0,0,1,1,1,1,1,1,1,1,1,1,7,0
DATA 2,2,8,1,1,7,7,1,1,1,1,1,1,1,1,1,1,7,0
DATA 2,2,8,1,1,1,1,1,1,1,1,1,1,1,1,1,1,7,0
DATA 2,2,2,8,1,1,1,1,1,1,1,1,1,1,1,1,1,7,0
DATA 2,2,2,8,1,1,1,1,1,1,1,1,1,1,1,1,7,0,2
DATA 2,2,2,2,8,1,1,1,1,1,1,1,1,1,1,1,7,0,2
DATA 2,2,2,2,8,1,1,1,1,1,1,1,1,1,1,1,7,0,2
DATA 2,2,2,2,2,8,1,1,1,1,1,1,1,1,1,7,0,2,2
DATA 2,2,2,2,2,2,8,1,1,1,1,1,1,1,1,7,0,2,2
DATA 2,2,2,2,2,2,2,8,1,1,1,1,1,1,7,0,2,2,2
DATA 2,2,2,2,2,2,2,8,1,1,1,1,1,1,7,0,2,2,2

FUNCTION Bin$ (Dec)

    IF Dec >= 128 THEN Dec = Dec - 128: B$ = "1" ELSE B$ = "0"
    IF Dec >= 64 THEN Dec = Dec - 64: B$ = B$ + "1" ELSE B$ = B$ + "0"
    IF Dec >= 32 THEN Dec = Dec - 32: B$ = B$ + "1" ELSE B$ = B$ + "0"
    IF Dec >= 16 THEN Dec = Dec - 16: B$ = B$ + "1" ELSE B$ = B$ + "0"
    IF Dec >= 8 THEN Dec = Dec - 8: B$ = B$ + "1" ELSE B$ = B$ + "0"
    IF Dec >= 4 THEN Dec = Dec - 4: B$ = B$ + "1" ELSE B$ = B$ + "0"
    IF Dec >= 2 THEN Dec = Dec - 2: B$ = B$ + "1" ELSE B$ = B$ + "0"
    IF Dec >= 1 THEN Dec = Dec - 1: B$ = B$ + "1" ELSE B$ = B$ + "0"

    Bin$ = B$

END FUNCTION

SUB Box (x, y, Length, Height, Shadow)

    LINE (x, y)-(x + Length, y + Height), 3, BF
    LINE (x, y)-(x + Length, y + Height), 0, B
    LINE (x + 3, y + 3)-(x + Length - 3, y + Height - 3), 0, B
    LINE (x + 4, y + 4)-(x + Length - 4, y + Height - 4), 15, BF
    LINE (x + Length - 4, y + 5)-(x + Length - 4, y + Height - 4), 7, BF
    LINE (x + 5, y + Height - 4)-(x + Length - 4, y + Height - 4), 7, BF

    IF Shadow = true THEN
        IF ScreenMode = 2 THEN
            FOR yy = y + Height + 1 TO y + Height + 4 STEP 2
                LINE (x + 5, yy)-(x + Length + 5, yy), 0, , &H5555
                LINE (x + 5, yy + 1)-(x + Length + 5, yy + 1), 0, , &HAAAA
            NEXT yy
            FOR xx = Length + x + 1 TO x + Length + 5 STEP 2
                LINE (xx, y + 5)-(xx, y + Height), 0, , &H5555
                LINE (xx + 1, y + 5)-(xx + 1, y + Height), 0, , &HAAAA
            NEXT xx
        ELSE
            FOR xx = x + 5 TO x + Length + 5
                FOR yy = y + Height + 1 TO y + Height + 5
                    IF POINT(xx, yy) > 7 THEN
                        PSET (xx, yy), POINT(xx, yy) - 8
                    ELSE
                        PSET (xx, yy), 0
                    END IF
                NEXT yy
            NEXT xx
            FOR xx = Length + x + 1 TO x + Length + 5
                FOR yy = y + 5 TO y + Height
                    IF POINT(xx, yy) > 7 THEN
                        PSET (xx, yy), POINT(xx, yy) - 8
                    ELSE
                        PSET (xx, yy), 0
                    END IF
                NEXT yy
            NEXT xx
        END IF
    END IF

END SUB

SUB Button (x, y, Length, Height, Caption$, Status)

    LINE (x, y)-(x + Length, y + Height), 7, BF
    LINE (x, y)-(x + Length, y + Height), 0, B
    IF Status = False THEN
        LINE (x + 1, y + 1)-(x + Length - 1, y + 1), 15
        LINE (x + 1, y + 1)-(x + 1, y + Height - 1), 15
        IF ScreenMode = 2 THEN
            LINE (x + 1, y + Height - 1)-(x + Length - 1, y + Height - 1), 0
            LINE (x + Length - 1, y + 1)-(x + Length - 1, y + Height - 1), 0
        ELSE
            LINE (x + 1, y + Height - 1)-(x + Length - 1, y + Height - 1), 8
            LINE (x + Length - 1, y + 1)-(x + Length - 1, y + Height - 1), 8
        END IF
    ELSE
        LINE (x + 1, y + 1)-(x + Length - 1, y + Height - 1), 15, B
    END IF

    FOR i = 1 TO LEN(Caption$)
        IF MID$(Caption$, i, 1) <> "&" THEN
            Caption2$ = Caption2$ + MID$(Caption$, i, 1)
        ELSE
            Caption2$ = Caption2$ + "<U>" + MID$(Caption$, i + 1, 1) + "</U>"
            i = i + 1
        END IF
    NEXT i
    SELECT CASE l
        CASE 1 TO 3
            Fact = 9
        CASE ELSE
            Fact = 6
    END SELECT
    IF Status = true THEN x = x + 1: y = y + 1
    Text x + 7, y + 4, Caption2$

END SUB

FUNCTION ColorFix (Col)

    SELECT CASE Col
        CASE 1
            CFix = 4
        CASE 3
            CFix = 6
        CASE 4
            CFix = 1
        CASE 6
            CFix = 3
        CASE 7
            CFix = 8
        CASE 8
            CFix = 7
        CASE 9
            CFix = 12
        CASE 11
            CFix = 14
        CASE 12
            CFix = 9
        CASE 14
            CFix = 11
        CASE ELSE
            CFix = Col
    END SELECT

    IF ScreenMode = 2 AND CFix < 7 OR CFix = 8 THEN ColorFix = 0 ELSE ColorFix = CFix

END FUNCTION

SUB DealCards

    FOR i = 1 TO 2
        FOR j = 1 TO Players
            IF Players = 1 THEN
                DrawCard Cards(ThisPack, ThisCard), 237 + (i - 1) * 88, 250
            ELSE
                DrawCard Cards(ThisPack, ThisCard), (j - 1) * 212 + 25 + (i - 1) * 88, 250
            END IF
            IF Cards(ThisPack, ThisCard) = 1 OR Cards(ThisPack, ThisCard) = 14 OR Cards(ThisPack, ThisCard) = 27 OR Cards(ThisPack, ThisCard) = 40 THEN
                IF Count(j) + 11 <= 21 THEN Count(j) = Count(j) + 11 ELSE Count(j) = Count(j) + 1
            END IF
            IF Cards(ThisPack, ThisCard) = 11 OR Cards(ThisPack, ThisCard) = 24 OR Cards(ThisPack, ThisCard) = 37 OR Cards(ThisPack, ThisCard) = 50 THEN Count(j) = Count(j) + 10
            IF Cards(ThisPack, ThisCard) = 12 OR Cards(ThisPack, ThisCard) = 25 OR Cards(ThisPack, ThisCard) = 38 OR Cards(ThisPack, ThisCard) = 51 THEN Count(j) = Count(j) + 10
            IF Cards(ThisPack, ThisCard) = 13 OR Cards(ThisPack, ThisCard) = 26 OR Cards(ThisPack, ThisCard) = 39 OR Cards(ThisPack, ThisCard) = 52 THEN Count(j) = Count(j) + 10
            IF Cards(ThisPack, ThisCard) > 1 AND Cards(ThisPack, ThisCard) < 11 THEN Count(j) = Count(j) + Cards(ThisPack, ThisCard)
            IF Cards(ThisPack, ThisCard) > 14 AND Cards(ThisPack, ThisCard) < 24 THEN Count(j) = Count(j) + Cards(ThisPack, ThisCard) - 13
            IF Cards(ThisPack, ThisCard) > 27 AND Cards(ThisPack, ThisCard) < 37 THEN Count(j) = Count(j) + Cards(ThisPack, ThisCard) - 26
            IF Cards(ThisPack, ThisCard) > 40 AND Cards(ThisPack, ThisCard) < 50 THEN Count(j) = Count(j) + Cards(ThisPack, ThisCard) - 39
            IF Players = 1 THEN
                x = 254
            ELSE
                x = (j - 1) * 212 + 42
            END IF
            LINE (x, 210)-(x + 100, 220), 15, BF
            Text x, 210, "Count: " + LTRIM$(STR$(Count(j)))
            PlayerCards(j, i) = Cards(ThisPack, ThisCard)
            Time! = TIMER
            DO: LOOP UNTIL TIMER > (Time! + .25)
            IncCard
        NEXT j
    NEXT i

    FOR i = 1 TO 2
        IF i = 1 THEN
            DrawCard Cards(ThisPack, ThisCard), 420 + (i - 1) * 88, 10
        ELSE
            DrawCard 0, 420 + (i - 1) * 88, 10
        END IF
        IF Cards(ThisPack, ThisCard) = 1 OR Cards(ThisPack, ThisCard) = 14 OR Cards(ThisPack, ThisCard) = 27 OR Cards(ThisPack, ThisCard) = 40 THEN
            IF Count(Players + 1) + 11 <= 21 THEN Count(Players + 1) = Count(Players + 1) + 11 ELSE Count(Players + 1) = Count(Players + 1) + 1
            IF i = 1 THEN Insurance = true
        END IF
        IF Cards(ThisPack, ThisCard) = 11 OR Cards(ThisPack, ThisCard) = 24 OR Cards(ThisPack, ThisCard) = 37 OR Cards(ThisPack, ThisCard) = 50 THEN Count(Players + 1) = Count(Players + 1) + 10
        IF Cards(ThisPack, ThisCard) = 12 OR Cards(ThisPack, ThisCard) = 25 OR Cards(ThisPack, ThisCard) = 38 OR Cards(ThisPack, ThisCard) = 51 THEN Count(Players + 1) = Count(Players + 1) + 10
        IF Cards(ThisPack, ThisCard) = 13 OR Cards(ThisPack, ThisCard) = 26 OR Cards(ThisPack, ThisCard) = 39 OR Cards(ThisPack, ThisCard) = 52 THEN Count(Players + 1) = Count(Players + 1) + 10
        IF Cards(ThisPack, ThisCard) > 1 AND Cards(ThisPack, ThisCard) < 11 THEN Count(Players + 1) = Count(Players + 1) + Cards(ThisPack, ThisCard)
        IF Cards(ThisPack, ThisCard) > 14 AND Cards(ThisPack, ThisCard) < 24 THEN Count(Players + 1) = Count(Players + 1) + Cards(ThisPack, ThisCard) - 13
        IF Cards(ThisPack, ThisCard) > 27 AND Cards(ThisPack, ThisCard) < 37 THEN Count(Players + 1) = Count(Players + 1) + Cards(ThisPack, ThisCard) - 26
        IF Cards(ThisPack, ThisCard) > 40 AND Cards(ThisPack, ThisCard) < 50 THEN Count(Players + 1) = Count(Players + 1) + Cards(ThisPack, ThisCard) - 39
        PlayerCards(4, i) = Cards(ThisPack, ThisCard)
        Time! = TIMER
        DO: LOOP UNTIL TIMER > (Time! + .25)
    NEXT i

END SUB

SUB DrawCard (Number, CardLeft, CardTop)
   
    DIM Card(6818), Symbols(2820)

    IF Number > 0 THEN
        FOR i = 0 TO 6817: Card(i) = 15: NEXT i
    ELSE
        'FOR i = 0 TO 6817 STEP 2: Card(i) = 3: Card(i + 1) = 14: NEXT i
        OPEN "Deck.gfx" FOR BINARY AS #1
            SEEK 1, 46078 + (BackPic - 1) * 6815
            FOR i = 0 TO 6814
                Card(i) = ASC(INPUT$(1, 1))
            NEXT i
        CLOSE #1
    END IF

    FOR i = 0 TO 91
        Card(i * 71 + 142) = 0
        Card(i * 71 + 212) = 0
    NEXT i
    FOR i = 0 TO 66
        Card(i + 2) = 0
        Card(i + 6747) = 0
    NEXT i
    Card(72) = 0: Card(140) = 0: Card(6675) = 0: Card(6743) = 0
    Card(71) = 8: Card(141) = 8: Card(6674) = 9: Card(6744) = 9
    Card(0) = 9: Card(70) = 9: Card(6745) = 8: Card(6815) = 8
    Card(1) = 8: Card(69) = 8: Card(6746) = 9: Card(6814) = 9
   
    OPEN "Deck.gfx" FOR BINARY AS #1
        SEEK 1, 43258
        FOR y = 0 TO 29
            FOR x = 0 TO 93
                Byte = ASC(INPUT$(1, 1))
                Symbols(y * 94 + x) = Byte
            NEXT x
        NEXT y
        SELECT CASE Number
            CASE 1 TO 10
                FOR y = 6 TO 14
                    FOR x = 15 TO 23
                        Card(x + 1265 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4944 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                FOR y = 0 TO 14
                    FOR x = 0 TO 14
                        IF Number = 1 OR Number = 3 OR Number = 5 OR Number = 9 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 28 + (y + 41) * 71) = Symbols(y * 94 + x)
                        END IF
                        IF Number = 2 OR Number = 3 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 28 + (y + 10) * 71) = Symbols(y * 94 + x)
                            IF Symbols((y + 15) * 94 + x) <> 15 THEN Card(x + 28 + (y + 70) * 71) = Symbols((y + 15) * 94 + x)
                        END IF
                        IF Number > 3 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 15 + (y + 10) * 71) = Symbols(y * 94 + x)
                            IF Symbols((y + 15) * 94 + x) <> 15 THEN Card(x + 15 + (y + 70) * 71) = Symbols((y + 15) * 94 + x)
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 41 + (y + 10) * 71) = Symbols(y * 94 + x)
                            IF Symbols((y + 15) * 94 + x) <> 15 THEN Card(x + 41 + (y + 70) * 71) = Symbols((y + 15) * 94 + x)
                        END IF
                        IF Number > 5 AND Number < 9 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 15 + (y + 41) * 71) = Symbols(y * 94 + x)
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 41 + (y + 41) * 71) = Symbols(y * 94 + x)
                        END IF
                        IF Number = 9 OR Number = 10 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 15 + (y + 29) * 71) = Symbols(y * 94 + x)
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 41 + (y + 29) * 71) = Symbols(y * 94 + x)
                            IF Symbols((y + 15) * 94 + x) <> 15 THEN Card(x + 15 + (y + 49) * 71) = Symbols((y + 15) * 94 + x)
                            IF Symbols((y + 15) * 94 + x) <> 15 THEN Card(x + 41 + (y + 49) * 71) = Symbols((y + 15) * 94 + x)
                        END IF
                        IF Number = 7 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 28 + (y + 25) * 71) = Symbols(y * 94 + x)
                        END IF
                        IF Number = 8 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 28 + (y + 25) * 71) = Symbols(y * 94 + x)
                            IF Symbols((y + 15) * 94 + x) <> 15 THEN Card(x + 28 + (y + 54) * 71) = Symbols((y + 15) * 94 + x)
                        END IF
                        IF Number = 10 THEN
                            IF Symbols(y * 94 + x) <> 15 THEN Card(x + 28 + (y + 19) * 71) = Symbols(y * 94 + x)
                            IF Symbols((y + 15) * 94 + x) <> 15 THEN Card(x + 28 + (y + 60) * 71) = Symbols((y + 15) * 94 + x)
                        END IF
                    NEXT x
                NEXT y
            CASE 11
                FOR y = 6 TO 14
                    FOR x = 15 TO 23
                        Card(x + 1265 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4944 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 27825
                Length = 47
                Height = 74
            CASE 12
                FOR y = 6 TO 14
                    FOR x = 15 TO 23
                        Card(x + 1265 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4944 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 13913
                Length = 47
                Height = 74
            CASE 13
                FOR y = 6 TO 14
                    FOR x = 15 TO 23
                        Card(x + 1265 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4944 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 1
                Length = 47
                Height = 74
            CASE 14 TO 23
                FOR y = 4 TO 14
                    FOR x = 59 TO 69
                        Card(x + 1362 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4899 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                Number = Number - 13
                FOR y = 0 TO 14
                    FOR x = 0 TO 14
                        IF Number = 1 OR Number = 3 OR Number = 5 OR Number = 9 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 40) * 71) = Symbols(y * 94 + x + 44)
                        END IF
                        IF Number = 2 OR Number = 3 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 10) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols((y + 15) * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 44)
                        END IF
                        IF Number > 3 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 14 + (y + 10) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols((y + 15) * 94 + x + 44) <> 15 THEN Card(x + 14 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 44)
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 42 + (y + 10) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols((y + 15) * 94 + x + 44) <> 15 THEN Card(x + 42 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 44)
                        END IF
                        IF Number > 5 AND Number < 9 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 14 + (y + 40) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 42 + (y + 40) * 71) = Symbols(y * 94 + x + 44)
                        END IF
                        IF Number = 9 OR Number = 10 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 14 + (y + 28) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 42 + (y + 28) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols((y + 15) * 94 + x + 44) <> 15 THEN Card(x + 14 + (y + 50) * 71) = Symbols((y + 15) * 94 + x + 44)
                            IF Symbols((y + 15) * 94 + x + 44) <> 15 THEN Card(x + 42 + (y + 50) * 71) = Symbols((y + 15) * 94 + x + 44)
                        END IF
                        IF Number = 7 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 25) * 71) = Symbols(y * 94 + x + 44)
                        END IF
                        IF Number = 8 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 25) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols((y + 15) * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 56) * 71) = Symbols((y + 15) * 94 + x + 44)
                        END IF
                        IF Number = 10 THEN
                            IF Symbols(y * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 19) * 71) = Symbols(y * 94 + x + 44)
                            IF Symbols((y + 15) * 94 + x + 44) <> 15 THEN Card(x + 28 + (y + 60) * 71) = Symbols((y + 15) * 94 + x + 44)
                        END IF
                    NEXT x
                NEXT y
                Number = Number + 13
            CASE 24
                FOR y = 4 TO 14
                    FOR x = 59 TO 69
                        Card(x + 1362 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4899 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 31303
                Length = 47
                Height = 74
            CASE 25
                FOR y = 4 TO 14
                    FOR x = 59 TO 69
                        Card(x + 1362 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4899 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 17391
                Length = 47
                Height = 74
            CASE 26
                FOR y = 4 TO 14
                    FOR x = 59 TO 69
                        Card(x + 1362 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4899 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 3479
                Length = 47
                Height = 74
            CASE 27
                FOR y = 4 TO 14
                    FOR x = 70 TO 78
                        Card(x + 1352 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4960 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 41737
                Length = 39
                Height = 39
            CASE 28 TO 36
                FOR y = 4 TO 14
                    FOR x = 70 TO 78
                        Card(x + 1352 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4960 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                Number = Number - 26
                FOR y = 0 TO 14
                    FOR x = 0 TO 14
                        IF Number = 3 OR Number = 5 OR Number = 9 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 39) * 71) = Symbols(y * 94 + x + 79)
                        END IF
                        IF Number = 2 OR Number = 3 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 10) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 79)
                        END IF
                        IF Number > 3 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 15 + (y + 10) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 15 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 79)
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 41 + (y + 10) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 41 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 79)
                        END IF
                        IF Number > 5 AND Number < 9 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 15 + (y + 41) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 41 + (y + 41) * 71) = Symbols(y * 94 + x + 79)
                        END IF
                        IF Number = 9 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 15 + (y + 27) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 41 + (y + 27) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 15 + (y + 52) * 71) = Symbols((y + 15) * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 41 + (y + 52) * 71) = Symbols((y + 15) * 94 + x + 79)
                        END IF
                        IF Number = 10 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 15 + (y + 29) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 41 + (y + 29) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 15 + (y + 49) * 71) = Symbols((y + 15) * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 41 + (y + 49) * 71) = Symbols((y + 15) * 94 + x + 79)
                        END IF
                        IF Number = 7 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 25) * 71) = Symbols(y * 94 + x + 79)
                        END IF
                        IF Number = 8 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 25) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 57) * 71) = Symbols((y + 15) * 94 + x + 79)
                        END IF
                        IF Number = 10 THEN
                            IF Symbols(y * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 20) * 71) = Symbols(y * 94 + x + 79)
                            IF Symbols((y + 15) * 94 + x + 79) <> 15 THEN Card(x + 28 + (y + 59) * 71) = Symbols((y + 15) * 94 + x + 79)
                        END IF
                    NEXT x
                NEXT y
                Number = Number + 26
            CASE 37
                FOR y = 4 TO 14
                    FOR x = 70 TO 78
                        Card(x + 1352 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4960 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 34781
                Length = 47
                Height = 74
            CASE 38
                FOR y = 4 TO 14
                    FOR x = 70 TO 78
                        Card(x + 1352 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4960 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 20869
                Length = 47
                Height = 74
            CASE 39
                FOR y = 4 TO 14
                    FOR x = 70 TO 78
                        Card(x + 1352 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4960 + (y - 6) * 71) = Symbols((y + 11) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 6957
                Length = 47
                Height = 74
            CASE 40 TO 49
                FOR y = 6 TO 14
                    FOR x = 37 TO 43
                        Card(x + 1315 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4923 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                Number = Number - 39
                FOR y = 0 TO 14
                    FOR x = 0 TO 12
                        IF Number = 1 OR Number = 3 OR Number = 5 OR Number = 9 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 41) * 71) = Symbols(y * 94 + x + 24)
                        END IF
                        IF Number = 2 OR Number = 3 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 10) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols((y + 15) * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 24)
                        END IF
                        IF Number > 3 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 16 + (y + 10) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols((y + 15) * 94 + x + 24) <> 15 THEN Card(x + 16 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 24)
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 42 + (y + 10) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols((y + 15) * 94 + x + 24) <> 15 THEN Card(x + 42 + (y + 70) * 71) = Symbols((y + 15) * 94 + x + 24)
                        END IF
                        IF Number > 5 AND Number < 9 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 16 + (y + 41) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 42 + (y + 41) * 71) = Symbols(y * 94 + x + 24)
                        END IF
                        IF Number = 9 OR Number = 10 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 16 + (y + 29) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 42 + (y + 29) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols((y + 15) * 94 + x + 24) <> 15 THEN Card(x + 16 + (y + 49) * 71) = Symbols((y + 15) * 94 + x + 24)
                            IF Symbols((y + 15) * 94 + x + 24) <> 15 THEN Card(x + 42 + (y + 49) * 71) = Symbols((y + 15) * 94 + x + 24)
                        END IF
                        IF Number = 7 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 25) * 71) = Symbols(y * 94 + x + 24)
                        END IF
                        IF Number = 8 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 25) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols((y + 15) * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 54) * 71) = Symbols((y + 15) * 94 + x + 24)
                        END IF
                        IF Number = 10 THEN
                            IF Symbols(y * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 19) * 71) = Symbols(y * 94 + x + 24)
                            IF Symbols((y + 15) * 94 + x + 24) <> 15 THEN Card(x + 29 + (y + 60) * 71) = Symbols((y + 15) * 94 + x + 24)
                        END IF
                    NEXT x
                NEXT y
                Number = Number + 39
            CASE 50
                FOR y = 6 TO 14
                    FOR x = 37 TO 43
                        Card(x + 1315 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4923 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 38259
                Length = 47
                Height = 74
            CASE 51
                FOR y = 6 TO 14
                    FOR x = 37 TO 43
                        Card(x + 1315 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4923 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 24347
                Length = 47
                Height = 74
            CASE 52
                FOR y = 6 TO 14
                    FOR x = 37 TO 43
                        Card(x + 1315 + (y - 6) * 71) = Symbols(y * 94 + x)
                        Card(x + 4923 + (y - 6) * 71) = Symbols((y + 9) * 94 + x)
                    NEXT x
                NEXT y
                SEEK 1, 10435
                Length = 47
                Height = 74
            CASE ELSE
        END SELECT

        FOR y = 0 TO Height - 1
            FOR x = 0 TO Length - 1
                Byte = ASC(INPUT$(1, 1))
                yy = 48 - INT(Height / 2)
                xx = 35 - INT(Length / 2)
                Card((yy + y) * 71 + xx + x) = Byte
            NEXT x
        NEXT y
    CLOSE #1

    OPEN "Trebuch.fnt" FOR BINARY AS #1
        IF Number = 1 OR Number = 14 OR Number = 27 OR Number = 40 THEN Value$ = "A"
        IF Number = 11 OR Number = 24 OR Number = 37 OR Number = 50 THEN Value$ = "J"
        IF Number = 12 OR Number = 25 OR Number = 38 OR Number = 51 THEN Value$ = "Q"
        IF Number = 13 OR Number = 26 OR Number = 39 OR Number = 52 THEN Value$ = "K"
        IF Number > 1 AND Number < 11 THEN Value$ = LTRIM$(STR$(Number))
        IF Number > 14 AND Number < 24 THEN Value$ = LTRIM$(STR$(Number - 13))
        IF Number > 27 AND Number < 37 THEN Value$ = LTRIM$(STR$(Number - 26))
        IF Number > 40 AND Number < 50 THEN Value$ = LTRIM$(STR$(Number - 39))
        IF Number > 0 AND Number < 14 OR Number > 39 THEN c = 12 ELSE c = 0
        FOR i = 0 TO LEN(Value$) - 1
            SEEK #1, ASC(MID$(Value$, i + 1, 1)) * 9 + 2
            FOR y = 1 TO 8
                Byte = ASC(INPUT$(1, 1))
                FOR x = 1 TO 8
                    IF Byte >= 2 ^ (8 - x) THEN
                        Card((y * 2 + 1) * 71 + x + 2 + i * 4) = c
                        Card((y * 2 + 2) * 71 + x + 2 + i * 4) = c
                        Card((93 - y * 2) * 71 + 66 - x + 2 - i * 4) = c
                        Card((94 - y * 2) * 71 + 66 - x + 2 - i * 4) = c
                        Byte = Byte - 2 ^ (8 - x)
                    END IF
                NEXT x
            NEXT y
        NEXT i
    CLOSE #1
   
    FOR y = 0 TO 95
        FOR x = 0 TO 70
            PSET (x + CardLeft, y + CardTop), Card(x + y * 71)
        NEXT x
    NEXT y

END SUB

SUB FlashBorder (x, y, FlashColor)

    FOR i = 1 TO 3
        PAINT (x, y), FlashColor, 0
        Tijd! = TIMER
        DO: LOOP UNTIL TIMER > (Tijd! + .1)
        PAINT (x, y), 3, 0
        Tijd! = TIMER
        DO: LOOP UNTIL TIMER > (Tijd! + .1)
    NEXT i

END SUB

SUB Game

   
    IF Players > 1 THEN
        DrawCard Cards(ThisPack, ThisCard), 17, 250: IncCard
        DrawCard Cards(ThisPack, ThisCard), 106, 250: IncCard
        Box 20, 170, 150, 60, true
        Text 27, 177, "<B>" + Name$(1)
        Text 32, 190, "Money: " + Curr$ + LTRIM$(STR$(Money(1)))
        Text 32, 200, "Bet: " + Curr$ + LTRIM$(STR$(Bet(1)))
        Text 32, 210, "Count: " + LTRIM$(STR$(Count(1)))
    ELSE
        DrawCard Cards(ThisPack, ThisCard), 229, 250: IncCard
        DrawCard Cards(ThisPack, ThisCard), 318, 250: IncCard
        Button 237, 405, 25, 15, "&Hit", False
        Button 272, 405, 41, 15, "&Stand", False
        Button 237, 425, 77, 16, "&Double-down", False
        Button 322, 425, 65, 16, "Su&rrender", False
        Button 237, 445, 60, 16, "&Insurance", False
        Box 232, 190, 130, 60, true
        Text 239, 177, "<B>" + Name$(1)
        Text 244, 190, "Money: " + Curr$ + LTRIM$(STR$(Money(1)))
        Text 244, 200, "Bet: " + Curr$ + LTRIM$(STR$(Bet(1)))
        Text 244, 210, "Count: " + LTRIM$(STR$(Count(1)))
    END IF
    IF Players > 1 THEN
        DrawCard Cards(ThisPack, ThisCard), 229, 250: IncCard
        DrawCard Cards(ThisPack, ThisCard), 318, 250: IncCard
        Button 237, 405, 25, 15, "&Hit", False
        Button 272, 405, 41, 15, "&Stand", False
        Button 237, 425, 77, 16, "&Double-down", False
        Button 322, 425, 65, 16, "Su&rrender", False
        Button 237, 445, 60, 16, "&Insurance", False
        Box 232, 170, 150, 60, true
        Text 239, 177, "<B>" + Name$(2)
        Text 244, 190, "Money: " + Curr$ + LTRIM$(STR$(Money(2)))
        Text 244, 200, "Bet: " + Curr$ + LTRIM$(STR$(Bet(2)))
        Text 244, 210, "Count: " + LTRIM$(STR$(Count(2)))
    END IF
    IF Players = 3 THEN
        DrawCard Cards(ThisPack, ThisCard), 441, 250: IncCard
        DrawCard Cards(ThisPack, ThisCard), 530, 250: IncCard
        Button 449, 405, 25, 15, "&Hit", False
        Button 484, 405, 41, 15, "&Stand", False
        Button 449, 425, 77, 16, "&Double-down", False
        Button 534, 425, 65, 16, "Su&rrender", False
        Button 449, 445, 60, 16, "&Insurance", False
        Box 444, 170, 150, 60, true
        Text 451, 177, "<B>" + Name$(3)
        Text 456, 190, "Money: " + Curr$ + LTRIM$(STR$(Money(3)))
        Text 456, 200, "Bet: " + Curr$ + LTRIM$(STR$(Bet(3)))
        Text 456, 210, "Count: " + LTRIM$(STR$(Count(3)))
    END IF

    DrawCard 0, 390, 10: IncCard
    DrawCard Cards(ThisPack, ThisCard), 479, 10: IncCard
   
END SUB

SUB IncCard

    ThisCard = ThisCard + 1
    IF ThisCard = 53 THEN ThisPack = ThisPack + 1: ThisCard = 1
    IF ThisPack = 6 THEN Shuffle: ThisCard = 1: ThisPack = 1

END SUB

SUB LoadBMP (Data$, xSize, ySize, Top, Left)

    OPEN Data$ FOR BINARY AS #1
    table$ = INPUT$(54, #1)
    DIM table&(30)
    DEF SEG = VARSEG(table&(1))
    pointer% = VARPTR(table&(1))

    FOR x% = 0 TO 51
        POKE pointer% + x%, ASC(MID$(table$, x% + 3, 1))
    NEXT
    DEF SEG

    xSize = table&(5)
    ySize = table&(6)

    thecolors$ = INPUT$(table&(3) - 54, #1)
    DEF SEG = VARSEG(pal&)
    pointer% = VARPTR(pal&)
    DEF SEG
    y% = table&(6)
    DO
        Data$ = INPUT$((((table&(5) - 1) OR 7) + 1) \ 2, #1)
        IF (table&(5) \ 2) < LEN(Data$) THEN
            linelength% = table&(5) \ 2
        ELSE
            linelength% = LEN(Data$)
        END IF
        FOR x% = 1 TO linelength%
            pixel% = ASC(MID$(Data$, x%, 1))
            a = ColorFix(pixel% AND 15)
            B = ColorFix(pixel% \ 16)
            IF a <> 13 THEN PSET (x% * 2 + 1 + Left, y% + Top), a
            IF B <> 13 THEN PSET (x% * 2 + Left, y% + Top), B
        NEXT
        y% = y% - 1
    LOOP UNTIL EOF(1)
    CLOSE #1
   
END SUB

SUB LoadIcon (File$, x, y)

    OPEN File$ FOR BINARY AS #1
        SEEK 1, 127
        FOR yy% = 31 TO 0 STEP -1
            FOR xx% = 0 TO 31 STEP 2
                pixel% = ASC(INPUT$(1, 1))
                'PSET (xx% + 1 + x, yy% + y), ColorFix(pixel% AND 15)
                'PSET (xx% + x, yy% + y), ColorFix(pixel% \ 16)
            NEXT xx%
        NEXT yy%
    CLOSE #1

END SUB

SUB LoadMouse

    FOR y = 0 TO 22
        FOR x = 0 TO 18
            READ a
            IF a = 2 THEN
                PSET (x + 19, y), 15
            ELSE
                IF a = 1 THEN a = 15
                PSET (x, y), a
            END IF
        NEXT x
    NEXT y

    GET (0, 0)-(18, 21), Cursor
    GET (19, 0)-(37, 21), CMask

END SUB

SUB MouseDriver (AX%, Bx%, Cx%, dx%, lb%, RB%, EX%)

    IF EX% = 1 THEN
        RESTORE
        mouse$ = SPACE$(57)
        FOR i% = 1 TO 57
            READ a$
            h$ = CHR$(VAL("&H" + a$))
            MID$(mouse$, i%, 1) = h$
        NEXT i%
    END IF

    DEF SEG = VARSEG(mouse$)
    CALL Absolute(AX%, Bx%, Cx%, dx%, SADD(mouse$))
    lb% = ((Bx% AND 1) <> 0)
    RB% = ((Bx% AND 2) <> 0)

END SUB

SUB PlaceBets

    FOR i = 1 TO Players
        Bet$ = "": IF Bet(i) = 0 THEN Bet(i) = 5
        IF Players = 1 THEN
           x = 252
        ELSE
            x = (i - 1) * 212 + 40
        END IF
        LINE (x, 190)-(x + 103, 220), 15, BF
        Text x + 2, 190, "Place your bet"
        Text x + 2, 200, "$" + LTRIM$(STR$(Bet(i)))
        DO
            DO
                Key$ = INKEY$
            LOOP UNTIL Key$ <> ""
            SELECT CASE Key$
                CASE CHR$(13)
                    EXIT DO
                CASE ",", "."
                    IF Bet$ = "" THEN LINE (x + 8, 200)-(x + 130, 220), 15, BF
                    Bet$ = Bet$ + "."
                CASE CHR$(8)
                    Bet$ = ""
                    LINE (x + 8, 200)-(x + 130, 220), 15, BF
                CASE ELSE
                    IF ASC(LEFT$(Key$, 1)) > 47 AND ASC(LEFT$(Key$, 1)) < 58 THEN
                        IF Bet$ = "" THEN LINE (x + 8, 200)-(x + 130, 220), 15, BF
                        Bet$ = Bet$ + Key$
                    ELSE
                        SOUND 5000, .03
                    END IF
            END SELECT
            Text x + 8, 200, Bet$
        LOOP
        IF Bet$ = "" THEN Bet(i) = Bet(i) ELSE Bet(i) = VAL(Bet$)
        LINE (x, 190)-(x + 103, 220), 15, BF
        Text x + 2, 190, "Money: $" + Curr$ + LTRIM$(STR$(Money(i)))
        Text x + 2, 200, "Bet: $" + Curr$ + LTRIM$(STR$(Bet(i)))
        Text x + 2, 210, "Count: " + LTRIM$(STR$(Count(i)))
    NEXT i

END SUB

SUB ProcBar (x, y, Length, Height, Position)
   
    IF Position < 0 THEN Position = 0
    IF Position > 100 THEN Position = 100

    Procent = Position * (Length / 100)

    LINE (x + Procent + 1, y + 1)-(x + Length, y + Height - 1), 15, BF
    IF Procent > 0 THEN
        FOR i = y + 1 TO y + Height - 1 STEP 2
            LINE (x, i)-(x + Procent, i), 9, , &HAAAA
            LINE (x, i + 1)-(x + Procent, i + 1), 9, , &H5555
            LINE (x, i)-(x + Procent, i), 3, , &H5555
            LINE (x, i + 1)-(x + Procent, i + 1), 3, , &HAAAA
        NEXT i
    END IF
    LINE (x - 1, y)-(x + Length + 1, y + Height), 0, B

    Text x + (Length / 2) - 12, y + 5, "<B>" + STR$(Position) + "%"
   
END SUB

SUB SetupScreen

    FOR y = 0 TO 479 STEP 2
        LINE (0, y)-(640, y), 9, , &HAAAA
        LINE (0, y)-(640, y), 8, , &H5555
        LINE (0, y + 1)-(640, y + 1), 9, , &H5555
        LINE (0, y + 1)-(640, y + 1), 8, , &HAAAA
    NEXT y

    Curr$ = "Ÿ"
    Name$(1) = "Scrapyard": Name$(2) = "dsfhsdh": Name$(3) = "sdfgsd"
    Money(1) = 500

    LoadBMP "BJ.bmp", xSize, ySize, 20, 39

    FOR i = 1 TO Players
        IF Players = 1 THEN
           x = 252
        ELSE
            x = (i - 1) * 212 + 40
        END IF
        Box x - 12, 170, 150, 60, true
        Text x - 4, 177, "<B>" + Name$(i)
        Text x + 2, 190, "Money: $" + Curr$ + LTRIM$(STR$(Money(i)))
        Text x + 2, 200, "Bet: $" + Curr$ + LTRIM$(STR$(Bet(i)))
        Text x + 2, 210, "Count: " + LTRIM$(STR$(Count(i)))
    NEXT i


END SUB

SUB Shuffle

    Box 200, 100, 240, 50, true
    Text 208, 108, "Shuffeling the cards..."
    ProcBar 269, 122, 102, 18, 0
   
    FOR Pack = 1 TO 5
        FOR Card = 1 TO 52
            DO
                c = INT(RND * 52) + 1
                InUse = False
                FOR i = 1 TO 52
                    IF Cards(Pack, i) = c THEN InUse = true: EXIT FOR
                NEXT i
            LOOP UNTIL InUse = False
            Cards(Pack, Card) = c
            Proc! = Proc! + .39
            'ProcBar 269, 122, 102, 18, INT(Proc!)
            'SOUND INT(RND * 5000) + 2000, .03
        NEXT Card
    NEXT Pack

    FOR y = 100 TO 160 STEP 2
        LINE (200, y)-(450, y), 9, , &HAAAA
        LINE (200, y)-(450, y), 8, , &H5555
        LINE (200, y + 1)-(450, y + 1), 9, , &H5555
        LINE (200, y + 1)-(450, y + 1), 8, , &HAAAA
    NEXT y

END SUB

SUB TakeAction

    FOR i = 1 TO Players
        IF Players = 1 THEN
           x = 252
        ELSE
            x = (i - 1) * 212 + 40
        END IF
        Button x - 15, 405, 25, 15, "&Hit", False
        Button x + 20, 405, 41, 15, "&Stand", False
        Button x - 15, 425, 77, 16, "&Double-down", False
        Button x + 70, 425, 65, 16, "Su&rrender", False
        IF PlayerCards(4, 1) = 1 OR PlayerCards(4, 1) = 14 OR PlayerCards(4, 1) = 27 OR PlayerCards(4, 1) = 40 THEN
            Button x - 15, 445, 60, 16, "&Insurance", False
        END IF
    NEXT i

END SUB

SUB Text (x, y, Caption$)

    Homex = x - 8

    OPEN "Trebuch.fnt" FOR BINARY AS #1
        FOR i = 1 TO LEN(Caption$)
            IF MID$(Caption$, i, 1) = "<" THEN
               IF MID$(Caption$, i + 1, 1) = "/" THEN
                    SELECT CASE MID$(Caption$, i + 2, 1)
                        CASE "B"
                            Bold = False
                        CASE "I"
                            Italic = False
                        CASE "U"
                            Underline = False
                        CASE ELSE
                    END SELECT
                    i = i + 1
               ELSE
                    SELECT CASE MID$(Caption$, i + 1, 1)
                        CASE "B"
                            Bold = true
                        CASE "I"
                            Italic = true
                        CASE "U"
                            Underline = true
                        CASE ELSE
                    END SELECT
               END IF
               i = i + 3
            END IF
            IF MID$(Caption$, i, 1) = CHR$(13) THEN y = y + 10: x = Homex
            Letter = ASC(MID$(Caption$, i, 1))
            SEEK 1, Letter * 9 + 1
            Space = ASC(INPUT$(1, 1))
            FOR j = 1 TO 8
                Reeks$ = Bin$(ASC(INPUT$(1, 1)))
                FOR k = Space TO 1 STEP -1
                    IF MID$(Reeks$, k, 1) = "1" THEN
                        PSET (x + k - 1, y + j - 1), 0
                        IF Bold = true THEN PSET (x + k, y + j - 1), 0
                    END IF
                NEXT k
            NEXT j
            IF Underline = true THEN LINE (x, y + 8)-(x + Space - 1, y + 8), 0
            x = x + Space + 1
            IF Bold = true THEN x = x + 1
        NEXT i
    CLOSE #1

END SUB

SUB UpdateMouse (How)

    IF How = 0 THEN
        MouseDriver 3, AX, Bx, Cx, lb, RB, 1
        IF Bx > 620 THEN Bx = 620
        IF Cx > 456 THEN Cx = 456
        IF MXNow <> Bx OR MYNow <> Cx THEN
            PUT (MXNow, MYNow), CBack, PSET
            MXNow = Bx: MYNow = Cx
            IF MXNow > 620 THEN MXNow = 620
            IF MYNow > 456 THEN MYNow = 456
            GET (MXNow, MYNow)-(MXNow + 19, MYNow + 23), CBack
            PUT (MXNow, MYNow), CMask, AND
            PUT (MXNow, MYNow), Cursor
        END IF
    END IF

    IF How = 1 THEN
        MouseDriver 3, AX, Bx, Cx, lb, RB, 1
        MXNow = Bx: MYNow = Cx
        IF MXNow > 620 THEN MXNow = 620
        IF MYNow > 456 THEN MYNow = 456
        GET (MXNow, MYNow)-(MXNow + 19, MYNow + 23), CBack
        PUT (MXNow, MYNow), CMask, AND
        PUT (MXNow, MYNow), Cursor, XOR
    END IF

    IF How = 2 THEN
        PUT (MXNow, MYNow), CBack, PSET
    END IF

END SUB

