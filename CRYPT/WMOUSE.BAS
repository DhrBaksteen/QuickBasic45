DECLARE SUB playMusic ()
DECLARE SUB Mouse.update (cursor%)
DEFINT A-Z
DECLARE SUB loadCursors ()
DECLARE SUB updateMouse (cursor)
DECLARE SUB setCursor (file$, cur)
DECLARE SUB Mouse.driver (ax, bx, cx, dx, LB, RB, EX)
DECLARE SUB Mouse.hide ()
DECLARE SUB Mouse.show (cursor)
DECLARE FUNCTION Mouse.getB ()
DECLARE FUNCTION Mouse.getX ()
DECLARE FUNCTION Mouse.getY ()

TYPE RegTypeX
	 ax    AS INTEGER
	 bx    AS INTEGER
	 cx    AS INTEGER
	 dx    AS INTEGER
	 bp    AS INTEGER
	 si    AS INTEGER
	 di    AS INTEGER
	 flags AS INTEGER
	 ds    AS INTEGER
	 es    AS INTEGER
END TYPE

DIM SHARED regs AS RegTypeX
DIM SHARED cursor1(7, 9), cursor2(7, 9), behindCur(7, 9)
DIM SHARED curMask1(7, 9), curMask2(7, 9)
DIM SHARED mouseX, mouseY
mouseX = -1


cursor:
DATA 1,1,0,0,0,0,0
DATA 1,0,1,0,0,0,0
DATA 1,0,0,1,0,0,0
DATA 1,0,0,0,1,0,0
DATA 1,0,0,0,0,1,0
DATA 1,0,0,0,0,0,1
DATA 1,0,0,0,1,1,1
DATA 1,0,1,1,0,0,0
DATA 1,1,0,0,0,0,0

cursorMask:
DATA 0,0,1,1,1,1,1
DATA 0,0,0,1,1,1,1
DATA 0,0,0,0,1,1,1
DATA 0,0,0,0,0,1,1
DATA 0,0,0,0,0,0,1
DATA 0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0
DATA 0,0,0,0,1,1,1
DATA 0,0,1,1,1,1,1

busy:
DATA 1,1,1,1,1,1,1
DATA 1,0,0,0,0,0,1
DATA 0,1,0,0,0,1,0
DATA 0,1,0,0,0,1,0
DATA 0,0,1,0,1,0,0
DATA 0,1,0,0,0,1,0
DATA 0,1,0,0,0,1,0
DATA 1,0,0,0,0,0,1
DATA 1,1,1,1,1,1,1

busyMask:
DATA 0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0
DATA 1,0,0,0,0,0,1
DATA 1,0,0,0,0,0,1
DATA 1,1,0,0,0,1,1
DATA 1,0,0,0,0,0,1
DATA 1,0,0,0,0,0,1
DATA 0,0,0,0,0,0,0
DATA 0,0,0,0,0,0,0

FUNCTION Mouse.getB

	regs.ax = &H3
	CALL interrupt(&H33, regs, regs)

	Mouse.getB = regs.bx

END FUNCTION

FUNCTION Mouse.getX

	regs.ax = &H3
	CALL interrupt(&H33, regs, regs)

	Mouse.getX = regs.cx \ 2

END FUNCTION

FUNCTION Mouse.getY

	regs.ax = &H3
	CALL interrupt(&H33, regs, regs)
   
	Mouse.getY = regs.dx

END FUNCTION

SUB Mouse.hide

	IF mouseX > -1 THEN PUT (mouseX, mouseY), behindCur, PSET

END SUB

SUB Mouse.loadCursors

	RESTORE cursor

	SCREEN , , 1, 0

	FOR i = 0 TO 35
		FOR j = 0 TO 6
			READ c
			PSET (j, i), c * 15
		NEXT j
	NEXT i

	GET (0, 0)-(6, 8), cursor1
	GET (0, 9)-(6, 17), curMask1
	GET (0, 18)-(6, 26), cursor2
	GET (0, 27)-(6, 35), curMask2

	CLS
	mouseX = -1

	SCREEN , , 0, 0

END SUB

SUB Mouse.show (cursor)

	x = Mouse.getX
	IF x > 312 THEN x = 312

	y = Mouse.getY
	IF y > 191 THEN y = 191

	GET (x, y)-(x + 7, y + 8), behindCur

	mouseX = x
	mouseY = y

	IF cursor = 0 THEN
		PUT (x, y), curMask1, AND
		PUT (x, y), cursor1, XOR
	ELSE
		PUT (x, y), curMask2, AND
		PUT (x, y), cursor2, XOR
	END IF
   
END SUB

SUB Mouse.update (cursor)

	x = Mouse.getX
	IF x > 312 THEN x = 312

	y = Mouse.getY
	IF y > 191 THEN y = 191

	'LOCATE 1, 1: PRINT x, y

	IF x <> mouseX OR y <> mouseY THEN
		IF mouseX > -1 THEN PUT (mouseX, mouseY), behindCur, PSET
		GET (x, y)-(x + 7, y + 8), behindCur

		mouseX = x
		mouseY = y

		IF cursor = 0 THEN
			PUT (x, y), curMask1, AND
			PUT (x, y), cursor1, XOR
		ELSE
			PUT (x, y), curMask2, AND
			PUT (x, y), cursor2, XOR
		END IF
	END IF

END SUB

SUB Mouse.waitRelease

	DO
		IF PLAY(0) < 5 THEN playMusic
		Mouse.update 0
	LOOP UNTIL Mouse.getB = 0

END SUB

