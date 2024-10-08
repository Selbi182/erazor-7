; ===========================================================================
; ---------------------------------------------------------------------------
; Background effect used in various screens
; ---------------------------------------------------------------------------

; must be called once during game mode init
BackgroundEffects_Setup:
		VBlank_SetMusicOnly
		move.w	#$8B03,($C00004).l	; set scrolling mode to H: per-scanline // V: whole screen

		lea	VDP_Data, a6
		vram	$C000, 4(a6)		; set VDP to VRAM and start at C000 (location of Plane A nametable)

		move.l	#$00020002, d6
		moveq	#$40*$20/$80-1, d1	; cover the entire 512x256 pixel plane (64x32 tiles, 128 tile steps)

		@send128Tiles:
			move.l	#$00010002, d5
			rept	$80/2
				move.l	d5, (a6)
				add.l	d6, d5
			endr
			dbf	d1, @send128Tiles		; repeat til columns have dumped

		vram	$20, 4(a6)
		lea	BGEffects_FuzzArt, a0
		jsr	KosPlusMDec_VRAM

		VBlank_UnsetMusicOnly
		rts

; ---------------------------------------------------------------------------

; must called every frame from the respective game mode's main loop
BackgroundEffects_Update:
		move.l	a2,-(sp)
		bsr	BackgroundEffects_PalCycle
		bsr	BackgroundEffects_Deformation
		bsr	BackgroundEffects_VScroll
		move.l	(sp)+,a2
		rts
; ===========================================================================

; Background palette rotation
BackgroundEffects_PalCycle:
		moveq	#3, d0
		and.w	($FFFFFE0E).w,d0	; get V-blank timer (AND $3)
		bne.w	@bgpalend

		moveq	#0,d0
		move.l	#BG_Mask_Colors,d2
		movea.l	d2,a1

		lea	($FFFFFB02).w,a2
		moveq	#10-1,d6	; 10 colors
@bgpalcycle:
		move.w	BGThemeColor,d0 ; get theme color
		move.w	(a1)+,d1	; get mask color
		bpl.s	@dolimit
		movea.l	d2,a1		; reset cycle location
		bra.s	@bgpalcycle
@dolimit:
		moveq	#0,d3		; limited color
		
		move.w	d1,d4		; copy mask color
		andi.w	#$00E,d4	; limit mask color
		move.w	d0,d5		; copy theme color
		andi.w	#$00E,d5
		cmp.w	d5,d4
		bls.s	@0
		move.w	d5,d4
@0		or.w	d4,d3

		move.w	d1,d4		; copy mask color
		andi.w	#$0E0,d4	; limit mask color
		move.w	d0,d5		; copy theme color
		andi.w	#$0E0,d5
		cmp.w	d5,d4
		bls.s	@1
		move.w	d5,d4
@1		or.w	d4,d3

		move.w	d1,d4		; copy mask color
		andi.w	#$E00,d4	; limit mask color
		move.w	d0,d5		; copy theme color
		andi.w	#$E00,d5
		cmp.w	d5,d4
		bls.s	@2
		move.w	d5,d4
@2		or.w	d4,d3

		move.w	d3,(a2)+
		dbf	d6,@bgpalcycle
@bgpalend:
		rts
; ---------------------------------------------------------------------------
BG_Mask_Colors:
		dc.w	$000
		dc.w	$000
		dc.w	$222
		dc.w	$222
		dc.w	$444
		dc.w	$666
		dc.w	$888
		dc.w	$AAA
		dc.w	$CCC
		dc.w	$CCC
		dc.w	$EEE
		dc.w	$EEE
		dc.w	  -1
		even
; ---------------------------------------------------------------------------

; Background deformation (the main effect)
BackgroundEffects_Deformation:
		moveq	#0,d0
	
BackgroundEffects_Deformation2:
		move.l	d7,-(sp)
		moveq	#0,d7
		move.w	($FFFFFE0E).w,d6	; get timer
		tst.b	d0
		beq.s	@noadjust
		move.w	d0,d7
@noadjust:
		lea	($FFFFCC00).w,a1
		move.w	#224-1,d3
		jsr	RandomNumber
@scroll:
		ror.l	#1,d1
		move.l	d1,d2
		andi.l	#$001F0000,d2
		
		moveq	#0,d0
		moveq	#0,d4
		move.w	d6,d0	; get timer
		swap	d0
		btst	#0,d3
		beq.s	@1
		neg.l	d0
@1:
		swap	d0
		clr.w	d0
		add.w	d6,d0 ; scroll everything to the right
		btst	#0,d5
		beq.s	@3
		sub.w	d6,d0 ; scroll everything to the left
@3:
		move.w	d0,d4		; copy scroll
		add.w	d3,d4		; add line index
		subi.w	#224/2,d4
		movem.l	d0/d1,-(sp)
		move.w	d4,d0
		jsr	CalcSine
		
		move.w	d3,d5
		add.w	d6,d5
		btst	#7,d5
		beq.s	@2
		neg.w	d0
@2:
		move.w	d0,d4
		
		movem.l	(sp)+,d0/d1
		add.w	d4,d0
		swap	d0
		or.l	d0,d2
		tst.b	d7
		beq.s	@bla
		asr.l	d7,d2
@bla
		clr.w	d2
		swap	d2
		move.w	d2,(a1)+
		addq.w	#2,a1
		dbf	d3,@scroll

		; dirty fix for two lines that are not moving properly otherwise
		move.w	($FFFFCC00+(45*4)).w,($FFFFCC00+(47*4)).w
		move.w	($FFFFCC00+(173*4)).w,($FFFFCC00+(175*4)).w

		move.l	(sp)+,d7
		rts
; ---------------------------------------------------------------------------

; V-Scroll
BackgroundEffects_VScroll:
		move.w	($FFFFFE0E).w,d1
		add.w	d1,d1
		neg.w	d1
		move.w	d1,($FFFFF616).w	; set plane-A VSRAM (yes, not plane B)
		rts
	
; ---------------------------------------------------------------------------
; ===========================================================================
; ---------------------------------------------------------------------------

BGEffects_FuzzArt:
		incbin	Screens\FuzzyBG.kospm
		even

; ---------------------------------------------------------------------------
; ===========================================================================
