DEFINT A-Z

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

SCREEN 0: CLS
PRINT "This is a demonstratin of how the SCREEN 0 character set can be altered."
PRINT "In this demo int 0x10 is used to change the appearance of the 'A' character."
PRINT "This change is indefinite until you exit to DOS or reset the computer."
PRINT
PRINT "Press any key to continue..."

DO: LOOP UNTIL INKEY$ = ""
DO: LOOP UNTIL INKEY$ <> ""

LOCATE 2, 64: COLOR 11: PRINT "A"
COLOR 7

char$ = ""
FOR i = 0 TO 15
	READ c
	char$ = char$ + CHR$(c)
NEXT i

regs.ax = &H1110
regs.es = VARSEG(char$)
regs.bp = SADD(char$)
regs.cx = &H1
regs.dx = &H41
regs.bx = &H1000
CALL interrupt(&H10, regs, regs)

DATA &h00,&h00,&h18,&h18,&h14,&h24,&h24,&h2E
DATA &h72,&h42,&h83,&h81,&h00,&h00,&h00,&h00

