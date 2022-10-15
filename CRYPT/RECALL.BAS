CLS
FILES "*.gfx"
INPUT "Image file? ", file$

OPEN file$ FOR BINARY AS #1

askImage:
CLS : SCREEN 0: WIDTH 80, 25
INPUT "Recall what image? (1-256) ", img

IF img = 0 THEN END
img = img - 1

SCREEN 7

SEEK 1, img * 3 + 1
offset& = ASC(INPUT$(1, 1))
offset& = offset& * 65536
plus& = ASC(INPUT$(1, 1))
plus& = plus& * 256
offset& = offset& + plus&
offset& = offset& + ASC(INPUT$(1, 1))

SEEK 1, offset& + 1

gfxWidth = ASC(INPUT$(1, 1)) + ASC(INPUT$(1, 1)) * 256
gfxHeight = ASC(INPUT$(1, 1)) + ASC(INPUT$(1, 1)) * 256

unused$ = INPUT$(1, 1)

FOR y = 0 TO gfxHeight - 1
    FOR x = 0 TO gfxWidth - 1 STEP 2
        byte = ASC(INPUT$(1, 1))
        PSET (x, y), byte \ 16
        PSET (x + 1, y), byte AND 15
    NEXT x
NEXT y

DO: LOOP UNTIL INKEY$ <> ""

GOTO askImage

