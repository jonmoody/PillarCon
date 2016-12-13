  .inesprg 1
  .ineschr 1
  .inesmap 0
  .inesmir 1

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .rsset $0000
pointerBackgroundLowByte  .rs 1
pointerBackgroundHighByte  .rs 1
jumping  .rs 1
falling  .rs 1
jumpingVelocity  .rs 1
movementSpeed  .rs 1
projectileSpeed  .rs 1
playerHealth  .rs 1
iFrames  .rs 1

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

  LDA #$00
  STA jumping
  LDA #$00
  STA falling
  LDA #$01
  STA jumpingVelocity
  LDA #$01
  STA movementSpeed
  LDA #$03
  STA projectileSpeed
  LDA #$03
  STA playerHealth
  LDA #$00
  STA iFrames

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
  CPX #$20
  BNE LoadPalettesLoop


LoadSprites:
  LDX #$00
LoadSpritesLoop:
  LDA sprites, x
  STA $0200, x
  INX
  CPX #$24
  BNE LoadSpritesLoop

LoadBackground:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDA #LOW(background)
  STA pointerBackgroundLowByte
  LDA #HIGH(background)
  STA pointerBackgroundHighByte

  LDX #$00
  LDY #$00
LoadBackgroundLoop:
  LDA [pointerBackgroundLowByte], y
  STA $2007

  INY
  CPY #$00
  BNE LoadBackgroundLoop

  INC pointerBackgroundHighByte
  INX
  CPX #$04
  BNE LoadBackgroundLoop

LoadAttribute:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributeLoop:
  LDA attribute, x
  STA $2007
  INX
  CPX #$40
  BNE LoadAttributeLoop


  LDA #%10000000    ; Enable NMI, sprites and background on table 0
  STA $2000
  LDA #%00011110    ; Enable sprites, enable backgrounds
  STA $2001


InfiniteLoop:
  JMP InfiniteLoop

NMI:
  LDA #$00
  STA $2003
  LDA #$02
  STA $4014

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016

ReadA:
  LDA $4016       ; Player 1 - A
  AND #%00000001
  BEQ ReadADone

  LDA #$01
  STA jumping
ReadADone:

ReadB:
  LDA $4016       ; Player 1 - B
  AND #%00000001
  BEQ ReadBDone

  LDA $0200
  TAX
  LDA $0210
  TXA
  CLC
  ADC #$03
  STA $0210

  LDA $0202
  CMP #%01000000
  BEQ FacingLeft

  LDA $0203
  TAX
  LDA $0213
  TXA
  CLC
  ADC #$10
  STA $0213
  JMP ReadBDone
FacingLeft:
  LDA $0203
  TAX
  LDA $0213
  TXA
  SEC
  SBC #$08
  STA $0213
ReadBDone:

  LDA $4016       ; Player 1 - Select
  LDA $4016       ; Player 1 - Start
  LDA $4016       ; Player 1 - Up
  LDA $4016       ; Player 1 - Down

ReadLeft:
  LDA $4016       ; Player 1 - Left
  AND #%00000001
  BEQ ReadLeftDone

  LDA #%01000000  ; Flip character sprite to face left
  STA $0202
  STA $0206
  STA $020A
  STA $020E
  STA $0212
  LDA #$71
  STA $0201
  LDA #$70
  STA $0205
  LDA #$73
  STA $0209
  LDA #$72
  STA $020D

  LDA $0203       ; Sprite X Position

  TAX
  CPX #$00
  BEQ ReadLeftDone

  SEC
  SBC movementSpeed
  STA $0203
  LDA $0207
  SEC
  SBC movementSpeed
  STA $0207
  LDA $020B
  SEC
  SBC movementSpeed
  STA $020B
  LDA $020F
  SEC
  SBC movementSpeed
  STA $020F
ReadLeftDone:

ReadRight:
  LDA $4016       ; Player 1 - Right
  AND #%00000001
  BEQ ReadRightDone

  LDA #%00000000  ; Flip character sprite to face right
  STA $0202
  STA $0206
  STA $020A
  STA $020E
  STA $0212
  LDA #$70
  STA $0201
  LDA #$71
  STA $0205
  LDA #$72
  STA $0209
  LDA #$73
  STA $020D

  LDA $0203       ; Sprite X position

  TAX
  CPX #$F0
  BEQ ReadRightDone

  CLC
  ADC movementSpeed
  STA $0203
  LDA $0207
  CLC
  ADC movementSpeed
  STA $0207
  LDA $020B
  CLC
  ADC movementSpeed
  STA $020B
  LDA $020F
  CLC
  ADC movementSpeed
  STA $020F
ReadRightDone:

MoveProjectile:
  LDA $0213
  CMP #$F8
  BCS HideProjectile
  CMP #$04
  BCC HideProjectile
  LDA $0202
  CMP #%01000000
  BEQ MoveProjectileLeft
  LDA $0213
  CLC
  ADC projectileSpeed
  STA $0213
  JMP HideProjectileEnd
MoveProjectileLeft:
  LDA $0213
  SEC
  SBC projectileSpeed
  STA $0213
  JMP HideProjectileEnd

HideProjectile:
  LDA #$FF
  STA $0210
HideProjectileEnd:

Jump:
  LDA jumping
  CMP #$00
  BEQ EndJump

  LDA $0200
  CMP #$90
  BEQ Fall

  LDA falling
  CMP #$01
  BEQ Fall

  LDA $0200
  SEC
  SBC jumpingVelocity
  STA $0200
  LDA $0204
  SEC
  SBC jumpingVelocity
  STA $0204
  LDA $0208
  SEC
  SBC jumpingVelocity
  STA $0208
  LDA $020C
  SEC
  SBC jumpingVelocity
  STA $020C
  JMP EndJump
Fall:
  LDA #$01
  STA falling

  LDA $0200
  CMP #$B8
  BEQ CompleteJump

  LDA $0200
  CLC
  ADC jumpingVelocity
  STA $0200
  LDA $0204
  CLC
  ADC jumpingVelocity
  STA $0204
  LDA $0208
  CLC
  ADC jumpingVelocity
  STA $0208
  LDA $020C
  CLC
  ADC jumpingVelocity
  STA $020C
  JMP EndJump

CompleteJump:
  LDA #$00
  STA jumping
  LDA #$00
  STA falling
EndJump:

CheckProjectileCollision:
  LDA $0213
  CLC
  ADC #$08
  TAX
  CPX $0217
  BCC EndCheckProjectileCollision

  LDA $0210
  CLC
  ADC #$08
  TAX
  CPX $0214
  BCC EndCheckProjectileCollision

  LDA #%01000011
  STA $0216
  STA $021A
  STA $021E
  STA $0222
EndCheckProjectileCollision:

CheckPlayerCollision:
  LDA $020F
  CMP $0217
  BCC EndCheckPlayerCollision

  LDA $020F
  SEC
  SBC #$10
  TAX
  CPX $0217
  BCS EndCheckPlayerCollision

  LDA $020C
  CMP $0214
  BCC EndCheckPlayerCollision

  LDA iFrames
  CMP #$00
  BNE EndCheckPlayerCollision

LoseHealth:
  LDA #$20
  STA $2006
  LDA #$20
  CLC
  ADC playerHealth
  STA $2006
  LDA #$00
  STA $2007

  LDA #$3C
  STA iFrames

  LDA playerHealth
  CMP #$00
  BEQ EndCheckPlayerCollision
  LDA playerHealth
  SEC
  SBC #$01
  STA playerHealth

EndCheckPlayerCollision:

IFramesCheck:
  LDA iFrames
  CMP #$00
  BEQ EndIFramesCheck
  LDA iFrames
  SEC
  SBC #$01
  STA iFrames
EndIFramesCheck:

  ; Graphics Cleanup
  LDA #%10000000   ; Enable NMI, sprites and background on table 0
  STA $2000
  LDA #%00011110   ; Enable sprites, enable backgrounds
  STA $2001
  LDA #$00         ; No background scrolling
  STA $2005
  STA $2005

  RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .bank 1
  .org $E000

palette:
  .db $0F,$21,$1D,$1D,  $0F,$16,$20,$20,  $0F,$19,$1D,$1D,  $0F,$30,$1D,$1D
  .db $0F,$21,$15,$14,  $0F,$29,$15,$14,  $0F,$16,$15,$14,  $0F,$16,$15,$14

sprites:
  .db $B8, $70, $00, $30 ; Dude
  .db $B8, $71, $00, $38
  .db $C0, $72, $00, $30
  .db $C0, $73, $00, $38

  .db $FF, $74, $00, $00 ; Projectile

  .db $B8, $71, %01000001, $B0 ; Enemy
  .db $B8, $70, %01000001, $B8
  .db $C0, $73, %01000001, $B0
  .db $C0, $72, %01000001, $B8

background:
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$75,$75,$75,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$30,$49,$4C,$4C,$41,$52,$23,$4F,$4E,$00,$12,$10,$11,$17,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00
  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76
  .db $76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76

  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01
  .db $01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01,$01

attribute:
  .db %00000101, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000, %00000000
  .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
  .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010


  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .bank 2
  .org $0000
  .incbin "sprites.chr"
