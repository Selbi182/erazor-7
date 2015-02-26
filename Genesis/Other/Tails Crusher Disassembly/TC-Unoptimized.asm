; ===========================================================================
; /-------------------------------------------------------------------------\
; |   This file has been generated by The Interactive Disassembler (IDA)    |
; |          Copyright (C) 2009 by Hex-Rays <support@hex-rays.com>          |
; |                      License info: 39-E8D8-67EC-B8                      |
; |                                  Selbi                                  |
; |-------------------------------------------------------------------------|
; |                                                                         |
; | Processor:                 68000                                        |
; | Target Assembler:          680x0 Assembler in MRI compatible mode       |
; | Should be compiled with:   as -M                                        |
; |                                                                         |
; |-------------------------------------------------------------------------|
; |  I'm not gonna list everything twice, so just at the INFO.txt file for  |
; |            some useful information (ok, not really useful).             |
; |                                                                         |
; |  Just a quick thing, you should remember: The offsets you see here are  |
; |    taken from the original ROM. It could be that they are not at the    |
; |  proper position anymore. (Shouldn't be too much of a problem though).  |
; \-------------------------------------------------------------------------/
; ===========================================================================

StartOfRom:	dc.l $FFFE00,    EntryPoint, ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l Run_HBlank, ErrorTrap,  Run_VBlank, ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
		dc.l ErrorTrap,	 ErrorTrap,  ErrorTrap,  ErrorTrap
ConsoleName:	dc.b 'SEGA MEGA DRIVE '						; Hardware system ID	(Text length: 16)
ProductName:	dc.b '(C)CYAN 2002.NOV'						; Release date		(Text length: 16)
ProductTitle:	dc.b 'TAILS',$27,' FUN NUMERACY ADVENTURE                   '	; Domestic name 	(Text length: 48)
InterTitle:	dc.b 'TAILS',$27,' FUN NUMERACY ADVENTURE                   '	; International name 	(Text length: 48)
Serial:		dc.b 'Al XXXXXXXX-XX'						; Serial number 	(Text length: 14)
Checksum:	dc.w $2546							; Checksum (unused)
IOS:		dc.b 'J               '						; I/O support 		(Text length: 16)
Rom_Start:	dc.l StartOfRom							; ROM start
Rom_End:	dc.l EndOfROM							; ROM end
RAM_Start:	dc.l $FF0000							; RAM start
RAM_End:	dc.l $FFFFFFFF							; RAM end
SRAM_Support:	dc.l $20202020							; SRAM support
SRAM_Start	dc.l $20202020							; SRAM start
SRAM_End:	dc.l $20202020							; SRAM end
Notes:		dc.b '            la la la...stalling for time...         '	; Notes 		(Text length: 52)
Regions:	dc.b 'JUE             '						; Region(s) 		(Text length: 16)

; ===========================================================================
; ---------------------------------------------------------------------------
; If the games runs into an error, it will be trapped in this subroutine and
; will never be free again (think of a prison).
; ---------------------------------------------------------------------------

ErrorTrap:						; Offset: $0200
		nop				; do nothing
		nop				; do more nothing
		rte				; return on exception
; End of function ErrorTrap

; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------
; Main game programming and entry point at the same time (proves how small
; this ROM is).
; ---------------------------------------------------------------------------

EntryPoint:						; Offset: $0206
		move	#$2700,sr
		tst.l	($A10008).l		; test port A control
		bne.s	PortA_Ok
		tst.w	($A1000C).l		; test port C control

PortA_Ok:
		bne.s	PortC_Ok
		lea	SetupValues(pc),a5	; manually fixed by adding the (pc)
		movem.w	(a5)+,d5-d7
		movem.l	(a5)+,a0-a4
		move.b	-$10FF(a1),d0		; get hardware version
		andi.b	#$F,d0
		beq.s	SkipSecurity
		move.l	#'SEGA',$2F00(a1)

SkipSecurity:
		move.w	(a4),d0			; check	if VDP works
		moveq	#0,d0
		movea.l	d0,a6
		move.l	a6,usp			; manually fixed by adding the .l
		moveq	#$17,d1

VDPInitLoop:
		move.b	(a5)+,d5		; add $8000 to value
		move.w	d5,(a4)			; move value to	VDP register
		add.w	d7,d5			; next register
		dbf	d1,VDPInitLoop
		move.l	(a5)+,(a4)
		move.w	d0,(a3)			; clear	the screen
		move.w	d7,(a1)			; stop the Z80
		move.w	d7,(a2)			; reset	the Z80

WaitForZ80:
		btst	d0,(a1)			; has the Z80 stopped?
		bne.s	WaitForZ80		; if not, branch
		moveq	#$25,d2

Z80InitLoop:
		move.b	(a5)+,(a0)+
		dbf	d2,Z80InitLoop
		move.w	d0,(a2)
		move.w	d0,(a1)			; start	the Z80
		move.w	d7,(a2)			; reset	the Z80

ClrRAMLoop:
		move.l	d0,-(a6)
		dbf	d6,ClrRAMLoop		; clear	the entire RAM
		move.l	(a5)+,(a4)		; set VDP display mode and increment
		move.l	(a5)+,(a4)		; set VDP to CRAM write
		moveq	#$1F,d3

ClrCRAMLoop:
		move.l	d0,(a3)
		dbf	d3,ClrCRAMLoop		; clear	the CRAM
		move.l	(a5)+,(a4)
		moveq	#$13,d4

ClrVDPStuff:
		move.l	d0,(a3)
		dbf	d4,ClrVDPStuff
		moveq	#3,d5

PSGInitLoop:
		move.b	(a5)+,$11(a3)		; reset	the PSG
		dbf	d5,PSGInitLoop
		move.w	d0,(a2)
		movem.l	(a6),d0-a6		; clear	all registers
		move	#$2700,sr		; set the sr

PortC_Ok:
		bra.s	GameProgram

; ===========================================================================
; ---------------------------------------------------------------------------
; Setup Values for the system.
; ---------------------------------------------------------------------------

SetupValues:						; Offset: $029A
		dc.w $8000
		dc.w $3FFF
		dc.w $100

		dc.l $A00000			; start	of Z80 RAM
		dc.l $A11100			; Z80 bus request
		dc.l $A11200			; Z80 reset
		dc.l $C00000
		dc.l $C00004			; address for VDP registers

		dc.b $04, $14, $30, $2C		; values for VDP registers
		dc.b $07, $54, $00, $00		; "
		dc.b $00, $00, $00, $00		; "
		dc.b $81, $2B, $00, $01		; "
		dc.b $01, $00, $00, $FF		; "
		dc.b $FF, $00, $00, $80		; "

		dc.l $40000080

		dc.b $AF, $01, $D9, $1F, $11, $27, $00, $21, $26, $00, $F9, $77	; Z80 instructions
		dc.b $ED, $B0, $DD, $E1, $FD, $E1, $ED, $47, $ED, $4F	  	; "
		dc.b $D1, $E1, $F1, $08, $D9, $C1, $D1, $E1, $F1, $F9, $F3  	; "
		dc.b $ED, $56, $36, $E9, $E9	  				; "

		dc.w $8104			; value	for VDP	display	mode
		dc.w $8F01			; value	for VDP	increment
		dc.l $C0000000			; value	for CRAM write mode
		dc.l $40000010

		dc.b $9F, $BF, $DF, $FF		; values for PSG channel volumes
; ---------------------------------------------------------------------------
; ===========================================================================

GameProgram:						; Offset: $0306
		tst.w	($C00004).l
		lea	($FFFE00).l,sp
		move.w	#$100,($A11200).l
		move.w	#$100,($A11100).l
		move.l	#0,d0

loc_328:
		move.w	($A11100).l,d0
		btst	#8,d0
		bne.s	loc_328
		move.b	#$40,($A10009).l
		move.b	#$40,($A1000B).l
		move.b	#$40,($A1000D).l
		move.b	#0,($A10003).l
		move.b	#0,($A10005).l
		move.b	#0,($A10007).l
		move	#$2300,sr
		nop
		nop

; ---------------------------------------------------------------------------
; Main Game Loop
; As you can see, the sequence is getting repeated over and over again.
; When the game is to restart the sequence, it's starting at this point here
; and not at the very beginning.
; ---------------------------------------------------------------------------

MainLoop:
		move.w	#0,d5
		jsr	(PlaySound_2).l
		jsr	(ResetVDP).l
		jsr	(LoadMainArt).l
		move.w	#$A,d5
		jsr	(DelaySystem).l
		move.b	#$40,($A10003).l
		move.w	#1,d5
		jsr	(DelaySystem).l
		btst	#5,($A10003).l		; Is button C pressed?
		seq	d7			; If yes, set d7. This gives an alternate version on the startup. Try it! ;)
		move.w	#1,d5
		jsr	(DelaySystem).l
		move.b	#0,($A10003).l
		move.w	#1,d5
		jsr	(DelaySystem).l
		move.l	#1,d1
		move.l	#4,d0
		move.w	#$8F02,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$A800000,d2
		addi.l	#$1C0000,d2
		move.l	d2,($C00004).l

Loop_LoadNormalPose:
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,Loop_LoadNormalPose

		move.l	#$4033,d1
		move.l	#5,d0
		move.w	#$8F02,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$14000000,d2
		addi.l	#$240000,d2
		move.l	d2,($C00004).l

Loop_LoadEggmanKnuckles:
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,Loop_LoadEggmanKnuckles

		tst.b	d7			; is alternate mode on?
		bne.w	DontLoad3		; if yes, don't load giant 3
		move.l	#7,d0
		subi.l	#$2000,d1

Loop_Load3:
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,Loop_Load3

DontLoad3:
		move.l	#0,d1
		subi.w	#$4E,d1
		move.w	#1,d5
		jsr	(DelaySystem).l
		move.l	#$40000010,($C00004).l
		move.w	d1,($C00000).l
		tst.b	d7			; is alternate mode on?
		beq.w	NoSonicTailsChangePos	; if not, branch (otherwise, move Sonic and Tails a bit upwards)
		move.w	#$3C,($C00000).l
		move.l	#$40000010,($C00004).l

NoSonicTailsChangePos:
		move.w	#$38,d5
		jsr	(DelaySystem).l
		lea	(Pal1_Default).l,a6	; load main palette
		jsr	(DisplayArt).l
		move.l	#$40,d6			; size of palette
		jsr	(Pal_Load).l		; load palette
		move.w	#$8E,d5			; number of frames to wait
		jsr	(DelaySystem).l		; don't do anything $8E frames long

		lea	(Sound2_Crush).l,a5	; load crushing sound
		jsr	(PlaySound).l		; play that sound
		move.w	#$12,d5
		jsr	(DelaySystem).l
		move.l	#$95,d3
		move.w	#4,d0
		move.w	#$8F02,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$A800000,d2
		addi.l	#$1C0000,d2
		move.l	d2,($C00004).l

Loop_SonicLookingUp:
		move.w	d3,($C00000).l
		addq.w	#1,d3
		move.w	d3,($C00000).l
		addq.w	#1,d3
		move.w	d3,($C00000).l
		addq.w	#1,d3
		move.w	d3,($C00000).l
		addq.w	#1,d3
		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,Loop_SonicLookingUp

		move.w	#$40,d5
		jsr	(DelaySystem).l
		jsr	(PlaySound_2).l
		move.l	#$A9,d3
		move.w	#5,d0
		move.w	#$8F02,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$A000000,d2
		addi.l	#$260000,d2
		move.l	d2,($C00004).l

Loop_TailsLookingUp:
		move.w	#0,($C00000).l
		move.w	d3,($C00000).l
		addq.w	#1,d3
		move.w	d3,($C00000).l
		addq.w	#1,d3
		move.w	d3,($C00000).l
		addq.w	#1,d3
		move.w	d3,($C00000).l
		addq.w	#1,d3
		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,Loop_TailsLookingUp

		move.w	#$20,d5
		jsr	(DelaySystem).l
		move.l	#$1A000,d0
		move.l	#$FA,d2			; ground location for the 3
		neg.w	d2
		move.w	#$8F00,($C00004).l
		move.l	#$40000010,($C00004).l

loc_692:
		move.w	#1,d5
		jsr	(DelaySystem).l
		swap	d1
		sub.l	d0,d1
		addi.l	#$4600,d0		; falling speed (doesn't work well though)
		swap	d1
		move.w	d1,($C00000).l
		cmp.w	d2,d1
		bgt.s	loc_692
		move.l	#$6000,d2

Loop_WaitForTing:
		move.w	#1,d5
		jsr	(DelaySystem).l
		swap	d1
		sub.l	d0,d1
		subi.l	#$25000,d0
		swap	d1
		move.w	d1,($C00000).l
		cmp.l	d2,d0			; is time ready to play "ting" sound?
		bgt.s	Loop_WaitForTing	; if not, loop
		andi.w	#$FFF8,d1
		move.w	d1,($C00000).l
		lea	(Sound1_Ting).l,a5	; load "ting" sound (when Sonic looks up)
		jsr	(PlaySound).l		; play that sound
		tst.b	d7			; is alternate mode on?
		bne.w	LoadCyanScreen		; if yes, don't make any gore stuff
		move.l	#$C1,d1
		move.l	#4,d3
		lea	(Pal2_Crushing).l,a6	; load palette 2 (crushing palette) into a6  (For fun: To make the scene look even more creapier, comment out this line.)
		move.l	#5,d4

loc_70C:
		tst.w	d3
		bne.s	loc_712
		subq.w	#2,d4

loc_712:
		move.w	d4,d5
		jsr	(DelaySystem).l
		move.l	#5,d0
		move.w	#$8F02,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$A800000,d2
		addi.l	#$1C0000,d2
		move.l	d2,($C00004).l

Loop_LoadBlood1:
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,Loop_LoadBlood1

		addi.l	#$6000,d1
		move.l	#5,d0
		move.w	#$8F02,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$18800000,d2
		addi.l	#$1C0000,d2
		move.l	d2,($C00004).l

Loop_LoadBlood2:
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,Loop_LoadBlood2

		subi.l	#$6000,d1
		jsr	(DumpPalRestore).l
		dbf	d3,loc_70C

		move.l	#$2F,d3
		move.l	#4,d4
		addi.l	#$2000,d1

Loop_LoadDrippingBlood:
		move.w	#$8F80,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$19800000,d2
		addi.l	#$1C0000,d2
		move.l	d2,($C00004).l
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d1,($C00000).l
		addq.w	#1,d1
		move.w	d4,d5
		jsr	(DelaySystem).l
		swap	d4
		addi.l	#$B00,d4
		swap	d4
		move.w	d3,d2
		andi.w	#3,d2
		tst.b	d2
		bne.s	loc_916
		subi.w	#$C,d1

loc_916:
		dbf	d3,Loop_LoadDrippingBlood

		move.w	#$8F02,($C00004).l
		suba.l	#$80,a6
		move.l	#1,d6
		jsr	(Pal_FadeOut).l		; fade out palette
		lea	(Pal3_FadeOut).l,a6	; fade out Sonic/Tails first, then Eggman/Knuckles/3
		move.l	#0,d6
		jsr	(Pal_FadeOut).l
		bra.s	NoFadeOut

; ===========================================================================
; ---------------------------------------------------------------------------
; Load the Cyan screen after the main sequence is over.
; ---------------------------------------------------------------------------

LoadCyanScreen:						; Offset: $094C
		move.w	#$10,d5
		jsr	(DelaySystem).l
		lea	(Pal1_Default).l,a6	; load default palette (probably totally unnecesary since the real palette gets loaded a few lines below)
		move.l	#0,d6
		jsr	(Pal_FadeOut).l

NoFadeOut:
		jsr	(ResetVDP).l
		jsr	(LoadCyanArt).l
		move.l	#1,d1
		move.l	#8,d0
		move.w	#$8F02,($C00004).l
		move.l	#$60000003,d2
		addi.l	#$4800000,d2
		addi.l	#$40000,d2
		move.l	d2,($C00004).l

loc_9A0:
		move.l	#$24,d6

Loop_WriteCyanMaps:
		move.w	d1,($C00000).l
		addq.w	#1,d1
		dbf	d6,Loop_WriteCyanMaps	; Fun fact: The dbf method to write art to VDP was only used here.

		addi.l	#$800000,d2
		move.l	d2,($C00004).l
		dbf	d0,loc_9A0

		move.w	#$8F02,($C00004).l
		addi.l	#$1060000,d2
		move.l	d2,($C00004).l
		move.l	#$1E,d0
		addi.w	#$6000,d1

loc_9E0:
		move.w	d1,($C00000).l
		addq.w	#1,d1
		dbf	d0,loc_9E0

		move.l	#$20,d5
		jsr	(DelaySystem).l
		jsr	(DisplayArt).l
		lea	(Pal4_Cyan1).l,a6	; load Cyan's palette 1. It's jumping between palette 1 and 2.
		move.l	#$40,d6
		jsr	(Pal_Load).l
		jsr	(PlaySound_2).l
		move.l	#$A0,d1			; set time for Cyan screen to be displayed (without Fade In/Out)

Loop_DisplayCyan:
		lea	(Pal5_Cyan2).l,a6
		move.l	#1,d5
		jsr	(DelaySystem).l
		jsr	(DumpPalRestore).l
		lea	(Pal4_Cyan1).l,a6
		move.l	#1,d5
		jsr	(DelaySystem).l
		jsr	(DumpPalRestore).l
		dbf	d1,Loop_DisplayCyan

		lea	(Pal5_Cyan2).l,a6
		move.l	#0,d6
		jsr	(Pal_FadeOut).l
		move.l	#$10,d5
		jsr	(DelaySystem).l
		jsr	(ResetVDP).l
		move.w	#$A0,d5
		jsr	(DelaySystem).l
		jmp	MainLoop		; Loop the entire game. If you'd put an rts in here, the game would just stay black after the Cyan screen.
		jmp	MainLoop		; There are two jmps. Why? Cyan's fault I guess.

; ------------- End of function EntryPoint (and main coding). ---------------
; ===========================================================================


; ===========================================================================
; ------------------------- S U B R O U T I N E S ---------------------------
; ===========================================================================

; ---------------------------------------------------------------------------
; Appears to be the subroutine to play sounds.
; ---------------------------------------------------------------------------

PlaySound:						; Offset: $0A86
		move.l	d0,-(sp)
		jsr	(PlaySound_4).l
		jsr	(PlaySound_3).l
		move.b	#$A4,($A04000).l
		jsr	(PlaySound_3).l
		move.b	#$A,($A04001).l
		jsr	(PlaySound_3).l
		move.b	#$A0,($A04000).l
		jsr	(PlaySound_3).l
		move.b	#$69,($A04001).l
		jsr	(PlaySound_3).l
		move.b	#$28,($A04000).l
		jsr	(PlaySound_3).l
		move.b	#$F0,($A04001).l
		move.l	(sp)+,d0
		rts
; End of function PlaySound
; ===========================================================================

PlaySound_2:						; Offset: $0AE6
		move.l	d0,-(sp)
		jsr	(PlaySound_3).l
		move.b	#$28,($A04000).l
		jsr	(PlaySound_3).l
		move.b	#0,($A04001).l
		jsr	(PlaySound_3).l
		move.l	(sp)+,d0
		rts
; End of function PlaySound_2
; ===========================================================================

PlaySound_3:						; Offset: $0B0E
		nop
		nop
		move.b	($A04000).l,d0
		andi.b	#$80,d0
		tst.b	d0
		bne.s	PlaySound_3
		rts
; End of function PlaySound_3
; ===========================================================================

PlaySound_4:						; Offset: $0B22
		jsr	PlaySound_3
		move.b	#$28,($A04000).l
		jsr	PlaySound_3
		move.b	#0,($A04001).l
		jsr	PlaySound_3
		move.b	#$22,($A04000).l
		jsr	PlaySound_3
		move.b	#0,($A04001).l
		jsr	PlaySound_3
		move.b	#$27,($A04000).l
		jsr	PlaySound_3
		move.b	#0,($A04001).l
		jsr	PlaySound_3
		move.b	#$B0,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.b	#3,d0
		add.b	(a5)+,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$B4,($A04000).l
		jsr	PlaySound_3
		move.b	#$C0,($A04001).l
		jsr	PlaySound_3
		move.b	#$30,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.b	#4,d0
		add.b	(a5)+,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$34,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.b	#4,d0
		add.b	(a5)+,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$38,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.b	#4,d0
		add.b	(a5)+,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$3C,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.b	#4,d0
		add.b	(a5)+,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$40,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		not.b	d0
		andi.b	#$1F,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$44,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		not.b	d0
		andi.b	#$1F,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$48,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		not.b	d0
		andi.b	#$1F,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$4C,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		not.b	d0
		andi.b	#$1F,d0
		move.b	d0,($A04001).l
		jsr	PlaySound_3
		move.b	#$50,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$54,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$58,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$5C,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$60,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$64,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$68,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$6C,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$70,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$74,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$78,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$7C,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,($A04001).l
		jsr	PlaySound_3
		move.b	#$80,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.w	#5,d0
		add.b	(a5)+,d0
		lsr.w	#1,d0
		move.b	d0,($A04001).l
		move.b	#$84,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.w	#5,d0
		add.b	(a5)+,d0
		lsr.w	#1,d0
		move.b	d0,($A04001).l
		move.b	#$88,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.w	#5,d0
		add.b	(a5)+,d0
		lsr.w	#1,d0
		move.b	d0,($A04001).l
		move.b	#$8C,($A04000).l
		jsr	PlaySound_3
		move.b	(a5)+,d0
		lsl.w	#5,d0
		add.b	(a5)+,d0
		lsr.w	#1,d0
		move.b	d0,($A04001).l
		rts
; End of function PlaySound_4

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to dump palettes to C-Ram, but keep the palette location in a6.
; ---------------------------------------------------------------------------

DumpPalRestore:						; Offset: $0DFC
		move.l	d6,-(sp)
		move.w	#$8F02,($C00004).l
		move.l	#$C0000000,($C00004).l
		move.l	#$3F,d6

Loop_E16:
		move.w	(a6)+,($C00000).l
		dbf	d6,Loop_E16

		move.l	(sp)+,d6
		rts
; End of function DumpPalRestore

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load palettes.
; ---------------------------------------------------------------------------

Pal_Load:						; Offset: $0E24
		move.l	d0,-(sp)
		move.l	a0,-(sp)
		move.l	a1,-(sp)
		move.l	d1,-(sp)
		move.l	d2,-(sp)
		move.l	d3,-(sp)
		movea.l	#$FF0000,a0
		move.l	#$1F,d0

Loop_E3C:
		move.l	#0,(a0)+
		dbf	d0,Loop_E3C

		move.l	#7,d3
		subq.l	#1,d6

Loop_E4E:
		move.l	d6,d0
		lea	($FF0000).l,a0
		movea.l	a6,a1

Loop_E58:
		move.b	(a1),d1
		move.b	(a0),d2
		andi.b	#$E,d1
		andi.b	#$E,d2
		cmp.b	d1,d2
		beq.s	loc_E6A
		addq.b	#2,(a0)

loc_E6A:
		adda.l	#1,a0
		adda.l	#1,a1
		move.b	(a1),d1
		move.b	(a0),d2
		andi.b	#$E0,d1
		andi.b	#$E0,d2
		cmp.b	d1,d2
		beq.s	loc_E8A
		addi.b	#$20,(a0)

loc_E8A:
		move.b	(a1),d1
		move.b	(a0),d2
		andi.b	#$E,d1
		andi.b	#$E,d2
		cmp.b	d1,d2
		beq.s	loc_E9C
		addq.b	#2,(a0)

loc_E9C:
		adda.l	#1,a0
		adda.l	#1,a1
		dbf	d0,Loop_E58

		move.w	#5,d5
		jsr	(DelaySystem).l
		move.l	a6,-(sp)
		lea	($FF0000).l,a6
		move.l	d6,-(sp)
		move.w	#$8F02,($C00004).l
		move.l	#$C0000000,($C00004).l

Loop_ED2:
		move.w	(a6)+,($C00000).l
		dbf	d6,Loop_ED2

		move.l	(sp)+,d6
		movea.l	(sp)+,a6
		dbf	d3,Loop_E4E

		move.l	(sp)+,d3
		move.l	(sp)+,d2
		move.l	(sp)+,d1
		movea.l	(sp)+,a1
		movea.l	(sp)+,a0
		move.l	(sp)+,d0
		addq.l	#1,d6
		rts
; End of function Pal_Load

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to fade out the palette.
; ---------------------------------------------------------------------------

Pal_FadeOut:						; Offset: $0EF4
		move.l	d0,-(sp)
		move.l	a0,-(sp)
		move.l	a1,-(sp)
		move.l	d1,-(sp)
		move.l	d2,-(sp)
		move.l	d3,-(sp)
		movea.l	#$FF0000,a0
		move.l	#$1F,d0

Loop_F0C:
		move.l	(a6)+,(a0)+
		dbf	d0,Loop_F0C

		move.l	#7,d3

Loop_F18:
		move.l	#$3F,d0
		lea	($FF0000).l,a0
		movea.l	a6,a1

Loop_F26:
		tst.l	d6
		beq.s	loc_F3E
		cmpi.l	#$20,d0
		bne.s	loc_F3E
		subi.l	#$10,d0
		adda.l	#$20,a0

loc_F3E:
		move.b	(a0),d2
		andi.b	#$E,d2
		tst.b	d2
		beq.s	loc_F4A
		subq.b	#2,(a0)

loc_F4A:
		adda.l	#1,a0
		move.b	(a0),d2
		andi.b	#$E0,d2
		tst.b	d2
		beq.s	loc_F5E
		subi.b	#$20,(a0)

loc_F5E:
		move.b	(a0),d2
		andi.b	#$E,d2
		tst.b	d2
		beq.s	loc_F6A
		subq.b	#2,(a0)

loc_F6A:
		adda.l	#1,a0
		dbf	d0,Loop_F26

		move.w	#4,d5
		jsr	(DelaySystem).l
		move.l	a6,-(sp)
		lea	($FF0000).l,a6
		jsr	DumpPalRestore
		movea.l	(sp)+,a6
		dbf	d3,Loop_F18

		move.l	(sp)+,d3
		move.l	(sp)+,d2
		move.l	(sp)+,d1
		movea.l	(sp)+,a1
		movea.l	(sp)+,a0
		move.l	(sp)+,d0
		rts
; End of function Pal_FadeOut

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to setup VDP registers, clearing V-RAM, clearing C-RAM and
; clearing VS-RAM.
; ---------------------------------------------------------------------------

ResetVDP:						; Offset: $0F9E
		move.w	#$8124,($C00004).l
		move.w	#$8004,($C00004).l
		move.w	#$8700,($C00004).l
		move.w	#$8800,($C00004).l
		move.w	#$8900,($C00004).l
		move.w	#$8A00,($C00004).l
		move.w	#$8B02,($C00004).l
		move.w	#$8C81,($C00004).l
		move.w	#$9011,($C00004).l
		move.w	#$8F02,($C00004).l
		move.w	#$9100,($C00004).l
		move.w	#$8238,($C00004).l
		move.w	#$8407,($C00004).l
		move.w	#$8300,($C00004).l
		move.w	#$856E,($C00004).l
		move.w	#$8D36,($C00004).l
		move.w	#$8E00,($C00004).l
		move.l	d0,-(sp)
		move.w	#$8F02,($C00004).l
		move.l	#$40000000,($C00004).l
		move.l	#$7FF,d0

Loop_1040:
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		dbf	d0,Loop_1040

		move.l	#$C0000000,($C00004).l
		move.l	#$1F,d0

Loop_10A4:
		move.l	#0,($C00000).l
		dbf	d0,Loop_10A4

		move.l	#$40000010,($C00004).l
		move.l	#$1F,d0

Loop_10C2:
		move.l	#0,($C00000).l
		dbf	d0,Loop_10C2

		move.l	(sp)+,d0
		rts
; End of function ResetVDP

; ===========================================================================
; ---------------------------------------------------------------------------
; Important routine for displaying art (without this, palettes and tiles are
; getting loaded, but not displayed).
; ---------------------------------------------------------------------------

DisplayArt:						; Offset: $10D4
		move.w	#$8164,($C00004).l
		rts
; End of function DisplayArt

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load uncompressed tiles graphics for the main event.
; ---------------------------------------------------------------------------

LoadMainArt:						; Offset: $10DE
		move.l	d0,-(sp)
		move.l	d1,-(sp)
		move.l	a0,-(sp)
		lea	(Art1_Normal).l,a0
		move.l	#$683C,d0
		subi.l	#$1690,d0

loc_10F6:
		lsr.l	#1,d0
		subq.l	#1,d0
		move.w	#$8F02,($C00004).l
		move.l	#$40000000,($C00004).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,($C00000).l
		move.l	#0,d1

Loop_1162:
		move.w	(a0)+,d1
		tst.w	d1
		bne.s	loc_117A
		move.w	(a0)+,d1
		subq.l	#1,d0

Loop_116C:
		move.w	#0,($C00000).l
		dbf	d1,Loop_116C

		bra.s	loc_1180
; ===========================================================================

loc_117A:
		move.w	d1,($C00000).l

loc_1180:
		dbf	d0,Loop_1162

		movea.l	(sp)+,a0
		move.l	(sp)+,d1
		move.l	(sp)+,d0
		rts
; End of function LoadMainArt

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine to load uncompressed tiles graphics for Cyan's screen.
; ---------------------------------------------------------------------------

LoadCyanArt:						; Offset: $118C
		move.l	d0,-(sp)
		move.l	d1,-(sp)
		move.l	a0,-(sp)
		lea	(Art2_Cyan).l,a0
		move.l	#$8588,d0
		subi.l	#$683C,d0
		jmp	loc_10F6
; End of function LoadCyanArt

; ===========================================================================
; ---------------------------------------------------------------------------
; Slow down system (basically, do nothing X frames long (based of the value
; stored in d5 before calling this subroutine)).
; ---------------------------------------------------------------------------

DelaySystem:						; Offset: $11A8
		tst.w	d5		; is d5 empty?
		bne.s	DelaySystem	; if not, loop until it is
		rts			; otherwise return and continue with the code
; End of function DelaySystem

; ---------------------------------------------------------------------------
; Subroutine releated to VBlanking. This routine is also responsible for
; reducing d5 for the system delay.
; ---------------------------------------------------------------------------

Run_VBlank:						; Offset: $11AE
		tst.w	d5		; is d5 empty?
		beq.s	RD_d5Empty	; if yes, branch
		subq.w	#1,d5		; otherwise go on with reducing

RD_d5Empty:						; Offset: $11B4
		tst.w	($C00004).l	; test VDP registers
		rte			; return from exeption
; End of function Run_VBlank

; ===========================================================================
; ---------------------------------------------------------------------------
; Subroutine releated to HBlanking.
; ---------------------------------------------------------------------------

Run_HBlank:						; Offset: $11BC
		tst.w	($C00004).l	; test VDP registers
		nop			; do very...
		nop			; ...very short delays
		rte			; return from exeption
; End of function Run_HBlank
; ===========================================================================


; ===========================================================================
; ---------------------------------------------------------------------------
; Excluding Data (Art, Palettes and Sounds) and Miscellaneous
; ---------------------------------------------------------------------------
; ===========================================================================

; ===========================================================================
; ---------------------------------------------------------------------------
; Palette Data
; ---------------------------------------------------------------------------

Pal1_Default:	incbin	palette\Pal1_Default.bin	; Offset: $11C8
		even
; ---------------------------------------------------------------------------

Pal2_Crushing:	incbin	palette\Pal2_Crushing.bin	; Offset: $1248
		even
; ---------------------------------------------------------------------------

Pal3_FadeOut:	incbin	palette\Pal3_FadeOut.bin	; Offset: $14C8
		even
; ---------------------------------------------------------------------------

Pal4_Cyan1:	incbin	palette\Pal4_Cyan1.bin		; Offset: $1548
		even
; ---------------------------------------------------------------------------

Pal5_Cyan2:	incbin	palette\Pal5_Cyan2.bin		; Offset: $15C8
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Sound Data
; ---------------------------------------------------------------------------

Sound1_Ting:	incbin	sound\Sound1_Ting.bin		; Offset: $1648
		even
; ---------------------------------------------------------------------------

Sound2_Crush:	incbin	sound\Sound2_Crushing.bin	; Offset: $166A
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Art Data (uncompressed)
; ---------------------------------------------------------------------------

Art1_Normal:	incbin	art\Art1_Normal.bin		; Offset: $1690
		even
; ---------------------------------------------------------------------------

Art2_Cyan:	incbin	art\Art2_Cyan.bin		; Offset: $683C
		even

; ===========================================================================
; ---------------------------------------------------------------------------
; Hidden Message by Cyan (Could this be a joke? Try it yourself...)
; Text length: 
; Note: The $27s are apostrophes ('), but as you can see, they are required
;       to start and finish ASCII strings. So they need to be written like
;       this.
; Note 2: Pressing C on startup really works, the other stuff of course not.
;         Or does it? Try it yourself. ;)
; ---------------------------------------------------------------------------

; HiddenMessage:					; Offset: $858C
	dc.b 'Hey hey hey! What are you doing hacking this code? '
	dc.b 'Hmm...anyway. You might like to know about a few things '
	dc.b 'first. This ROM was created by Cyan Helkaraxe '
	dc.b '-- manic@emulationzone.org -- and you shouldn',$27,'t be '
	dc.b 'poking your nose into it! Visit '
	dc.b 'http://www.emulationzone.org/projects/cyan/ '

	dc.b 'Secret functionality: hold down C during bootup to access the '
	dc.b 'Super Secret Special Doctor Mode!     '

	dc.b 'To see the super impressive ultra-o-matic super hyper '
	dc.b 'golden lovely wonderful mode, follow this sequence: hold down '
	dc.b 'A and RIGHT during bootup with the SECOND pad. As soon as the '
	dc.b 'first frame of the fadein occurs, release those buttons and '
	dc.b 'hold C+LEFT Wait exactly one second, then release those '
	dc.b 'buttons and press: B,UP,DOWN,DOWN,RIGHT,A,C,A,B+UP,DOWN+RIGHT, '
	dc.b 'UP+DOWN,LEFT+RIGHT,LEFT+RIGHT+UP+C+A and then press B 12 times '
	dc.b 'rapidly. After that, you must press LEFT+RIGHT+A+B on pad 1, '
	dc.b 'and UP+DOWN+C+A+LEFT on pad 2, at the same time. This entire '
	dc.b 'sequence must be completed in about one and a half seconds. '

	dc.b 'If your pad still works, congratulations! You can access the '
	dc.b 'Super Mode Enhanced by following the above sequence with the '
	dc.b '!M3 pin on the cartridge port connected to the SELECT line of '
	dc.b 'joypad port 2, the select line of joypad port 1 connected to '
	dc.b 'pin 6 of the VDP of a model 2 master system running Sonic 2 in '
	dc.b '50Hz, and the input 2 line of joypad port 2 connected to '
	dc.b 'another Megadrive',$27,'s select line on joypad port 1 with a '
	dc.b 'MegaCD, 32X, Super Magic Drive, two game genies, four action '
	dc.b 'replays, two deregioning carts, and 8 copies of Sonic and '
	dc.b 'Knuckles locked together, with a copy of Art Alive in the top. '

	dc.b 'I am serious, honest... ;)'
	even

; ===========================================================================
; ---------------------------------------------------------------------------
; This line pads up the ROM to $20000 bytes (131072 in decimal) with "$FF"s.
; Fun fact: This single line takes up about 3.5 times more space than the
;           actual coding and the excluding data from the ROM.
; ---------------------------------------------------------------------------

Padding:	dcb.b $20000-Padding,$FF		; Offset: $8BD7-$20000

; ===========================================================================
; ---------------------------------------------------------------------------
EndOfROM:	END					; end of 'ROM'
; ---------------------------------------------------------------------------
; ===========================================================================