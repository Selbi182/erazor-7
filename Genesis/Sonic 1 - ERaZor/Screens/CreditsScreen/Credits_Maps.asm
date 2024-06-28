; ===========================================================================
; ---------------------------------------------------------------------------
; Scrolling
; ---------------------------------------------------------------------------
;	dc.b	$0D						; Number of lines
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
;	dc.b	"                    ",$FF
; ---------------------------------------------------------------------------

CreditsMaps:

	dc.w	$0100						; time for each section to scroll
	dc.w	$0001						; current timer
	dc.l	$00FF000C					; start address
	dc.l	EndText-StartText				; number of sections

StartText:
	; 1
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"  CREATED AND MAIN  ",$FF
	dc.b	"                    ",$FF
	dc.b	"   PROGRAMMING BY   ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"       SELBI        ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 2
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"WITH MENTORSHIP AND ",$FF
	dc.b	"                    ",$FF
	dc.b	"  EXTRA ASSETS BY   ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"    MARKEYJESTER    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 3
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"  BLAST PROCESSING  ",$FF
	dc.b	"                    ",$FF
	dc.b	"         BY         ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"    VLADIKCOMPER    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 4
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"  PROGRAMMING AND   ",$FF
	dc.b	"                    ",$FF
	dc.b	"  BETA TESTING BY   ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"       FUZZY        ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 5
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	" MAIN MUSIC PORTED  ",$FF
	dc.b	"                    ",$FF
	dc.b	"         BY         ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"     AMPHOBIOUS     ",$FF
	dc.b	"                    ",$FF
	dc.b	"    AKA DALEKSAM    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 6
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"  ADDITIONAL MUSIC  ",$FF
	dc.b	"                    ",$FF
	dc.b	"         BY         ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"       SPANNER      ",$FF
	dc.b	"                    ",$FF
	dc.b	"       EDUARDO      ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 7
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	" MAIN BETA TESTING  ",$FF
	dc.b	"                    ",$FF
	dc.b	"         BY         ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"     NEONSYNTH      ",$FF
	dc.b	"                    ",$FF
	dc.b	"   AKA SONICVAAN    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	
	; 8
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"     ADDITIONAL     ",$FF
	dc.b	"                    ",$FF
	dc.b	"  BETA TESTING BY   ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"       AJCOX        ",$FF
	dc.b	"                    ",$FF
	dc.b	"   PEANUT NOCEDA    ",$FF
	dc.b	"                    ",$FF
	dc.b	"        GIVE        ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 9
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"   REAL HARDWARE    ",$FF
	dc.b	"                    ",$FF
	dc.b	"     TESTING BY     ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"     SONICFAN[      ",$FF
	dc.b	"                    ",$FF
	dc.b	"    REDHOTSONIC     ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 10
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"   SPECIAL THANKS   ",$FF
	dc.b	"                    ",$FF
	dc.b	"         TO         ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"     MAINMEMORY     ",$FF
	dc.b	"                    ",$FF
	dc.b	"       JORGE        ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 11
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"   ORIGINAL GAME    ",$FF
	dc.b	"                    ",$FF
	dc.b	"         BY         ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"     SONIC TEAM     ",$FF
	dc.b	"                    ",$FF
	dc.b	"        SEGA        ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

	; 12
	dc.b	$0D						; Number of lines
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"     THANK YOU      ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"    FOR PLAYING     ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF
	dc.b	"                    ",$FF

EndText:

; ---------------------------------------------------------------------------
; ===========================================================================