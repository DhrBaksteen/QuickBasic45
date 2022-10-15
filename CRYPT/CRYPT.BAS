DEFINT A-Z
DECLARE SUB busyMode (page)
DECLARE SUB credits ()
DECLARE SUB delay (delayTime!)
DECLARE SUB demoScene ()
DECLARE SUB displayMap ()
DECLARE SUB drawRoom (direction)
DECLARE SUB drawString (text$, x, y, xSize, ySize, col, attrib)
DECLARE SUB gameController ()
DECLARE SUB loadFont (file$)
DECLARE SUB loadRoom (room)
DECLARE FUNCTION Mouse.getB ()
DECLARE FUNCTION Mouse.getX ()
DECLARE FUNCTION Mouse.getY ()
DECLARE SUB Mouse.hide ()
DECLARE SUB Mouse.loadCursors ()
DECLARE SUB Mouse.show (cursor)
DECLARE SUB Mouse.update (cursor)
DECLARE SUB Mouse.waitRelease ()
DECLARE SUB playMusic ()
DECLARE SUB preloader ()
DECLARE SUB putImage (file$, index, x, y)
DECLARE SUB readme ()
DECLARE SUB readyMode (page)
DECLARE SUB shadow (x, y)
DECLARE SUB startMusic (file$)
DECLARE SUB story ()
DECLARE SUB title ()

CONST true = -1
CONST false = NOT true
CONST NORTH = 0
CONST EAST = 1
CONST SOUTH = 2
CONST WEST = 3


DIM SHARED overlay, font$
DIM SHARED direction, roomData$, linkedRoom(4)


SHELL "cd old\crypt"

SCREEN 7: CLS
loadFont "Medivo.fnt"
Mouse.loadCursors

preloader

DO
	title
	story
	gameController
LOOP

SUB busyMode (page)

	Mouse.hide
	Mouse.show 1
	SCREEN , , page, 0

END SUB

SUB credits

	mouseX = Mouse.getX
	mouseY = Mouse.getY

	PCOPY 0, 2
	SCREEN , , 1, 0
	LINE (0, 0)-(320, 200), 15, BF
	putImage "scene.gfx", 2, 0, 10
	PCOPY 1, 0
	SCREEN , , 0, 0
   
	SCREEN , , 1, 0
	LINE (0, 130)-(320, 150), 15, BF
	drawString "Presents", 131, 131, 1, 2, 7, 0
	drawString "Presents", 130, 130, 1, 2, 0, 0
	PCOPY 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	SCREEN , , 1, 0
	LINE (0, 130)-(320, 150), 15, BF
	drawString "The Crypt", 126, 131, 1, 2, 7, 0
	drawString "The Crypt", 125, 130, 1, 2, 0, 0
	PCOPY 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	SCREEN , , 1, 0
	LINE (0, 130)-(320, 150), 15, BF
	drawString "a game by Maarten Janssen", 71, 131, 1, 2, 7, 0
	drawString "a game by Maarten Janssen", 70, 130, 1, 2, 0, 0
	PCOPY 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	SCREEN , , 1, 0
	LINE (0, 130)-(320, 150), 15, BF
	drawString "Copyright (c) 2005", 101, 131, 1, 2, 7, 0
	drawString "Copyright (c) 2005", 100, 130, 1, 2, 0, 0
	PCOPY 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	SCREEN , , 1, 0
	LINE (0, 130)-(320, 150), 15, BF
	drawString "by Cheerful Software", 91, 131, 1, 2, 7, 0
	drawString "by Cheerful Software", 90, 130, 1, 2, 0, 0
	PCOPY 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	SCREEN , , 1, 0
	LINE (0, 130)-(320, 150), 15, BF
	drawString "HTTP://Welcome.to/Cheerful", 66, 131, 1, 2, 7, 0
	drawString "HTTP://Welcome.to/Cheerful", 65, 130, 1, 2, 0, 0
	PCOPY 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	SCREEN , , 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	LINE (0, 130)-(320, 150), 15, BF
	PCOPY 1, 0
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	GOSUB intDelay: IF interrupt THEN GOTO exitCredits
	GOTO exitCredits
   
intDelay:
	time! = TIMER
	DO
		IF PLAY(0) < 32 THEN playMusic
		IF INKEY$ <> "" THEN interrupt = true
		IF Mouse.getX <> mouseX OR Mouse.getY <> mouseY OR Mouse.getB THEN interrupt = true
	LOOP UNTIL (TIMER >= (time! + 2.5)) OR interrupt
RETURN

exitCredits:
	PCOPY 2, 0
	SCREEN , , 0, 0

END SUB

SUB delay (delayTime!)

	time! = TIMER
	DO
		IF PLAY(0) < 5 THEN playMusic
	LOOP UNTIL TIMER >= (time! + delayTime!)

END SUB

SUB demoScene

	DIM tortch(8, 10)

	PCOPY 3, 1
	SCREEN , , 1, 0
	x = 4: y = 4
	putImage "ega.gfx", 2, x + 106, y + 57
	putImage "ega.gfx", 6, x, y + 2
	putImage "ega.gfx", 11, x + 206, y + 132
	putImage "ega.gfx", 7, x + 150, y + 2
	putImage "ega.gfx", 13, x + 140, y + 80
	putImage "ega.gfx", 13, x + 160, y + 95
	putImage "ega.gfx", 13, x + 150, y + 110
	SCREEN , , 0, 0
	PCOPY 1, 0

	GET (x + 80, y + 70)-(x + 87, y + 79), tortch
	putImage "ega.gfx", 15, x + 80, y + 70

	DO
		playMusic

		IF NOT overlay THEN
			PUT (x + 80, y + 70), tortch, PSET
			putImage "ega.gfx", 15, x + 80, y + 70
			delay .25
			PUT (x + 80, y + 70), tortch, PSET
			putImage "ega.gfx", 16, x + 80, y + 70
			delay .25
		END IF

		key$ = INKEY$

		IF key$ <> "" AND overlay THEN
			PCOPY 1, 0
			key$ = ""
			overlay = false
		END IF

		SELECT CASE UCASE$(key$)
			CASE "1"
				putImage "enemies.gfx", 0, 100, 65
				overlay = true
			CASE "2"
				putImage "enemies.gfx", 1, 120, 55
				overlay = true
			CASE "3"
				putImage "enemies.gfx", 2, 150, 135
				overlay = true
			CASE "4"
				putImage "enemies.gfx", 3, 130, 100
				overlay = true
			CASE "5"
				putImage "enemies.gfx", 4, 100, 55
				overlay = true
			CASE "6"
				putImage "enemies.gfx", 5, 100, 55
				overlay = true
			CASE "7"
				putImage "enemies.gfx", 6, 125, 50
				overlay = true
			CASE "8"
				putImage "enemies.gfx", 7, 105, 40
				overlay = true
			CASE "9"
				putImage "enemies.gfx", 8, 125, 110
				overlay = true
			CASE "A"
				putImage "enemies.gfx", 9, 100, 55
				overlay = true
			CASE "B"
				putImage "enemies.gfx", 10, 55, 55
				overlay = true
			CASE "C"
				putImage "enemies.gfx", 11, 110, 20
				overlay = true
			CASE "M"
				putImage "ega.gfx", 18, 100, 20
				drawString "...Level map...", 118, 90, 1, 1, 8, 0
				overlay = true
			CASE CHR$(27)
				SCREEN , , 2, 0
				putImage "scene.gfx", 1, 0, 0
				exitGame = true
		END SELECT
	LOOP UNTIL exitGame

END SUB

SUB displayMap

	busyMode 1
	PCOPY 1, 2
	putImage "ega.gfx", 18, 100, 20
	drawString "...Level map...", 118, 90, 1, 1, 8, 0
	readyMode 1

	DO
		IF PLAY(0) < 5 THEN playMusic
		Mouse.update 0
	LOOP UNTIL INKEY$ <> "" OR Mouse.getB > 0

	Mouse.hide
	PCOPY 2, 1
	PCOPY 2, 0
	Mouse.show 0

END SUB

SUB drawRoom (direction)

	busyMode 1
	PCOPY 3, 1
   
	doors = ASC(MID$(roomData$, 5, 1))
	IF doors >= 128 THEN doorNorth = doorNorth + 2: doors = doors - 128
	IF doors >= 64 THEN doorNorth = doorNorth + 1: doors = doors - 64
	IF doors >= 32 THEN doorEast = doorEast + 2: doors = doors - 32
	IF doors >= 16 THEN doorEast = doorEast + 1: doors = doors - 16
	IF doors >= 8 THEN doorSouth = doorSouth + 2: doors = doors - 8
	IF doors >= 4 THEN doorSouth = doorSouth + 1: doors = doors - 4
	IF doors >= 2 THEN doorWest = doorWest + 2: doors = doors - 2
	IF doors >= 1 THEN doorWest = doorWest + 1

	SELECT CASE direction
		CASE NORTH
			LOCATE 1, 1: PRINT "North"
			door = doorNorth
		CASE EAST
			LOCATE 1, 1: PRINT "East"
			door = doorEast
		CASE SOUTH
			LOCATE 1, 1: PRINT "South"
			door = doorSouth
		CASE WEST
			LOCATE 1, 1: PRINT "West"
			door = doorWest
	END SELECT

	SELECT CASE door
		CASE 1
			putImage "ega.gfx", 1, 97, 45
		CASE 2
			putImage "ega.gfx", 2, 110, 61
		CASE 3
	END SELECT

	readyMode 1

END SUB

SUB drawString (text$, x, y, xSize, ySize, col, attrib)

	IF attrib >= 128 THEN bold = xSize / 2 + .5: attrib = attrib - 128
	IF attrib >= 64 THEN italic = true: attrib = attrib - 64
	IF attrib >= 32 THEN uline = true: attrib = attrib - 32
   
	IF font$ = "" THEN
		EXIT SUB
	END IF

	DEF SEG = VARSEG(font$)

	FOR p = 1 TO LEN(text$)
		IF italic THEN cc = 3 ELSE cc = 0
		char = ASC(MID$(text$, p, 1))
		FOR i = 0 TO 7
			a = PEEK(SADD(font$) + 17 + (char * 9) + i)
			FOR j = 7 TO 0 STEP -1
				IF a >= (2 ^ j) THEN
					px = x + 8 * xSize - j * xSize + (cc * xSize)
					py = y + i * ySize
					LINE (px, py)-(px + xSize - 1, py + ySize - 1), col, BF
					a = a - (2 ^ j)
				END IF
			NEXT j
			IF (i MOD 2 = 0) AND italic THEN cc = cc - 1
		NEXT i
		IF uline THEN
			LINE (x, y + ySize * 8)-(x + (PEEK(SADD(font$) + 16 + (char * 9)) + 1) * xSize, y + ySize * 8), col, BF
		END IF
		x = x + xSize * (PEEK(SADD(font$) + 16 + (char * 9)) + 1) + bold
		IF PLAY(0) < 10 THEN playMusic
	NEXT p

	DEF SEG

END SUB

SUB gameController

	direction = 0
	loadRoom 1
	drawRoom NORTH
   
	DO
		IF PLAY(0) < 5 THEN playMusic
		Mouse.update 0

		key$ = UCASE$(INKEY$)
		SELECT CASE key$
			CASE CHR$(0) + "P"
				'down
			CASE CHR$(0) + "H"
				IF linkedRoom(direction) THEN
					loadRoom linkedRoom(direction)
					drawRoom direction
				ELSE
					BEEP
				END IF
			CASE CHR$(0) + "M"
				direction = direction + 1
				IF direction = 4 THEN direction = NORTH
				drawRoom direction
			CASE CHR$(0) + "K"
				direction = direction - 1
				IF direction = -1 THEN direction = WEST
				drawRoom direction
			CASE "M"
				displayMap
			CASE CHR$(27)
				SCREEN , , 2, 0
				putImage "scene.gfx", 1, 0, 0
				exitGame = true
		END SELECT
	LOOP UNTIL exitGame

END SUB

SUB loadFont (file$)

	fileNum = FREEFILE

	OPEN file$ FOR BINARY AS fileNum

	font$ = STRING$(2320, " ")

	FOR i = 0 TO 2319
		byte$ = INPUT$(1, fileNum)
		MID$(font$, i + 1, 1) = byte$
	NEXT i

	CLOSE fileNum

END SUB

SUB loadRoom (room)

	OPEN "demo.clc" FOR BINARY AS #3
		SEEK 3, (room - 1) * 64 + 1
		roomData$ = INPUT$(64, 3)
	CLOSE #3

	FOR i = 1 TO 4
		linkedRoom(i - 1) = ASC(MID$(roomData$, i, 1))
	NEXT i

END SUB

SUB playMusic

	IF FREEFILE > 1 AND PLAY(0) < 32 THEN
		note$ = ""
		FOR i = 0 TO 19
			IF LOC(1) = LOF(1) THEN SEEK 1, 2
			note = ASC(INPUT$(1, 1))
			note$ = note$ + "N" + LTRIM$(STR$(note))
		NEXT i
		PLAY note$
	END IF
   
END SUB

SUB preloader

	DIM behindText(30, 10)

	SCREEN , , 1, 0
	putImage "gui.gfx", 0, 50, 30
	putImage "gui.gfx", 2, 60, 70
	drawString "Loading...", 56, 34, 1, 1, 15, 0
	drawString "Loading...", 55, 33, 1, 1, 0, 0
	GET (150, 76)-(179, 85), behindText
	SCREEN , , 0, 0
	PCOPY 1, 0

	OPEN "scene.gfx" FOR BINARY AS #2
	SEEK 2, 770

	FOR image = 0 TO 1
		SCREEN , , 3 - image, 0
		gfxWidth = ASC(INPUT$(1, 2)) + ASC(INPUT$(1, 2)) * 256
		gfxHeight = ASC(INPUT$(1, 2)) + ASC(INPUT$(1, 2)) * 256

		unused$ = INPUT$(1, 2)

		FOR y = 0 TO gfxHeight - 1
			data$ = INPUT$(gfxWidth \ 2, 2)
			FOR x = 1 TO gfxWidth \ 2
				byte = ASC(MID$(data$, x, 1))
				IF byte \ 16 <> 13 THEN
					IF byte \ 16 = 5 THEN
						shadow left + (x - 1) * 2, top + y
					ELSE
						PSET (left + (x - 1) * 2, top + y), byte \ 16
					END IF
				END IF
				IF (byte AND 15) <> 13 THEN
					IF (byte AND 15) = 5 THEN
						shadow left + (x - 1) * 2 + 1, top + y
					ELSE
						PSET (left + (x - 1) * 2 + 1, top + y), byte AND 15
					END IF
				END IF
			NEXT x
			proc = proc + 1
			SCREEN , , 1, 0
			PUT (150, 76), behindText, PSET
			IF proc \ 2 > 0 THEN LINE (62, 72)-(62 + proc \ 2 - 1, 87), 9, BF
			drawString LTRIM$(STR$(proc \ 4)) + "%", 151, 77, 1, 1, 1, 0
			drawString LTRIM$(STR$(proc \ 4)) + "%", 150, 76, 1, 1, 15, 0
			PCOPY 1, 0
			SCREEN , , 3 - image, 0
		NEXT y
	NEXT image

	CLOSE #2

	delay .5


END SUB

SUB putImage (file$, index, x, y)

	left = x
	top = y
	img = index

	fileNum = 2
	OPEN file$ FOR BINARY AS fileNum

	SEEK fileNum, img * 3 + 1

	offset& = ASC(INPUT$(1, fileNum))
	offset& = offset& * 65536
	plus& = ASC(INPUT$(1, fileNum))
	plus& = plus& * 256
	offset& = offset& + plus&
	offset& = offset& + ASC(INPUT$(1, fileNum))

	SEEK fileNum, offset& + 1

	gfxWidth = ASC(INPUT$(1, fileNum)) + ASC(INPUT$(1, fileNum)) * 256
	gfxHeight = ASC(INPUT$(1, fileNum)) + ASC(INPUT$(1, fileNum)) * 256

	unused$ = INPUT$(1, fileNum)

	FOR y = 0 TO gfxHeight - 1
		data$ = INPUT$(gfxWidth \ 2, fileNum)
		FOR x = 1 TO gfxWidth / 2
			byte = ASC(MID$(data$, x, 1))
			IF byte \ 16 <> 13 THEN
				IF byte \ 16 = 5 THEN
					shadow left + (x - 1) * 2, top + y
				ELSE
					PSET (left + (x - 1) * 2, top + y), byte \ 16
				END IF
			END IF
			IF (byte AND 15) <> 13 THEN
				IF (byte AND 15) = 5 THEN
					shadow left + (x - 1) * 2 + 1, top + y
				ELSE
					PSET (left + (x - 1) * 2 + 1, top + y), byte AND 15
				END IF
			END IF
		NEXT x
		IF PLAY(0) < 10 THEN playMusic
	NEXT y

	CLOSE fileNum

	x = left
	y = top

END SUB

SUB readme
  
	Mouse.hide
	Mouse.show 1
	SCREEN , , 1, 0
	CLS : PAINT (1, 1), 15
	
	part = 1
	GOSUB printText
	GOSUB drawButtons
	SCREEN , , 0, 0
	Mouse.hide
	PCOPY 1, 0
	Mouse.show 0
   
	DO
		Mouse.update 0
		GOSUB indexButton
		GOSUB upButton
		GOSUB downButton
		GOSUB backButton
		key$ = INKEY$
		SELECT CASE key$
			CASE CHR$(8)
				SOUND 0, 0
				SOUND 2000, 1
				SOUND 750, 1
				SOUND 1250, 1
			CASE CHR$(0) + "H", CHR$(0) + "I"
				GOSUB prevPart
			CASE CHR$(0) + "P", CHR$(0) + "Q"
				GOSUB nextPart
			CASE CHR$(27)
				exitScreen = true
			CASE ELSE
		END SELECT
		IF PLAY(0) < 5 THEN playMusic
	LOOP UNTIL exitScreen
   
	EXIT SUB

printText:
	SELECT CASE part
		CASE 1
			tc = 0: pgUpCol = 8: pgDnCol = 0
			drawString "About the game", 11, 11, 2, 1, 7, 32
			drawString "About the game", 10, 10, 2, 1, tc, 32
			drawString "When I started designing The Crypt I wanted", 10, 30, 1, 1, tc, 0
			drawString "it to have a nostalgic feeling, like you were", 10, 40, 1, 1, tc, 0
			drawString "playing an old DOS game. That's why it's not", 10, 50, 1, 1, tc, 0
			drawString "packed with 256-color images or high quality", 10, 60, 1, 1, tc, 0
			drawString "music and sounds.", 10, 70, 1, 1, tc, 0
			drawString "The game is programmed in Microsoft", 10, 90, 1, 1, tc, 0
			drawString "QuickBasic 4.5. All images are drawn in Paint", 10, 100, 1, 1, tc, 0
			drawString "and reduced in palette (if necessary) using", 10, 110, 1, 1, tc, 0
			drawString "Paint Shop Pro 8. They were than packed", 10, 120, 1, 1, tc, 0
			drawString "together using a simple gfx-packing tool I", 10, 130, 1, 1, tc, 0
			drawString "wrote. The music was converted by hand from", 10, 140, 1, 1, tc, 0
			drawString "the original mod files to PC-speaker tunes", 10, 150, 1, 1, tc, 0
			drawString "using a HEX editor. I also used this editor to", 10, 160, 1, 1, tc, 0
		CASE 2
			tc = 0: pgUpCol = 0: pgDnCol = 0
			drawString "create all the levels as I didn't want to write", 10, 10, 1, 1, tc, 0
			drawString "a tool to ease the process of doing this. It", 10, 20, 1, 1, tc, 0
			drawString "would simply take too much time. You might", 10, 30, 1, 1, tc, 0
			drawString "notice the mouse cursor reacting a little", 10, 40, 1, 1, tc, 0
			drawString "different at the edges of the screen than", 10, 50, 1, 1, tc, 0
			drawString "you normally might expect. This is because", 10, 60, 1, 1, tc, 0
			drawString "the default mouse cursor will not show up in", 10, 70, 1, 1, tc, 0
			drawString "an EGA screen. It has been made by hand", 10, 80, 1, 1, tc, 0
			drawString "using the GET and PUT commands and to", 10, 90, 1, 1, tc, 0
			drawString "avoid loosing even more speed by doing this", 10, 100, 1, 1, tc, 0
			drawString "the cursor cannot move out of the screen on", 10, 110, 1, 1, tc, 0
			drawString "the right and on the bottom of the screen as", 10, 120, 1, 1, tc, 0
			drawString "it normally would.", 10, 130, 1, 1, tc, 0
			drawString "Overall I think I achieved to give the game", 10, 150, 1, 1, tc, 0
			drawString "the classical look as I intended to. It might", 10, 160, 1, 1, tc, 0
		CASE 3
			tc = 0: pgUpCol = 0: pgDnCol = 8
			drawString "not run as fast as it could with a little more", 10, 10, 1, 1, tc, 0
			drawString "effort, but overall I like it. It really brings", 10, 20, 1, 1, tc, 0
			drawString "back memories of the games I used to play", 10, 30, 1, 1, tc, 0
			drawString "when I was younger. I hope you like the game", 10, 40, 1, 1, tc, 0
			drawString "and it gives you a nostalgic feeling as well.", 10, 50, 1, 1, tc, 0
			drawString "Enjoy!", 10, 70, 1, 1, tc, 0
			drawString "Maarten Janssen,", 10, 90, 1, 1, tc, 0
			drawString "Programmer", 10, 100, 1, 1, tc, 0
		CASE ELSE
	END SELECT
RETURN

drawButtons:
	putImage "gui.gfx", 1, 0, 184
	drawString "Index", 14, 189, 1, 1, 15, 0
	drawString "Index", 13, 188, 1, 1, 0, 0
	putImage "gui.gfx", 1, 95, 184
	drawString "Page Up", 102, 189, 1, 1, 15, 0
	drawString "Page Up", 101, 188, 1, 1, pgUpCol, 0
	putImage "gui.gfx", 1, 165, 184
	drawString "Page Dn", 172, 189, 1, 1, 15, 0
	drawString "Page Dn", 171, 188, 1, 1, pgDnCol, 0
	putImage "gui.gfx", 1, 256, 184
	drawString "Back", 273, 189, 1, 1, 15, 0
	drawString "Back", 272, 188, 1, 1, 0, 0
RETURN

indexButton:
	IF Mouse.getX > -1 AND Mouse.getX < 64 AND Mouse.getY > 183 AND Mouse.getY < 200 AND Mouse.getB = 1 THEN
		busyMode 1
		putImage "gui.gfx", 6, 0, 184
		drawString "Index", 15, 190, 1, 1, 15, 0
		drawString "Index", 14, 189, 1, 1, 0, 0
		readyMode 1
		Mouse.waitRelease
		IF Mouse.getX > -1 AND Mouse.getX < 64 AND Mouse.getY > 183 AND Mouse.getY < 200 THEN
			busyMode 1
			GOSUB drawButtons
			readyMode 1
		ELSE
			busyMode 1
			GOSUB drawButtons
			readyMode 1
		END IF
	END IF
RETURN

upButton:
	IF Mouse.getX > 94 AND Mouse.getX < 160 AND Mouse.getY > 183 AND Mouse.getY < 200 AND Mouse.getB = 1 THEN
		busyMode 1
		putImage "gui.gfx", 6, 95, 184
		drawString "Page Up", 103, 190, 1, 1, 15, 0
		drawString "Page Up", 102, 189, 1, 1, pgUpCol, 0
		readyMode 1
		Mouse.waitRelease
		IF Mouse.getX > 94 AND Mouse.getX < 160 AND Mouse.getY > 183 AND Mouse.getY < 200 THEN
			GOSUB prevPart
		ELSE
			busyMode 1
			GOSUB drawButtons
			readyMode 1
		END IF
	END IF
RETURN

downButton:
	IF Mouse.getX > 164 AND Mouse.getX < 229 AND Mouse.getY > 183 AND Mouse.getY < 200 AND Mouse.getB = 1 THEN
		busyMode 1
		putImage "gui.gfx", 6, 165, 184
		drawString "Page Dn", 172, 189, 1, 1, 15, 0
		drawString "Page Dn", 171, 188, 1, 1, pgDnCol, 0
		readyMode 1
		Mouse.waitRelease
		IF Mouse.getX > 164 AND Mouse.getX < 229 AND Mouse.getY > 183 AND Mouse.getY < 200 THEN
			GOSUB nextPart
		ELSE
			busyMode 1
			GOSUB drawButtons
			readyMode 1
		END IF
	END IF
RETURN

backButton:
	IF Mouse.getX > 255 AND Mouse.getX < 320 AND Mouse.getY > 183 AND Mouse.getY < 200 AND Mouse.getB = 1 THEN
		busyMode 1
		putImage "gui.gfx", 6, 256, 184
		drawString "Back", 274, 190, 1, 1, 15, 0
		drawString "Back", 273, 189, 1, 1, 0, 0
		readyMode 1
		Mouse.waitRelease
		IF Mouse.getX > 255 AND Mouse.getX < 320 AND Mouse.getY > 183 AND Mouse.getY < 200 THEN
			exitScreen = true
		ELSE
			busyMode 1
			GOSUB drawButtons
			readyMode 1
		END IF
	END IF
RETURN

nextPart:
	IF pgDnCol = 0 THEN
		busyMode 1
		part = part + 1
		LINE (0, 0)-(320, 200), 15, BF
		GOSUB printText
		GOSUB drawButtons
		readyMode 1
	ELSE
		SOUND 0, 0
		SOUND 1000, 1
		SOUND 750, 1
		busyMode 1
		GOSUB drawButtons
		readyMode 1
	END IF
RETURN

prevPart:
	IF pgUpCol = 0 THEN
		busyMode 1
		part = part - 1
		LINE (0, 0)-(320, 200), 15, BF
		GOSUB printText
		GOSUB drawButtons
		readyMode 1
	ELSE
		SOUND 0, 0
		SOUND 1000, 1
		SOUND 750, 1
		busyMode 1
		GOSUB drawButtons
		readyMode 1
	END IF
RETURN

END SUB

SUB readyMode (page)

	SCREEN , , 0, 0
	Mouse.hide
	PCOPY page, 0
	Mouse.show 0
   
END SUB

SUB shadow (x, y)

	col = POINT(x, y)

	IF col > 7 THEN
		col = col - 8
	ELSEIF col = 7 THEN
		col = 8
	ELSE
		col = 0
	END IF

	PSET (x, y), col

END SUB

SUB startMusic (file$)

	IF FREEFILE <> 1 THEN EXIT SUB

	PLAY "l64mlmb"
	OPEN file$ FOR BINARY AS #1
	tempo = ASC(INPUT$(1, 1))
	PLAY "t" + LTRIM$(STR$(tempo))

END SUB

SUB story

	busyMode 1
	putImage "story.gfx", 0, 0, 0
	readyMode 1
	Mouse.hide

	text$ = "It's already late in the evening"
	x = 25
	y = 180
	GOSUB tellStory
	text$ = "as the king calls for you..."
	GOSUB tellStory
	delay 2
	EXIT SUB

tellStory:
	xx = x
	FOR i = 1 TO LEN(text$)
		drawString MID$(text$, i, 1), x, y, 1, 1, 15, 0
		delay .1
		x = x + 1
	NEXT i
	x = xx
	y = y + 10
RETURN


END SUB

SUB title

	SCREEN , , 2, 0
	startMusic "title.mus"
	playMusic
	drawString "Alpha build 18", 220, 190, 1, 1, 7, 0
	
	putImage "gui.gfx", 4, 184, 90
	drawString "New Game", 203, 95, 1, 1, 15, 0
	drawString "New Game", 202, 94, 1, 1, 0, 0

	putImage "gui.gfx", 4, 184, 110
	drawString "Load", 217, 115, 1, 1, 15, 0
	drawString "Load", 216, 114, 1, 1, 0, 0

	putImage "gui.gfx", 4, 184, 130
	drawString "Read me", 208, 135, 1, 1, 15, 0
	drawString "Read me", 207, 134, 1, 1, 0, 0

	putImage "gui.gfx", 4, 184, 150
	drawString "Exit", 220, 155, 1, 1, 15, 0
	drawString "Exit", 219, 154, 1, 1, 0, 0

	PCOPY 2, 0
	SCREEN , , 0, 0
	Mouse.show 0

	time! = TIMER

	DO
		Mouse.update 0
		IF Mouse.getX > 184 AND Mouse.getX < 280 AND Mouse.getY > 89 AND Mouse.getY < 106 AND Mouse.getB = 1 THEN
			Mouse.hide
			PCOPY 0, 2
			SCREEN , , 2, 0
			putImage "gui.gfx", 5, 184, 90
			drawString "New Game", 204, 96, 1, 1, 15, 0
			drawString "New Game", 203, 95, 1, 1, 0, 0
			PCOPY 2, 0
			SCREEN , , 0, 0
			Mouse.show 0
			Mouse.waitRelease
			IF Mouse.getX > 184 AND Mouse.getX < 280 AND Mouse.getY > 89 AND Mouse.getY < 106 THEN
				startGame = true
			ELSE
				Mouse.hide
				PCOPY 0, 2
				SCREEN , , 2, 0
				putImage "gui.gfx", 4, 184, 90
				drawString "New Game", 203, 95, 1, 1, 15, 0
				drawString "New Game", 202, 94, 1, 1, 0, 0
				PCOPY 2, 0
				SCREEN , , 0, 0
				Mouse.show 0
			END IF
		END IF

		IF Mouse.getX > 184 AND Mouse.getX < 280 AND Mouse.getY > 129 AND Mouse.getY < 147 AND Mouse.getB = 1 THEN
			Mouse.hide
			PCOPY 0, 2
			SCREEN , , 2, 0
			putImage "gui.gfx", 5, 184, 130
			drawString "Read me", 209, 136, 1, 1, 15, 0
			drawString "Read me", 208, 135, 1, 1, 0, 0
			PCOPY 2, 0
			SCREEN , , 0, 0
			Mouse.show 0
			Mouse.waitRelease
			IF Mouse.getX > 184 AND Mouse.getX < 280 AND Mouse.getY > 129 AND Mouse.getY < 147 THEN
				Mouse.hide
				readme
				Mouse.show 1
				SCREEN , , 2, 0
				putImage "gui.gfx", 4, 184, 130
				drawString "Read me", 208, 135, 1, 1, 15, 0
				drawString "Read me", 208, 134, 1, 1, 0, 0
				SCREEN , , 0, 0
				Mouse.hide
				PCOPY 2, 0
				Mouse.show 0
				time! = TIMER
			ELSE
				Mouse.hide
				PCOPY 0, 2
				SCREEN , , 2, 0
				putImage "gui.gfx", 4, 184, 130
				drawString "Read me", 208, 135, 1, 1, 15, 0
				drawString "Read me", 208, 134, 1, 1, 0, 0
				PCOPY 2, 0
				SCREEN , , 0, 0
				Mouse.show 0
			END IF
		END IF

		IF Mouse.getX > 184 AND Mouse.getX < 280 AND Mouse.getY > 149 AND Mouse.getY < 166 AND Mouse.getB = 1 THEN
			Mouse.hide
			PCOPY 0, 2
			SCREEN , , 2, 0
			putImage "gui.gfx", 5, 184, 150
			drawString "Exit", 221, 156, 1, 1, 15, 0
			drawString "Exit", 220, 155, 1, 1, 0, 0
			PCOPY 2, 0
			SCREEN , , 0, 0
			Mouse.show 0
			Mouse.waitRelease
			IF Mouse.getX > 184 AND Mouse.getX < 280 AND Mouse.getY > 149 AND Mouse.getY < 166 THEN
				SCREEN 0
				WIDTH 80, 25
				COLOR 7, 0
				CLS
				END
			ELSE
				Mouse.hide
				PCOPY 0, 2
				SCREEN , , 2, 0
				putImage "gui.gfx", 4, 184, 150
				drawString "Exit", 220, 155, 1, 1, 15, 0
				drawString "Exit", 219, 154, 1, 1, 0, 0
				PCOPY 2, 0
				SCREEN , , 0, 0
				Mouse.show 0
			END IF
		END IF

		key$ = INKEY$
		IF key$ = CHR$(27) THEN
			SCREEN 0
			WIDTH 80, 25
			COLOR 7, 0
			CLS
			END
		END IF
		IF TIMER >= (time! + 30) THEN
			credits
			time! = TIMER
		END IF

		IF PLAY(0) < 5 THEN playMusic
	LOOP UNTIL startGame

	Mouse.hide

END SUB

