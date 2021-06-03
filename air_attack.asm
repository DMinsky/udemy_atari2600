	processor 6502
	include "vcs.h"
	include "macro.h"

PlayerHeight = 9

	seg.u variables
	org $80
PlayerXPos	byte
PlayerYPos	byte
EnemyXPos	byte
EnemyYPos	byte

	seg code
	org $F000

Start:
	CLEAN_START
	sei
	cld
	ldx #$FF
	txs

Init:
	lda #60
	sta PlayerXPos 
	lda #10
	sta PlayerYPos
	lda #40
	sta EnemyXPos
	lda #70
	sta EnemyYPos

Frame:
	lda #2
	sta VSYNC
	sta VBLANK
	REPEAT 3
		sta WSYNC
	REPEND
	lda #0
	sta VSYNC

	lda #$AD
	sta COLUBK
	lda #$C6
	sta COLUPF

	lda #%11111111
	sta PF0
	lda #%11110000
	sta PF1

	lda #%00000001
	sta CTRLPF

	REPEAT 37
		sta WSYNC
	REPEND
	sta VBLANK

	ldx #96
Line:
CheckPlayer:
	txa
	sec
	sbc PlayerYPos
	cmp PlayerHeight
	bcc DrawPlayer
	lda #0

DrawPlayer:
	tay
	lda PlayerSpriteNormal,Y
	sta GRP0
	lda PlayerSpriteNormalColor,Y
	sta COLUP0
	sta WSYNC

CheckEnemy:
	txa
	sec
	sbc EnemyYPos
	cmp PlayerHeight
	bcc DrawEnemy
	lda #0

DrawEnemy:
	tay
	lda EnemySprite,Y
	sta GRP1
	lda EnemySpriteColor,Y
	sta COLUP1
	sta WSYNC

	dex
	bne Line

	lda #2
	sta VBLANK
	REPEAT 30
		sta WSYNC
	REPEND
	jmp Frame

	org #$FFB4
PlayerSpriteNormal:
        .byte #%00000000;$00
        .byte #%01000100;$1E  
        .byte #%11111110;$02
        .byte #%01111100;$02
        .byte #%00111000;$02
        .byte #%00111000;$AE
        .byte #%00010000;$AC
        .byte #%00010000;$F0

PlayerSpriteNormalColor:
        .byte #$00;
        .byte #$1E;
        .byte #$02;
        .byte #$02;
        .byte #$02;
        .byte #$AE;
        .byte #$AE;
        .byte #$02;

PlayerSpriteTilt:
        .byte #%00000000;$00
        .byte #%00101000;$1E
        .byte #%01111100;$02
        .byte #%00111000;$02
        .byte #%00111000;$02
        .byte #%00010000;$AE
        .byte #%00010000;$AC
        .byte #%00010000;$F0
        .byte #%00000000;$F8

PlayerSpriteTiltColor:
        .byte #$00;
        .byte #$1E;
        .byte #$02;
        .byte #$02;
        .byte #$02;
        .byte #$AE;
        .byte #$AC;
        .byte #$F0;

EnemySprite:
        .byte #%00000000;$00
        .byte #%01000100;$42
        .byte #%11111110;$02
        .byte #%11111110;$02
        .byte #%00111000;$02
        .byte #%00101000;$42
        .byte #%01111100;$02
        .byte #%00010000;$40
        .byte #%00000000;$40

EnemySpriteColor
        .byte #$00;
        .byte #$42;
        .byte #$02;
        .byte #$02;
        .byte #$02;
        .byte #$42;
        .byte #$02;
        .byte #$40;


EndOfSprites:

	org $FFFC
	word Start
	word Start
