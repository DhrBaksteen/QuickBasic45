DECLARE FUNCTION getOffset$ (nextOffset&)
DECLARE SUB writeBmpData (offset&)
DECLARE FUNCTION colorFix! (col!)
DECLARE FUNCTION checkBMP! ()
DECLARE FUNCTION getWidth! ()
DECLARE FUNCTION getHeight! ()
DECLARE FUNCTION seekNextImage! ()
DECLARE SUB newFile ()

DIM SHARED packFile$

CLS

INPUT "Pack file ", packFile$
IF packFile$ = "" THEN END
inputOutFile:
INPUT "BMP file to add to pack ", bmpFile$
IF bmpFile$ = "" THEN END
PRINT

OPEN packFile$ FOR BINARY AS #1

    newFile
    nextImage = seekNextImage
    nextOffset& = LOF(1)
    offset$ = getOffset$(nextOffset&)

    PRINT "Image number ="; nextImage
    PRINT "Image offset ="; LOF(1) + 1
   
    OPEN bmpFile$ FOR BINARY AS #2

    IF NOT checkBMP THEN
        PUT #1, nextImage * 3 + 1, offset$
        SEEK 1, LOF(1) + 1
        bmpWidth = getWidth
        bmpHeight = getHeight
        PRINT "Image size ="; bmpWidth; ","; bmpHeight
        PRINT "Writing... ";
        bmpWidth$ = CHR$(bmpWidth - (bmpWidth \ 256) * 256) + CHR$(bmpWidth \ 256)
        bmpHeight$ = CHR$(bmpHeight - (bmpHeight \ 256) * 256) + CHR$(bmpHeight \ 256)
        PUT #1, , bmpWidth$
        PUT #1, , bmpHeight$
        writeBmpData LOF(1) + 1
        PRINT "OK"
    ELSE
        PRINT "Could not add image to file"
    END IF

    CLOSE #2

CLOSE #1

PRINT
INPUT "Add another image? ", yn$
IF UCASE$(yn$) = "Y" THEN
    CLS
    GOTO inputOutFile
END IF

FUNCTION checkBMP

    SEEK 2, 1

    type$ = INPUT$(2, 2)
    IF type$ <> "BM" THEN
        PRINT bmpFile$ + " is not a valid BMP file!"
        bmpError = 1
    ELSE
        bmpError = 0
    END IF

    SEEK 2, 29

    bitCount = ASC(INPUT$(1, 2)) + ASC(INPUT$(1, 2)) * 256
    IF bitCount <> 4 THEN
        PRINT "Only 16 color (4bit) BMP files are supported!"
        bmpError = bmpError + 1
    ELSE
        bmpError = bmpError + 0
    END IF

    compression = ASC(INPUT$(1, 2))
    IF compression > 0 THEN
        PRINT "Compressed BMP file are not supported!"
        bmpError = bmpError + 1
    ELSE
        bmpError = bmpError + 0
    END IF

    checkBMP = bmpError
   
END FUNCTION

FUNCTION colorFix (col)

    colorFix = col

    SELECT CASE col
        CASE 4
            colorFix = 1
        CASE 6
            colorFix = 3
        CASE 1
            colorFix = 4
        CASE 3
            colorFix = 6
        CASE 8
            colorFix = 7
        CASE 7
            colorFix = 8
        CASE 12
            colorFix = 9
        CASE 14
            colorFix = 11
        CASE 9
            colorFix = 12
        CASE 11
            colorFix = 14
    END SELECT

END FUNCTION

FUNCTION getHeight

    SEEK 2, 23
    getHeight = ASC(INPUT$(1, 2)) + ASC(INPUT$(1, 2)) * 256

END FUNCTION

FUNCTION getOffset$ (nextOffset&)

    offset$ = CHR$(nextOffset& \ 65536)
    nextOffset& = nextOffset& - ((nextOffset& \ 65536) * 65536)
    offset$ = offset$ + CHR$(nextOffset& \ 256)
    nextOffset& = nextOffset& - ((nextOffset& \ 256) * 256)
    offset$ = offset$ + CHR$(nextOffset&)

    getOffset$ = offset$

END FUNCTION

FUNCTION getWidth

    SEEK 2, 19
    getWidth = ASC(INPUT$(1, 2)) + ASC(INPUT$(1, 2)) * 256

END FUNCTION

SUB newFile

    IF LOF(1) < 769 THEN
        out$ = STRING$(769, CHR$(0))
        PUT #1, 1, out$
        PRINT packFile$ + " created"
    ELSE
        PRINT "Packfile OK"
    END IF
   
END SUB

FUNCTION seekNextImage

    SEEK 1, 1

    FOR i = 0 TO 255
        offset& = ASC(INPUT$(1, 1)) + ASC(INPUT$(1, 1)) * 256 + ASC(INPUT$(1, 1)) * 65536
        IF offset& = 0 THEN EXIT FOR
    NEXT i

    seekNextImage = i

END FUNCTION

SUB writeBmpData (offset&)

    bmpWidth = getWidth
    bmpHeight = getHeight

    SEEK 1, offset&
   
    FOR i = 0 TO bmpHeight - 1
        FOR j = 0 TO bmpWidth / 2 - 1
            out$ = CHR$(0)
            PUT #1, , out$
        NEXT j
    NEXT i
  
    bmpOffset& = LOF(2) - bmpHeight * (bmpWidth / 2) + 1
    SEEK 2, bmpOffset&

    FOR y = bmpHeight - 1 TO 0 STEP -1
        FOR x = 0 TO bmpWidth / 2 - 1
            byte = ASC(INPUT$(1, 2))
            col1 = colorFix(byte \ 16)
            col2 = colorFix(byte AND 15)
            out$ = CHR$(col1 * 16 + col2)
            SEEK 1, offset& + y * (bmpWidth / 2) + x + 1
            PUT #1, , out$
        NEXT x
    NEXT y
   
END SUB

