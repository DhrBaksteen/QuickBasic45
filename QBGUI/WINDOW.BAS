DEFINT A-Z

DECLARE FUNCTION Math.min (a, b)
DECLARE FUNCTION Math.max (a, b)

DECLARE FUNCTION QFont.loadFont$ (font$)
DECLARE SUB QFont.renderTextBox (fontPtr&, text$, x, y, w, h, c, alignment)
DECLARE SUB QFont.renderString (fontPtr&, text$, x, y, c)

DECLARE SUB Mouse.hide ()
DECLARE SUB Mouse.show ()
DECLARE SUB Mouse.setGraphicCursor (cur$)
DECLARE SUB Mouse.reset ()

DECLARE SUB drawBox (x, y, w, h, c1, c2, c3)
DECLARE SUB drawPatternBox (x, y, w, h, c1, c2, PatIndex)
DECLARE SUB drawShallowBox (x, y, w, h, c1, c2, c3)
DECLARE SUB drawShadowBox (x, y, w, h)
DECLARE SUB drawBmp (x, y, file$)
DECLARE SUB drawIcon (x, y, file$)
DECLARE SUB Gui.init ()
DECLARE SUB Gui.window (x, y, w, h, title$)
DECLARE SUB Gui.button (x, y, w, h, text$)
DECLARE SUB Gui.spinner (x, y, min, max, value)
DECLARE SUB Gui.hScroller (x, y, size, area, port, value)
DECLARE SUB Gui.vScroller (x, y, size, area, port, value)
DECLARE SUB Gui.progressBar (x, y, w, h, max, value)
DECLARE SUB Gui.checkBox (x, y, w, text$, checked)
DECLARE SUB Gui.panel (x, y, w, h, c)

DIM SHARED icons(32, 7)
DIM SHARED winPalette(16)
DIM SHARED fillPattern(18, 8)
DIM SHARED curDefault$
DIM SHARED pow2(8)
DIM SHARED font$, fontPtr&

SCREEN 12
Gui.init
drawPatternBox 0, 0, 640, 480, 11, 9, 4


Gui.window 35, 19, 223, 169, "This is a demo window"
Gui.button 44, 44, 22, 22, ""
Gui.button 68, 44, 22, 22, ""
Gui.button 92, 44, 22, 22, ""
Gui.progressBar 149, 56, 100, 10, 100, 30
drawBox 40, 70, 200, 100, 15, 8, 15
drawPatternBox 42, 72, 196, 96, 14, 15, 17
Gui.hScroller 40, 169, 200, 300, 200, 0
Gui.vScroller 239, 70, 100, 200, 100, 0
drawIcon 50, 80, "media\note.ico"
drawIcon 100, 80, "media\hardware.ico"
drawIcon 150, 80, "media\soundcrd.ico"
drawIcon 200, 80, "media\image2.ico"
drawIcon 50, 130, "media\pc02.ico"


Gui.window 350, 140, 220, 180, "Another window"
Gui.panel 360, 170, 200, 80, 7
Gui.checkBox 370, 180, 180, "Checkbox 1", 0
Gui.checkBox 370, 194, 180, "Checkbox 2", 1
Gui.checkBox 370, 208, 180, "Checkbox 3", 1
Gui.spinner 480, 260, 0, 100, 20


Gui.window 201, 221, 264, 112, "Welcome"
drawIcon 211, 250, "media\construc.ico"
QFont.renderTextBox fontPtr&, "This is a test version of the BOX UI in QuickBASIC 4.5. Things are still very much in development, so you can expect bugs here and there!", 258, 250, 188, 40, 0, 0
Gui.button 401, 300, 50, 20, "Close"


Mouse.show

DO: LOOP UNTIL INKEY$ = ""
DO: LOOP UNTIL INKEY$ <> ""

' Gui icons...
DATA &h00,&h18,&h3C,&h7E,&hFF,&h3C,&h3C,&h00
DATA &h00,&h3C,&h3C,&hFF,&h7E,&h3C,&h18,&h00
DATA &h08,&h18,&h3E,&h7E,&h7E,&h3E,&h18,&h08
DATA &h10,&h18,&h7C,&h7E,&h7E,&h7C,&h18,&h10
DATA &h3C,&h00,&h3C,&h3C,&hFF,&h7E,&h3C,&h18
DATA &h00,&h00,&h00,&h7E,&h7E,&h00,&h00,&h00
DATA &h00,&h18,&h18,&h7E,&h7E,&h18,&h18,&h00

' Windows 3.1 palette
DATA 0,4,2,6,1,5,3,8
DATA 7,12,10,14,9,13,11,15

' Patterns
DATA &h2020, &h0000, &h2020, &h5050, &hA8A8, &h5555, &hA8A8, &h5050
DATA &hB8B8, &h1111, &h8B8B, &hC7C7, &hA4A4, &h1111, &h3A3A, &h7C7C
DATA &h0000, &hFEFE, &hFEFE, &hC2C2, &hC2C2, &hC2C2, &hC2C2, &hFEFE
DATA &hEEEE, &h3131, &hF1F1, &hF1F1, &hEEEE, &h1313, &h1F1F, &h1F1F
DATA &h6060, &h6363, &h1B1B, &h1818, &h8181, &hB1B1, &h3636, &h0606
DATA &h0101, &h8282, &h7C7C, &h1010, &h1010, &h2828, &hC7C7, &h0101
DATA &h0101, &h0101, &h5555, &h2828, &h1010, &h1010, &h5555, &h8282
DATA &h2828, &h1111, &h0000, &h5555, &h0000, &h1111, &h8282, &h4444
DATA &h5555, &h0000, &h0404, &h0000, &h4444, &h0000, &h0404, &h0000
DATA &h6C6C, &h9E9E, &hBEBE, &h7C7C, &h3838, &h1010, &h0000, &h0000
DATA &h0606, &h8181, &h4040, &h2020, &h2020, &h6060, &h9090, &h0909
DATA &h1010, &h0808, &h0404, &h0000, &h4040, &h8080, &h0101, &h0000
DATA &h4444, &h8282, &h0101, &h0101, &h0101, &h8282, &h4444, &h3939
DATA &hFFFF, &h8080, &h8080, &h8080, &hFFFF, &h0808, &h0808, &h0808
DATA &h8080, &h1010, &h0202, &h2020, &h0101, &h0808, &h4040, &h0404
DATA &h4040, &hA0A0, &h0000, &h0000, &h0404, &h0A0A, &h0000, &h0000
DATA &h5555, &hAAAA, &h5555, &hAAAA, &h5555, &hAAAA, &h5555, &hAAAA
DATA &h0000, &h8888, &h0000, &h2222, &h0000, &h8888, &h0000, &h2222

' Data for default cursor
DATA &hFF, &h3F, &hFF, &h1F, &hFF, &h0F, &hFF, &h07
DATA &hFF, &h03, &hFF, &h01, &hFF, &h00, &h7F, &h00
DATA &h3F, &h00, &h1F, &h00, &h1F, &h00, &h7F, &h00
DATA &h7F, &h10, &h7F, &h30, &hFF, &hF8, &hFF, &hFF
DATA &h00, &hC0, &h00, &hA0, &h00, &h90, &h00, &h88
DATA &h00, &h84, &h00, &h82, &h00, &h81, &h80, &h80
DATA &h40, &h80, &h20, &h80, &hE0, &h81, &h80, &h90
DATA &h80, &hA8, &h80, &hC8, &h00, &h07, &h00, &h00

' Another cursor...
DATA &hFF, &h3F, &hFF, &h1F, &hFF, &h0F, &hFF, &h07
DATA &hFF, &h03, &hFF, &h01, &hFF, &h00, &h7F, &h00
DATA &h3F, &h00, &h1F, &h00, &hFF, &h01, &hFF, &h10
DATA &hFF, &h30, &h7F, &h78, &h7F, &hF8, &hFF, &hFC
DATA &h00, &hC0, &h00, &hA0, &h00, &h90, &h00, &h88
DATA &h00, &h84, &h00, &h82, &h00, &h81, &h80, &h80
DATA &h40, &h80, &hE0, &h83, &h00, &h92, &h00, &hA9
DATA &h00, &hC9, &h80, &h84, &h80, &h04, &h00, &h03

SUB drawBmp (x, y, file$)

    DEF SEG

    OPEN file$ FOR BINARY AS #1
        header$ = INPUT$(14, 1)
        headerPtr = SADD(header$)
        IF PEEK(headerPtr) <> 66 OR PEEK(headerPtr + 1) <> 77 THEN EXIT SUB

        dataOffset = PEEK(headrPtr + 10) + (PEEK(headerPtr + 11) * 256) + 89
        
        header$ = INPUT$(40, 1)
        headerPtr = SADD(header$)

        bmpWidth = PEEK(headerPtr + 4) + (PEEK(headerPtr + 5) * 256)
        bmpHeight = PEEK(headerPtr + 8) + (PEEK(headerPtr + 9) * 256)
        bmpBitCount = PEEK(headerPtr + 14)

        SEEK 1, dataOffset

        y = y + bmpHeight - 1
        bytesPerLine = bmpWidth \ (8 \ bmpBitCount)

        IF bmpBitCount = 2 THEN
        ELSEIF bmpBitCount = 4 THEN

            FOR i = 0 TO bmpHeight - 1
                data$ = INPUT$(bytesPerLine, 1)
                dataPtr& = SADD(data$)
               
                FOR j = 0 TO bytesPerLine - 1
                    c = PEEK(dataPtr&)
                    PSET (x, y), winPalette(c \ 16)
                    PSET (x + 1, y), winPalette(c AND 15)
                    dataPtr& = dataPtr& + 1
                    x = x + 2
                NEXT j

                x = x - bmpWidth
                y = y - 1
            NEXT i
        END IF
    CLOSE #1

END SUB

SUB drawBox (x, y, w, h, c1, c2, c3)

    x2 = x + w - 1
    y2 = y + h - 1

    LINE (x, y)-(x2, y2), c1, BF
    LINE (x, y)-(x2, y2), 0, B
   
    IF w >= 4 AND h >= 4 THEN
        IF c2 <> c1 THEN
            LINE (x + 1, y + 1)-(x2 - 2, y + 1), c2
            LINE (x + 1, y + 1)-(x + 1, y2 - 2), c2
        END IF

        IF c3 <> c1 THEN
            LINE (x + 2, y2 - 1)-(x2 - 1, y2 - 1), c3
            LINE (x2 - 1, y + 2)-(x2 - 1, y2 - 2), c3
        END IF
    END IF
   
END SUB

SUB drawIcon (x, y, file$)

    DEF SEG
    h$ = CHR$(0) + CHR$(0) + CHR$(1) + CHR$(0)

    OPEN file$ FOR BINARY AS #1
        header$ = INPUT$(6, 1)
        IF LEFT$(header$, 4) <> h$ THEN
            EXIT SUB
        END IF

        icoCount = ASC(MID$(header$, 5, 1))
        IF icoCount = 0 THEN EXIT SUB

        icoDir$ = INPUT$(16 * icoCount, 1)
        icoDirPtr = SADD(icoDir$)
        icoFound = 0
        FOR i = 0 TO icoCount - 1
            IF PEEK(icoDirPtr + 2) = 16 THEN
                icoFound = 1
                EXIT FOR
            END IF
            icoDirPtr = icoDirPtr + 16
        NEXT i

        IF icoFound = 0 THEN EXIT SUB
    
        icoWidth = PEEK(icoDirPtr)
        icoHeight = PEEK(icoDirPtr + 1)
        size = (PEEK(icoDirPtr + 8) + (PEEK(icoDirPtr + 9) * 256)) - 104
        offset = (PEEK(icoDirPtr + 12) + (PEEK(icoDirPtr + 13) * 256)) + 105

        SEEK 1, offset
        data$ = INPUT$(size, 1)
        dataPos = SADD(data$)
        maskPos = dataPos + (icoWidth \ 2) * icoHeight
        y = y + icoHeight - 1
      
        FOR i = 0 TO icoHeight - 1
            FOR j = 0 TO (icoWidth / 8) - 1
                m = 255 - PEEK(maskPos)
               
                FOR k = 0 TO 6 STEP 2
                    c = PEEK(dataPos)
                    IF m AND pow2(7 - k) THEN
                        PSET (x, y), winPalette(c \ 16)
                    END IF
                    IF m AND pow2(6 - k) THEN
                        PSET (x + 1, y), winPalette(c AND 15)
                    END IF
                    dataPos = dataPos + 1
                    x = x + 2
                NEXT k

                maskPos = maskPos + 1
            NEXT j

            x = x - icoWidth
            y = y - 1
        NEXT i
    CLOSE #1

END SUB

SUB drawPatternBox (x, y, w, h, c1, c2, PatIndex)

    ' Fill area with background color
    IF c2 > -1 THEN
        LINE (x, y)-(x + w - 1, y + h - 1), c2, BF
    END IF

    ' Fill area with the pattern
    FOR i = y TO y + h - 1
        LINE (x, i)-(x + w - 1, i), c1, , fillPattern(PatIndex, i MOD 8)
    NEXT i

END SUB

SUB drawShadowBox (x, y, w, h)

    a = (x MOD 2) XOR (y MOD 2)

    IF w > h THEN
        FOR i = y TO y + h - 1
            IF i MOD 2 = a THEN
                LINE (x, i)-(x + w - 1, i), 0, , &HAAAA
            ELSE
                LINE (x, i)-(x + w - 1, i), 0, , &H5555
            END IF
        NEXT i
    ELSE
        FOR i = x TO x + w - 1
            IF i MOD 2 = a THEN
                LINE (i, y)-(i, y + h - 1), 0, , &HAAAA
            ELSE
                LINE (i, y)-(i, y + h - 1), 0, , &H5555
            END IF
        NEXT i

    END IF

END SUB

SUB drawShallowBox (x, y, w, h, c1, c2, c3)

    x2 = x + w - 1
    y2 = y + h - 1

    LINE (x + 1, y + 1)-(x2 - 1, y2 - 1), c1, BF
   
    IF w >= 2 AND h >= 2 THEN
        IF c2 <> c1 THEN
            LINE (x, y)-(x2 - 1, y), c2
            LINE (x, y)-(x, y2 - 1), c2
        END IF

        IF c3 <> c1 THEN
            LINE (x + 1, y2)-(x2, y2), c3
            LINE (x2, y + 1)-(x2, y2), c3
        END IF
    END IF


END SUB

SUB Gui.button (x, y, w, h, text$)

    drawBox x, y, w, h, 7, 15, 8
    QFont.renderTextBox fontPtr&, text$, x + 3, y + 3, w - 6, h - 6, 0, 130

END SUB

SUB Gui.checkBox (x, y, w, text$, checked)

    drawBox x, y, 10, 10, 15, 8, 15
    IF checked THEN
        LINE (x + 3, y + 3)-(x + 6, y + 6), 9, BF
    END IF
    QFont.renderTextBox fontPtr&, text$, x + 14, y + 1, w - 14, 8, 0, 128

END SUB

SUB Gui.hScroller (x, y, size, area, port, value)

    drawBox x + 13, y, size - 26, 14, 7, 8, 15
    drawShallowBox x + 20, y + 5, size - 40, 4, 0, 8, 15
    drawBox x, y, 14, 14, 7, 15, 8
    drawBox x + size - 14, y, 14, 14, 7, 15, 8

    ratio! = ((size - 26) / area)
    knobX = Math.min(value, area - port) * ratio!
    knobW = Math.max(14, ratio! * port)
    knobW2 = (knobW \ 2) + knobX
    drawBox x + 13 + knobX, y, knobW, 14, 7, 15, 8
    drawShallowBox x + knobW2 + 10, y + 4, 2, 6, 7, 15, 8
    drawShallowBox x + knobW2 + 12, y + 4, 2, 6, 7, 15, 8
    drawShallowBox x + knobW2 + 14, y + 4, 2, 6, 7, 15, 8

    PUT (x + 3, y + 3), icons(0, 2), AND
    PUT (x + size - 11, y + 3), icons(0, 3), AND


END SUB

SUB Gui.init

    Mouse.reset

    DEF SEG = &HA000
    FOR i = 0 TO 6
        FOR j = 0 TO 7
            READ a
            POKE j * 80, 255 - a
        NEXT j
        GET (0, 0)-(7, 7), icons(0, i)
    NEXT i

    FOR i = 0 TO 15
        READ c
        winPalette(i) = c
    NEXT i

    FOR i = 0 TO 17
        FOR j = 0 TO 7
            READ p
            fillPattern(i, j) = p
        NEXT j
    NEXT i

    curDefault$ = ""
    FOR i = 0 TO 63
        READ c
        curDefault$ = curDefault$ + CHR$(c)
    NEXT i

    FOR i = 0 TO 7
        pow2(i) = 2 ^ i
    NEXT i

    Mouse.setGraphicCursor curDefault$
    DEF SEG
    font$ = QFont.loadFont$("media\trebuch.fnt")
    fontPtr& = SADD(font$)

END SUB

SUB Gui.panel (x, y, w, h, c)

    LINE (x, y)-(x + w - 1, y + h - 1), c, BF

    LINE (x, y)-(x + w - 2, y), 8
    LINE (x, y)-(x, y + h - 2), 8
    LINE (x + 2, y + h - 2)-(x + w - 2, y + h - 2), 8
    LINE (x + w - 2, y + 2)-(x + w - 2, y + h - 2), 8

    LINE (x + 1, y + h - 1)-(x + w - 1, y + h - 1), 15
    LINE (x + w - 1, y + 1)-(x + w - 1, y + h - 1), 15
    LINE (x + 1, y + 1)-(x + w - 3, y + 1), 15
    LINE (x + 1, y + 1)-(x + 1, y + h - 3), 15


END SUB

SUB Gui.progressBar (x, y, w, h, max, value)

    drawBox x, y, w, h, 7, 8, 15

    value = Math.max(0, Math.min(value, max))
    IF value > 0 THEN
        l = ((w - 4) / max) * value
        drawBox x + 2, y + 2, l, h - 4, 9, 15, 1
    END IF

END SUB

SUB Gui.spinner (x, y, min, max, value)

    drawBox x + 13, y, 32, 14, 15, 8, 15
    drawBox x, y, 14, 14, 7, 15, 8
    drawBox x + 44, y, 14, 14, 7, 15, 8

    PUT (x + 3, y + 3), icons(0, 5), AND
    PUT (x + 47, y + 3), icons(0, 6), AND

    QFont.renderTextBox fontPtr&, STR$(value), x + 14, y + 4, 30, 8, 0, 2

END SUB

SUB Gui.vScroller (x, y, size, area, port, value)

    drawBox x, y + 13, 14, size - 26, 7, 8, 15
    drawShallowBox x + 5, y + 20, 4, size - 40, 0, 8, 15
    drawBox x, y, 14, 14, 7, 15, 8
    drawBox x, y + size - 14, 14, 14, 7, 15, 8

    ratio! = ((size - 26) / area)
    knobY = Math.min(value, area - port) * ratio!
    knobH = Math.max(14, ratio! * port)
    knobH2 = (knobH \ 2) + knobY
    drawBox x, y + 13 + knobY, 14, knobH, 7, 15, 8
    drawShallowBox x + 4, y + knobH2 + 10, 6, 2, 7, 15, 8
    drawShallowBox x + 4, y + knobH2 + 12, 6, 2, 7, 15, 8
    drawShallowBox x + 4, y + knobH2 + 14, 6, 2, 7, 15, 8

    PUT (x + 3, y + 3), icons(0, 0), AND
    PUT (x + 3, y + size - 11), icons(0, 1), AND

END SUB

SUB Gui.window (x, y, w, h, title$)

    drawBox x, y, w, h, 3, 3, 3
    drawShadowBox x + 4, y + h, w, 4
    drawShadowBox x + w, y + 4, 4, h - 4
    drawBox x + 3, y + 3, 14, 14, 7, 15, 8
    drawShallowBox x + 7, y + 7, 6, 6, 12, 4, 15
    drawBox x + 16, y + 3, w - 19, 14, 9, 15, 1
    drawBox x + 3, y + 19, w - 6, h - 22, 7, 15, 8
    QFont.renderTextBox fontPtr&, title$, x + 22, y + 7, w - 40, 8, 15, 0

END SUB

