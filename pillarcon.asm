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
deathSpeed  .rs 1
deathTimer  .rs 1
enemyDeathTimer  .rs 1
movementEnabled  .rs 1

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
  LDA #$01
  STA deathSpeed
  LDA #$3C
  STA deathTimer
  LDA #$3C
  STA enemyDeathTimer
  LDA #$01
  STA movementEnabled

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

  LDA playerHealth
  CMP #$00
  BNE LatchController

  JMP Die

LatchController:
  LDA #$01
  STA $4016
  LDA #$00
  STA $4016

ReadA:
  LDA $4016       ; Player 1 - A
  AND #%00000001
  BEQ FallingTime

  LDA #$01
  STA jumping
  JMP ReadADone

FallingTime:
  LDA #$01
  STA falling
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

  LDA movementEnabled
  CMP #$00
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

  LDA $0200
  CMP #$B0
  BCC JumpOverLeft

  CPX #$56
  BNE JumpOverLeft

  JMP ReadRightDone

JumpOverLeft:
  LDA $0203
  SEC
  SBC movementSpeed
  STA $0203
  STA $020B
  LDA $0207
  SEC
  SBC movementSpeed
  STA $0207
  STA $020F
ReadLeftDone:

ReadRight:
  LDA $4016       ; Player 1 - Right
  AND #%00000001
  BEQ ReadRightDone

  LDA movementEnabled
  CMP #$00
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

  LDA $0200
  CMP #$B0
  BCC JumpOverRight

  CPX #$42
  BEQ ReadRightDone

JumpOverRight:

  LDA $0203
  CLC
  ADC movementSpeed
  STA $0203
  STA $020B
  LDA $0207
  CLC
  ADC movementSpeed
  STA $0207
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
  BNE StartJump

  JMP EndJump

StartJump:

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

  LDA $0203
  CMP #$42
  BCC LandOnFloor

  CMP #$56
  BCS LandOnFloor

LandOnBlock:
  LDA $0200
  CMP #$B0
  BEQ CompleteJump

LandOnFloor:
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
  LDA enemyDeathTimer
  CMP #$3C
  BNE EnemyDie

CheckCollision1:
  LDA $0213
  CLC
  ADC #$08
  TAX
  CPX $0217
  BCS CheckCollision2

  JMP EndCheckProjectileCollision

CheckCollision2:
  LDA $0210
  CLC
  ADC #$08
  TAX
  CPX $0214
  BCS EnemyDie

  JMP EndCheckProjectileCollision

EnemyDie:
  LDA enemyDeathTimer
  CMP #$00
  BNE MoveEnemyParts

  LDA #$FF
  STA $0214
  STA $0217
  STA $0218
  STA $021B
  STA $021C
  STA $021F
  STA $0220
  STA $0223

  JMP EndCheckProjectileCollision

MoveEnemyParts:
  LDA $0214
  SEC
  SBC deathSpeed
  STA $0214
  LDA $0217
  SEC
  SBC deathSpeed
  STA $0217

  LDA $0218
  SEC
  SBC deathSpeed
  STA $0218
  LDA $021B
  CLC
  ADC deathSpeed
  STA $021B

  LDA $021C
  CLC
  ADC deathSpeed
  STA $021C
  LDA $021F
  SEC
  SBC deathSpeed
  STA $021F

  LDA $0220
  CLC
  ADC deathSpeed
  STA $0220
  LDA $0223
  CLC
  ADC deathSpeed
  STA $0223

  LDA enemyDeathTimer
  SEC
  SBC #$01
  STA enemyDeathTimer

  LDA #%01000011
  STA $0216
  STA $021A
  STA $021E
  STA $0222
EndCheckProjectileCollision:

CheckPlayerCollision:
  LDA enemyDeathTimer
  CMP #$3C
  BNE EndCheckPlayerCollision

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

DrawHearts:
  LDA #$20
  STA $2006
  LDA #$20
  CLC
  ADC playerHealth
  STA $2006
  LDA #$00
  STA $2007

LoseHealth:
  LDA #$3C
  STA iFrames

  LDA playerHealth
  CMP #$00
  BEQ EndCheckPlayerCollision
  DEC playerHealth

EndCheckPlayerCollision:

IFramesCheck:
  LDA iFrames
  CMP #$00
  BEQ EndIFramesCheck
  DEC iFrames

  CMP #$24
  BCC EnableMovement

  LDA #$00
  STA movementEnabled

  LDA $0202
  AND #%01000000
  BNE KnockBackRight

KnockBackLeft:
  LDA $0203
  SEC
  SBC #$01
  STA $0203
  STA $020B
  LDA $0207
  SEC
  SBC #$01
  STA $0207
  STA $020F

  JMP EndIFramesCheck

KnockBackRight:
  LDA $0203
  CLC
  ADC #$01
  STA $0203
  STA $020B
  LDA $0207
  CLC
  ADC #$01
  STA $0207
  STA $020F

  JMP EndIFramesCheck

EnableMovement:

  LDA #$01
  STA movementEnabled

EndIFramesCheck:

CheckPlayerDeath:
  LDA playerHealth
  CMP #$00
  BEQ Die

  JMP EndCheckPlayerDeath

Die:
  LDA deathTimer
  CMP #$00
  BNE MoveParts

  LDA #$FF
  STA $0200
  STA $0203
  STA $0204
  STA $0207
  STA $0208
  STA $020B
  STA $020C
  STA $020F

  JMP EndCheckPlayerDeath

MoveParts:
  LDA $0200
  SEC
  SBC deathSpeed
  STA $0200
  LDA $0203
  SEC
  SBC deathSpeed
  STA $0203

  LDA $0204
  SEC
  SBC deathSpeed
  STA $0204
  LDA $0207
  CLC
  ADC deathSpeed
  STA $0207

  LDA $0208
  CLC
  ADC deathSpeed
  STA $0208
  LDA $020B
  SEC
  SBC deathSpeed
  STA $020B

  LDA $020C
  CLC
  ADC deathSpeed
  STA $020C
  LDA $020F
  CLC
  ADC deathSpeed
  STA $020F

  LDA deathTimer
  SEC
  SBC #$01
  STA deathTimer
EndCheckPlayerDeath:

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
  .db $0F,$21,$1D,$1D,  $0F,$16,$20,$20,  $0F,$19,$16,$20,  $0F,$30,$1D,$1D
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

  .db $00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$7A
  .db $7B,$7C,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00,$00

  .db $76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$03,$76,$76,$76,$77,$79
  .db $79,$78,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76,$76

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
  .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
  .db %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010, %10101010
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
