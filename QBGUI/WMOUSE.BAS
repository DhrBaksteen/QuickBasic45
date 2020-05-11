DEFINT A-Z
DECLARE SUB Mouse.hide ()
DECLARE SUB Mouse.show ()
DECLARE FUNCTION Mouse.getB ()
DECLARE FUNCTION Mouse.getX ()
DECLARE FUNCTION Mouse.getY ()
DECLARE SUB Mouse.setGraphicCursor (cur$)
DECLARE SUB Mouse.reset ()
DECLARE SUB Mouse.putCursor (x, y)
DECLARE SUB Mouse.setRangeH (min, max)
DECLARE SUB Mouse.setRangeV (min, max)
DECLARE SUB Mouse.setTextCursor (sMask, cMask)


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
DIM SHARED mouseX, mouseY, mouseB
mouseX = -1

DATA &hFF, &h3F, &hFF, &h1F, &hFF, &h0F, &hFF, &h07
DATA &hFF, &h03, &hFF, &h01, &hFF, &h00, &h7F, &h00
DATA &h3F, &h00, &h1F, &h00, &hFF, &h01, &hFF, &h10
DATA &hFF, &h30, &h7F, &h78, &h7F, &hF8, &hFF, &hFC

DATA &h10, &hC0, &h00, &hA0, &h00, &h90, &h00, &h88
DATA &h00, &h84, &h00, &h82, &h00, &h81, &h80, &h80
DATA &h40, &h80, &hE0, &h83, &h00, &h92, &h00, &hA9
DATA &h00, &hC9, &h80, &h84, &h80, &h04, &h00, &h03

SUB Mouse.disableRegion (x1, y1, x2, y2)

	regs.ax = &H10
	regs.cx = x1
	regs.dx = y1
	regs.si = x2
	regs.di = y2
	CALL interrupt(&H33, regs, regs)


END SUB

FUNCTION Mouse.getB

	regs.ax = &H3
	CALL interrupt(&H33, regs, regs)

	Mouse.getB = regs.bx

END FUNCTION

FUNCTION Mouse.getX

	regs.ax = &H3
	CALL interrupt(&H33, regs, regs)

	Mouse.getX = regs.cx

END FUNCTION

FUNCTION Mouse.getY

	regs.ax = &H3
	CALL interrupt(&H33, regs, regs)
   
	Mouse.getY = regs.dx

END FUNCTION

SUB Mouse.hide

	regs.ax = &H2
	CALL interrupt(&H33, regs, regs)
   
END SUB

SUB Mouse.putCursor (x, y)

	regs.ax = &H4
	regs.cx = x
	regs.dx = y
	CALL interrupt(&H33, regs, regs)

END SUB

SUB Mouse.reset

	regs.ax = &H0
	CALL interrupt(&H33, regs, regs)

END SUB

SUB Mouse.setGraphicCursor (cur$)

	regs.ax = &H9
	regs.bx = 0
	regs.cx = 0
	regs.es = VARSEG(cur$)
	regs.dx = SADD(cur$)
	CALL interrupt(&H33, regs, regs)

END SUB

SUB Mouse.setRangeH (min, max)

	regs.ax = &H7
	regs.cx = min
	regs.dx = max
	CALL interrupt(&H33, regs, regs)

END SUB

SUB Mouse.setRangeV (min, max)

	regs.ax = &H8
	regs.cx = min
	regs.dx = max
	CALL interrupt(&H33, regs, regs)

END SUB

SUB Mouse.setTextCursor (char, col)

	regs.ax = &HA
	regs.bx = &H0
	regs.cx = &HFF00
	regs.dx = &HFDB
	CALL interrupt(&H33, regs, regs)

END SUB

SUB Mouse.show

	regs.ax = &H1
	CALL interrupt(&H33, regs, regs)

END SUB

SUB Mouse.update

	regs.ax = &H3
	CALL interrupt(&H33, regs, regs)

	mouseB = regs.bx
	mouseX = regs.cx
	mouseY = regs.dx
   
END SUB

SUB Mouse.waitRelease

	DO: LOOP UNTIL Mouse.getB = 0

END SUB

