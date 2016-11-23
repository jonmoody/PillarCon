  .inesprg 1
  .ineschr 1
  .inesmap 0
  .inesmir 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .bank 0
  .org $C000

RESET:
  SEI
  CLD
  LDX #$40
  STX $4017    ; Disable APU frame IRQ
  LDX #$FF
  TXS
  INX
  STX $2000    ; Disable NMI
  STX $2001    ; Disable rendering
  STX $4010    ; Disable DMC IRQs

VBlankWait1:
  BIT $2002
  BPL VBlankWait1

ClearMemory:
  LDA #$00
  STA $0000, x
  STA $0100, x
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE ClearMemory

VBlankWait2:
  BIT $2002
  BPL VBlankWait2

LoadPalettes:
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
LoadPalettesLoop:
  LDA palette, x
  STA $2007
  INX
  CPX #$20              ; 4 sprites
  BNE LoadPalettesLoop


LoadSprites:
  LDX #$00
LoadSpritesLoop:
  LDA sprites, x
  STA $0200, x
  INX
  CPX #$FF
  BNE LoadSpritesLoop


  LDA #%10010000    ; Enable NMI, sprites from table 0, background from table 1
  STA $2000
  LDA #%00010000    ; Enable sprites, black background
  STA $2001


InfiniteLoop:
  JMP InfiniteLoop

NMI:
  LDA #$00
  STA $2003
  LDA #$02
  STA $4014

  ; Graphics Cleanup
  LDA #%10010000   ; Enable NMI, sprites from table 0, background from table 1
  STA $2000
  LDA #%00010000   ; Enable sprites, black background
  STA $2001
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005

  RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .bank 1
  .org $E000

palette:
  .db $0F,$21,$1D,$1D,  $0F,$21,$1D,$1D,  $0F,$21,$1D,$1D,  $0F,$21,$1D,$1D
  .db $0F,$21,$1D,$1D,  $0F,$21,$1D,$1D,  $0F,$21,$1D,$1D,  $0F,$21,$1D,$1D

sprites:
  .db $20, $50, $00, $20 ; P
  .db $20, $69, $00, $28 ; i
  .db $20, $6C, $00, $30 ; l
  .db $20, $6C, $00, $38 ; l
  .db $20, $61, $00, $40 ; a
  .db $20, $72, $00, $48 ; r
  .db $20, $43, $00, $50 ; C
  .db $20, $6F, $00, $58 ; o
  .db $20, $6E, $00, $60 ; n

  .db $20, $32, $00, $70 ; 2
  .db $20, $30, $00, $78 ; 0
  .db $20, $31, $00, $80 ; 1
  .db $20, $37, $00, $88 ; 7


  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .bank 2
  .org $0000
  .incbin "alphabet.chr"
