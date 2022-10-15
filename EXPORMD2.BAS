DECLARE SUB printIntro ()
DECLARE SUB printParticles ()
DECLARE FUNCTION updateParticles! ()
DECLARE FUNCTION updateBomb! ()
DECLARE SUB printBomb ()
DECLARE SUB placeBomb ()
DECLARE SUB updateHero (dRow!, dCol!)
DECLARE SUB printVillain ()
DECLARE FUNCTION updateVillain! ()
DECLARE SUB printHero ()
DECLARE SUB printScore ()
DECLARE SUB printSky ()

TYPE Guy
    lives AS INTEGER
    row AS INTEGER
    col AS INTEGER
    score AS INTEGER
END TYPE

TYPE Bomb
    counter AS INTEGER
    row AS INTEGER
    col AS INTEGER
END TYPE

TYPE Particle
    life AS INTEGER
    chr AS STRING * 1
    row AS DOUBLE
    col AS DOUBLE
    vRow AS DOUBLE
    vCol AS DOUBLE
END TYPE

CONST numParticles = 10
CONST statePlaceBomb = 1
CONST stateCountDown = 2
CONST stateExploding = 3
CONST stateGameOver = 4

DIM SHARED gameState
DIM SHARED colors(32)
DIM SHARED boom AS Bomb
DIM SHARED hero AS Guy
DIM SHARED villain AS Guy
DIM SHARED particles(numParticles) AS Particle

hero.lives = 5
hero.row = 16
hero.col = 60

CLS : RANDOMIZE TIMER
printSky
printIntro
DO: LOOP UNTIL INKEY$ <> ""
FOR i = 7 TO 25
    time! = TIMER
    LOCATE i, 1: PRINT STRING$(80, " ");
    DO: LOOP UNTIL TIMER > time! + .02
NEXT i

FOR i = 0 TO 31
    READ c
    colors(i) = c
NEXT i

printScore
placeBomb
gameState = statePlaceBomb

time! = TIMER
DO
    SELECT CASE gameState
        CASE statePlaceBomb
            printVillain
        CASE stateCountDown
            printBomb
        CASE stateExploding
            printParticles
        CASE ELSE
    END SELECT
 
    SELECT CASE INKEY$
        CASE CHR$(0) + "H"
            updateHero -1, 0
        CASE CHR$(0) + "P"
            updateHero 1, 0
        CASE CHR$(0) + "K"
            updateHero 0, -1
        CASE CHR$(0) + "M"
            updateHero 0, 1
        CASE CHR$(27)
            gameState = stateGameOver
        CASE ELSE
    END SELECT

    printHero

    DO: LOOP UNTIL TIMER > time! + .02
    time! = TIMER
   
    SELECT CASE gameState
        CASE statePlaceBomb
            IF updateVillain = 1 THEN
                PLAY "mbl32o3geb"
                gameState = stateCountDown
            ELSEIF villain.row = hero.row AND villain.col = hero.col THEN
                hero.score = hero.score + 125
                PLAY "mbl32o4cgdefagdbgafde"
                printScore
                placeBomb
                gameState = statePlaceBomb
            END IF
        CASE stateCountDown
            IF boom.row = hero.row AND boom.col = hero.col THEN
                hero.score = hero.score + boom.counter
                PLAY "mbl32o5abgfegdfb"
                printScore
                placeBomb
                gameState = statePlaceBomb
            ELSEIF updateBomb = 0 THEN
                PLAY "mbl64o1bagfedcbagfedc"
                gameState = stateExploding
            END IF
        CASE stateExploding
            IF updateParticles = 0 THEN
                hero.lives = hero.lives - 1
                IF hero.lives = 0 THEN
                    gameState = stateGameOver
                ELSE
                    printScore
                    placeBomb
                    gameState = statePlaceBomb
                END IF
            END IF
        CASE ELSE
    END SELECT
LOOP UNTIL gameState = stateGameOver

hero.lives = 0
LOCATE hero.row, hero.col
PRINT " ";
LOCATE villain.row, villain.col
PRINT " ";

printScore
time! = TIMER
DO
    a$ = INKEY$
LOOP UNTIL TIMER > time! + 1
DO: LOOP UNTIL INKEY$ <> ""

COLOR 7: CLS
PRINT "Thanks for playing EXPORMD-2!"

DATA 4,4,4,4,6,6,6,6
DATA 6,6,6,6,12,12,12,12
DATA 12,12,14,14,14,14,14,14
DATA 14,14,15,15,15,15,15,15


SUB placeBomb

    row = INT(RND * 17) + 7
    col = INT(RND * 80) + 1

    boom.row = row
    boom.col = col
    boom.counter = 99

    villain.row = INT(RND * 17) + 7
    villain.col = 1

    FOR i = 0 TO numParticles
        particles(i).life = INT(RND * 20) + 12
        particles(i).chr = MID$(particleChr$, INT(RND * 8) + 1, 1)
        particles(i).row = row
        particles(i).col = col
        particles(i).vRow = RND * 2 - 1
        particles(i).vCol = RND * 2 - 1
    NEXT i

END SUB

SUB printBomb

    LOCATE boom.row, boom.col
    IF boom.counter MOD 4 < 2 THEN
        COLOR 12
    ELSE
        COLOR 4
    END IF
    PRINT LTRIM$(STR$(INT(boom.counter / 10)));

END SUB

SUB printHero

    
    LOCATE hero.row, hero.col
    IF gameState = stateExploding THEN
        COLOR 19
    ELSE
        COLOR 11
    END IF
    PRINT CHR$(2);

END SUB

SUB printIntro

    COLOR 10
    LOCATE 8, 36: PRINT "EXPORMD-2"
    COLOR 13
    LOCATE 10, 22: PRINT "-- Explosieven Opruimingsdienst 2 --"

    COLOR 7
    LOCATE 12, 10: PRINT "A gang of crazy bombers is taking over the city! During the"
    LOCATE 13, 10: PRINT "night gang members are placing bombs all over town to blow"
    LOCATE 14, 10: PRINT "it up and cause as much chaos as they can in an effort to"
    LOCATE 15, 10: PRINT "take control of the city and it's vast wealth."
    LOCATE 17, 10: PRINT "You are the best trained agent of the bomb squad and tasked"
    LOCATE 18, 10: PRINT "with capturing the gang members and defusing their bombs."
    LOCATE 20, 10: PRINT "Good luck!"

    COLOR 8
    LOCATE 24, 1: PRINT "A Qbasic game by Dhr. Baksteen in 2017";
    LOCATE 25, 1: PRINT "In loving memory of the second Qbasic game I ever wrote in 1997...";

END SUB

SUB printParticles
  
    CONST particleChr$ = "ъщщ**мни#ю"

    FOR i = 0 TO numParticles - 1
        IF particles(i).life > 0 THEN
            r = INT(particles(i).row)
            c = INT(particles(i).col)
            LOCATE r, c
            COLOR colors(particles(i).life)
            PRINT MID$(particleChr$, INT(particles(i).life / 4) + 1, 1);
        END IF
    NEXT i

END SUB

SUB printScore

    LOCATE 25, 1
    PRINT STRING$(80, " ");
                          
    IF gameState <> stateGameOver THEN
        LOCATE 25, 3
        COLOR 7
        PRINT "Lives: ";
        COLOR 12
        PRINT STRING$(hero.lives, "ю");
        PRINT "      ";
        
        LOCATE 25, 23
        COLOR 7
        PRINT "Score:";
        IF hero.lives > 0 THEN COLOR 11 ELSE COLOR 27
        PRINT USING "###,###"; hero.score;

        LOCATE 25, 50
        COLOR 8
        PRINT "EXPORMD-2 by Dhr. Baksteen 2017";
    ELSE
        LOCATE 12, 31
        COLOR 26
        PRINT "*** GAME  OVER ***";

        LOCATE 14, 30
        COLOR 7
        PRINT "Final score: ";
        COLOR 11
        PRINT USING "###,###"; hero.score;
    END IF

    COLOR 7, 0

END SUB

SUB printSky

    CLS
    LOCATE 1, 1
    FOR i = 1 TO 6
        COLOR 0, 1
        PRINT STRING$(80, " ");
    NEXT i

    stars$ = "ъщ.*"
    FOR i = 0 TO 40
        LOCATE INT(RND * 4) + 1, INT(RND * 80) + 1
        IF RND > .5 THEN COLOR 7, 1 ELSE COLOR 15, 1
        PRINT MID$(stars$, INT(RND * 4) + 1, 1);
    NEXT i

    DIM winColors(3)
    winColors(0) = 8
    winColors(1) = 14
    winColors(2) = 11

    col = INT(RND * 4) + 1
    WHILE col < 80
        w = INT(RND * 4) + 4
        IF col + w > 80 THEN w = 81 - col
        h = INT(RND * 4) + 1

        FOR r = 6 - h TO 6
            LOCATE r, col
            COLOR 0, 0
            PRINT STRING$(w, " ");

            IF r > 6 - h THEN
                FOR c = col + 1 TO col + w - 2
                    LOCATE r, c
                    COLOR winColors(INT(RND * 2))
                    PRINT "ю";
                NEXT c
            END IF
        NEXT r

        col = col + w + INT(RND * 3)
    WEND

    COLOR 7, 0

END SUB

SUB printVillain

    LOCATE villain.row, villain.col
    COLOR 2
    PRINT CHR$(1);

END SUB

FUNCTION updateBomb

    IF boom.counter MOD 10 = 9 THEN
        PLAY "mbl32o6a"
    END IF

    boom.counter = boom.counter - 1
    updateBomb = boom.counter

END FUNCTION

SUB updateHero (dRow, dCol)

    IF gameState = stateExploding THEN EXIT SUB

    IF dRow <> 0 AND hero.row + dRow > 6 AND hero.row + dRow < 25 THEN
        LOCATE hero.row, hero.col
        PRINT " ";
        hero.row = hero.row + dRow
        EXIT SUB
    END IF

    IF dCol <> 0 AND hero.col + dCol > 0 AND hero.col + dCol < 81 THEN
        LOCATE hero.row, hero.col
        PRINT " ";
        hero.col = hero.col + dCol
    END IF

END SUB

FUNCTION updateParticles

    alive = 0
    FOR i = 0 TO numParticles - 1
        IF particles(i).life > 0 THEN
            r1 = INT(particles(i).row)
            c1 = INT(particles(i).col)

            particles(i).life = particles(i).life - 1
            particles(i).row = particles(i).row + particles(i).vRow
            particles(i).col = particles(i).col + particles(i).vCol
            particles(i).vRow = particles(i).vRow + .1

            r2 = INT(particles(i).row)
            c2 = INT(particles(i).col)

            IF r1 <> r2 OR c1 <> c2 OR particles(i).life = 0 THEN
                LOCATE r1, c1: PRINT " ";
                IF r2 < 7 OR r2 > 24 OR c2 < 1 OR c2 > 80 THEN
                    particles(i).life = 0
                END IF
            END IF
        END IF

        alive = alive + particles(i).life
    NEXT i

    updateParticles = alive

END FUNCTION

FUNCTION updateVillain

    updateVillain = 0
    oldRow = villain.row
    oldCol = villain.col

    hasAction = 0
    DO
        a = INT(RND * 6)
        IF a < 4 AND villain.col < boom.col THEN
            villain.col = villain.col + 1
            hasAction = 1
        ELSEIF a = 4 AND villain.row < boom.row THEN
            villain.row = villain.row + 1
            hasAction = 1
        ELSEIF a = 5 AND villain.row > boom.row THEN
            villain.row = villain.row - 1
            hasAction = 1
        END IF
    LOOP UNTIL hasAction = 1
   
    IF oldRow <> villain.row OR oldCol <> villain.col THEN
        LOCATE oldRow, oldCol
        PRINT " ";
    END IF

    IF villain.row = boom.row AND villain.col = boom.col THEN
        updateVillain = 1
    END IF

END FUNCTION

