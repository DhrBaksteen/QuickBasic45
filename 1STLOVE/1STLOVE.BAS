DEFINT A-Z
DECLARE SUB loadImage ()
DECLARE SUB setDisplayRegion (startLine, endLine)
DECLARE SUB setVScroll (vOffset)

CONST seqIndex = &H3C4
CONST seqData = &H3C5
CONST dacAddress = &H3C8
CONST dacData = &H3C9
CONST crtcIndex = &H3D4
CONST crtcData = &H3D5
CONST crtcStatus = &H3DA

CONST seqRegPlane = &H2
CONST crtcRegOverflow = &H7
CONST crtcRegPresetRowScan = &H8
CONST crtcRegMaxScanLine = &H9
CONST crtcRegStartAddrHigh = &HC
CONST crtcRegStartAddrLow = &HD
CONST crtcRegVBlankStart = &H15
CONST crtcRegVBlankEnd = &H16

CONST planeBlue = &H1
CONST planeGreen = &H2
CONST planeRed = &H4
CONST planeIntensity = &H8
CONST crtcStatusVRetrace = &H8
CONST bmpSegment = &HA000


SCREEN 12
setDisplayRegion 32, 191
loadImage

t! = 0

DO
    vOffset = INT(SIN(t!) * 200) + 200
    t! = t! + .01
    setVScroll vOffset
LOOP UNTIL INKEY$ <> ""

SCREEN 0
PRINT "'First Love' by Boris Vallejo in 640x819, 16 colors on SCREEN 12"
PRINT "A QuickBASIC demo like effect done by Maarten Janssen"
PRINT "For my first love, my awesome 386 machine on 2022-10-15"
PRINT

SUB loadImage

    ' Hide everything!
    FOR i = 0 TO 15
        PALETTE i, 0
    NEXT i

    ' Load the 4 image bitplanes.
    FOR i = 0 TO 3
        OUT seqIndex, seqRegPlane
        OUT seqData, 2 ^ i
        BLOAD "1stlove.bp" + LTRIM$(STR$(i))
    NEXT i

    ' Load the palette.
    OPEN "1stlove.pal" FOR BINARY AS #1
    OUT dacAddress, 0
    FOR i = 0 TO 15
        r = ASC(INPUT$(1, 1)) \ 4
        g = ASC(INPUT$(1, 1)) \ 4
        b = ASC(INPUT$(1, 1)) \ 4
        OUT dacData, r
        OUT dacData, g
        OUT dacData, b
    NEXT i

END SUB

' Set the visible region of the display by altering the start and end
' scanlines of the VBlank period.
'
' startScanline - Display start scanline 0 - 255
' endLine - Display end line 0 - 223
SUB setDisplayRegion (startLine, endLine)

    OUT crtcIndex, crtcRegVBlankEnd
    OUT crtcData, startLine

    OUT crtcIndex, crtcRegVBlankStart
    OUT crtcData, endLine AND &HFF

END SUB

SUB setVScroll (vOffset)

    ' Set display address offset for coarse scrolling.
    OUT crtcIndex, crtcRegStartAddrHigh
    OUT crtcData, (vOffset \ 16) * 5
    OUT crtcIndex, crtcRegStartAddrLow
    OUT crtcData, 0

    ' Wait for vertical retrace to prevent glitches when setting
    ' presetScanRow register.
    WAIT crtcStatus, crtcStatusVRetrace
    WAIT crtcStatus, crtcStatusVRetrace, crtcStatusVRetrace

    ' Set presetScanRow for fine scrolling.
    OUT crtcIndex, crtcRegPresetRowScan
    OUT crtcData, (vOffset AND 15) + 1

END SUB

