DEFINT A-Z
DECLARE SUB updateSegments (d)

SCREEN 3: RANDOMIZE TIMER

CONST DEPTH = 6
CONST SEGMENTS = 5
CONST SPEED = 5

DIM SHARED x(DEPTH, SEGMENTS + 1)
DIM SHARED y(DEPTH, SEGMENTS + 1)
DIM SHARED dx(SEGMENTS)
DIM SHARED dy(SEGMENTS)

FOR i = 0 TO SEGMENTS - 1
    x(0, i) = INT(RND * 720)
    y(0, i) = INT(RND * 348)
    dx(i) = INT(RND * 2)
    dy(i) = INT(RND * 2)
    IF dx(i) = 0 THEN dx(i) = -1
    IF dy(i) = 0 THEN dy(i) = -1
NEXT i

x(0, SEGMENTS) = x(0, 0)
y(0, SEGMENTS) = y(0, 0)

d = 0
FOR i = 0 TO DEPTH - 1
    updateSegments i
    d = (d + 1) MOD DEPTH
NEXT i


DO
    d1 = (d + 1) MOD DEPTH

    FOR i = 0 TO SEGMENTS - 1
        LINE (x(d1, i), y(d1, i))-(x(d1, i + 1), y(d1, i + 1)), 0
        LINE (x(d, i), y(d, i))-(x(d, i + 1), y(d, i + 1)), 1
    NEXT i

    updateSegments d
    d = d1
LOOP UNTIL INKEY$ <> ""

SCREEN 0
PRINT "For my Tulip Compact 2"
PRINT "Maarten Janssen, 2022-03-28"

SUB updateSegments (d)
  
    d1 = (d + 1) MOD DEPTH

    FOR i = 0 TO SEGMENTS - 1
        x(d1, i) = x(d, i) + dx(i) * SPEED
        IF x(d1, i) < 0 THEN x(d1, i) = -x(d1, i): dx(i) = -dx(i)
        IF x(d1, i) >= 720 THEN x(d1, i) = 719 - (x(d1, i) - 719): dx(i) = -dx(i)

        y(d1, i) = y(d, i) + dy(i) * SPEED
        IF y(d1, i) < 0 THEN y(d1, i) = -y(d1, i): dy(i) = -dy(i)
        IF y(d1, i) >= 348 THEN y(d1, i) = 348 - (y(d1, i) - 348): dy(i) = -dy(i)
    NEXT i
   
    x(d1, SEGMENTS) = x(d1, 0)
    y(d1, SEGMENTS) = y(d1, 0)

END SUB

