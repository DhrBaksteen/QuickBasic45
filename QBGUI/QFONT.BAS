DEFINT A-Z

DECLARE FUNCTION Math.min (a, b)

DECLARE FUNCTION QFont.getNextWord$ (text$, p)
DECLARE FUNCTION QFont.getNumLines (fontPtr&, text$, textBoxWidth)
DECLARE FUNCTION QFont.getStringWidth (fontPtr&, text$)
DECLARE FUNCTION QFont.loadFont$ (file$)
DECLARE FUNCTION QFont.renderLetter (fontPtr&, code, x, y, c)
DECLARE SUB QFont.renderString (fontPtr&, text$, x, y, c)
DECLARE SUB QFont.renderTextBox (fontPtr&, text$, x, y, w, h, c, alignment)

FUNCTION QFont.getNextWord$ (text$, p)

    DEF SEG = VARSEG(text$)
    offset& = SADD(text$)

    length = LEN(text$)
    word$ = ""

    WHILE (PEEK(offset& + p) < 33 AND p < length)
        p = p + 1
    WEND

    IF p <= length THEN
        WHILE (PEEK(offset& + p) > 32 AND p < length)
            word$ = word$ + CHR$(PEEK(offset& + p))
            p = p + 1
        WEND
    END IF

    QFont.getNextWord$ = word$

END FUNCTION

FUNCTION QFont.getNumLines (fontPtr&, text$, textBoxWidth)

    numLines = 1
    spacing = PEEK(fontPtr& + 288) + 1

    p = 0
    lineWidth = 0
    WHILE p < LEN(text$)
        word$ = QFont.getNextWord$(text$, p)
        wordWidth = QFont.getStringWidth(fontPtr&, word$)
        lineWidth = lineWidth + wordWidth + spacing

        IF lineWidth > textBoxWidth THEN
            numLines = numLines + 1
            lineWidth = wordWidth
        END IF
    WEND

    QFont.getNumLines = numLines

END FUNCTION

FUNCTION QFont.getStringWidth (fontPtr&, text$)

    stringWidth = 0

    textPtr& = SADD(text$)
    FOR i = 0 TO LEN(text$) - 1
        c = PEEK(textPtr& + i)
        stringWidth = stringWidth + PEEK(fontPtr& + (c * 9))
    NEXT i

    stringWidth = stringWidth + LEN(text$) - 1
    QFont.getStringWidth = stringWidth

END FUNCTION

FUNCTION QFont.loadFont$ (file$)

    OPEN file$ FOR BINARY AS #1
        QFont.loadFont$ = INPUT$(256 * 9, #1)
    CLOSE #1

END FUNCTION

FUNCTION QFont.renderLetter (fontPtr&, code, x, y, c)

    letterPtr& = fontPtr& + (code * 9)
    size = PEEK(letterPtr&)
   
    FOR i = 0 TO 7
        letterPtr& = letterPtr& + 1
        byte = PEEK(letterPtr&)

        bit = 128
        FOR j = 0 TO size
            IF byte AND bit THEN
                PSET (x + j, y + i), c
            END IF
            bit = bit \ 2
        NEXT j
    NEXT i

    QFont.renderLetter = size + 1

END FUNCTION

SUB QFont.renderString (fontPtr&, text$, x, y, c)

    textPtr& = SADD(text$)

    FOR i = 0 TO LEN(text$) - 1
        x = x + QFont.renderLetter(fontPtr&, PEEK(textPtr&), x, y, c)
        textPtr& = textPtr& + 1
    NEXT i
   
END SUB

SUB QFont.renderTextBox (fontPtr&, text$, x, y, w, h, c, alignment)

    ' Alignment bits:
    ' 7 - VCenter
    ' 6 - Bottom
    ' 1 - HCenter
    ' 0 - Right

    IF alignment >= 64 THEN
        textHeight = Math.min(h, QFont.getNumLines(fontPtr&, text$, w) * 8)
        IF alignment AND 128 THEN
            y = y + (h - textHeight) \ 2
        ELSE
            y = y + (h - textHeight)
        END IF
    END IF

    p = 0
    leftEdge = x
    rightEdge = x + w
    bottomEdge = y + h - 8
    spacing = QFont.getStringWidth(fontPtr&, " ") + 1
    textLine$ = ""

    WHILE p < LEN(text$)
        word$ = QFont.getNextWord$(text$, p)
        wordWidth = QFont.getStringWidth(fontPtr&, word$)
       
        IF x + wordWidth >= rightEdge THEN
            textLine$ = LEFT$(textLine$, LEN(textLine$) - 1)
            textX = leftEdge
            IF alignment AND 2 THEN
                textX = textX + ((w - QFont.getStringWidth(fontPtr&, textLine$)) \ 2)
            ELSEIF alignment AND 1 THEN
                textX = textX + (w - QFont.getStringWidth(fontPtr&, textLine$))
            END IF

            QFont.renderString fontPtr&, textLine$, textX, y, c
           
            textLine$ = ""
            x = leftEdge
            y = y + 8
            IF y > bottomEdge THEN EXIT SUB
        END IF

        textLine$ = textLine$ + word$ + " "
        x = x + wordWidth + spacing
    WEND

    IF LEN(textLine$) THEN
        textLine$ = LEFT$(textLine$, LEN(textLine$) - 1)
        textX = leftEdge
        IF alignment AND 2 THEN
            textX = textX + ((w - QFont.getStringWidth(fontPtr&, textLine$)) \ 2)
        ELSEIF alignment AND 1 THEN
            textX = textX + (w - QFont.getStringWidth(fontPtr&, textLine$))
        END IF

        QFont.renderString fontPtr&, textLine$, textX, y, c
    END IF
END SUB

