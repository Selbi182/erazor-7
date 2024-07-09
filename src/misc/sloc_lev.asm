; ===========================================================================
; ---------------------------------------------------------------------------
; Starting Locations for levels
; ---------------------------------------------------------------------------

		dc.w	$0010, $0020	; GHZ 1
		dc.w	$0000, $0160	; GHZ 2
		dc.w	$2630, $03AC	; GHZ 3
		dc.w	$0080, $00A8	; GHZ 4

		dc.w	$0078, $006E	; LZ 1
		dc.w	$0318, $02AC	; LZ 2
		dc.w	$1C32, $05EC	; LZ 3
		dc.w	$0B80, $0000	; LZ 4 (SBZ 3)

		dc.w	$01AF, $026C	; MZ 1
		dc.w	$009C, $0264	; MZ 2
		dc.w	$004F, $000F	; MZ 3
		dc.w	$0080, $00A8	; MZ 4

		dc.w	$0038, $02CE	; SLZ 1
		dc.w	$0034, $014E	; SLZ 2
		dc.w	$0B00, $046C	; SLZ 3
		dc.w	$0080, $00A8	; SLZ 4

		dc.w	$0280, $0060	; SYZ 1 (Uberhub casual)
		dc.w	$008E, $0010	; SYZ 1 (Uberhub frantic)
		dc.w	$0038, $00EE	; SYZ 3
		dc.w	$0080, $00A8	; SYZ 4

		dc.w	$01A0, $0160	; SBZ 1
		dc.w	$0180, $068C	; SBZ 2 (Tutorial)
		dc.w	$0B86, $05AC	; FZ
		dc.w	$0080, $00A8	; Null

		dc.w	$0620, $016B	; Unknown
		dc.w	$0EE0, $026C	; Ending Sequence
		dc.w	$0080, $00A8	; Null
		dc.w	$0080, $00A8	; Null
		even
; ---------------------------------------------------------------------------
; ===========================================================================