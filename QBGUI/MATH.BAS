DEFINT A-Z
DECLARE FUNCTION Math.min (a, b)
DECLARE FUNCTION Math.max (a, b)

FUNCTION Math.max (a, b)

    IF a > b THEN
        Math.max = a
    ELSE
        Math.max = b
    END IF

END FUNCTION

FUNCTION Math.min (a, b)

    IF a < b THEN
        Math.min = a
    ELSE
        Math.min = b
    END IF

END FUNCTION

