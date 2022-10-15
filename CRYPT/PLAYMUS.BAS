CLS
FILES "*.mus"

PLAY "l64ml"
IF COMMAND$ = "" THEN
    INPUT "Music file? ", file$
ELSE
    file$ = COMMAND$
END IF

OPEN file$ FOR BINARY AS #1

tempo = ASC(INPUT$(1, 1))
PLAY "T" + LTRIM$(STR$(tempo))

GOSUB addNotes

DO
    IF PLAY(0) < 32 THEN GOSUB addNotes
LOOP UNTIL INKEY$ <> ""
CLOSE #1

END

addNotes:
    FOR i = 0 TO 31
        IF LOC(1) = LOF(1) THEN SEEK 1, 2
        note = ASC(INPUT$(1, 1))
        note$ = "N" + LTRIM$(STR$(note))
        PLAY note$
    NEXT i
RETURN

