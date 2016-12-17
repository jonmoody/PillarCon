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
  CPX #$48
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
  BNE CheckMovementEnabledLeft

  JMP ReadLeftDone

CheckMovementEnabledLeft:
  LDA movementEnabled
  CMP #$00
  BNE MovePlayerLeft

  JMP ReadLeftDone

MovePlayerLeft:
  LDA #%01000011  ; Flip character sprite to face left
  STA $0226
  STA $022A
  STA $022E
  STA $0232
  STA $0236
  STA $023A
  STA $023E
  STA $0242
  STA $0246

  LDA #$7F
  STA $0225
  LDA #$7D
  STA $022D
  LDA #$82
  STA $0231
  LDA #$80
  STA $0239
  LDA #$85
  STA $023D
  LDA #$83
  STA $0245

  LDA $0227       ; Sprite X Position

  TAX
  CPX #$00
  BEQ ReadLeftDone

  LDA $0224
  CMP #$A8
  BCC JumpOverLeft

  CPX #$56
  BNE JumpOverLeft

  JMP ReadRightDone

JumpOverLeft:
  LDA $0227
  SEC
  SBC movementSpeed
  STA $0227
  STA $0233
  STA $023F
  LDA $022B
  SEC
  SBC movementSpeed
  STA $022B
  STA $0237
  STA $0243
  LDA $022F
  SEC
  SBC movementSpeed
  STA $022F
  STA $023B
  STA $0247
ReadLeftDone:

ReadRight:
  LDA $4016       ; Player 1 - Right
  AND #%00000001
  BNE CheckMovementEnabledRight

  JMP ReadRightDone

CheckMovementEnabledRight:
  LDA movementEnabled
  CMP #$00
  BNE MoveplayerRight

  JMP ReadRightDone

MoveplayerRight:

  LDA #%00000011  ; Flip character sprite to face right
  STA $0226
  STA $022A
  STA $022E
  STA $0232
  STA $0236
  STA $023A
  STA $023E
  STA $0242
  STA $0246

  LDA #$7D
  STA $0225
  LDA #$7F
  STA $022D
  LDA #$80
  STA $0231
  LDA #$82
  STA $0239
  LDA #$83
  STA $023D
  LDA #$85
  STA $0245

  LDA $0227       ; Sprite X position

  TAX
  CPX #$E8
  BEQ ReadRightDone

  LDA $0224
  CMP #$A8
  BCC JumpOverRight

  CPX #$3A
  BEQ ReadRightDone

JumpOverRight:
  LDA $0227
  CLC
  ADC movementSpeed
  STA $0227
  STA $0233
  STA $023F
  LDA $022B
  CLC
  ADC movementSpeed
  STA $022B
  STA $0237
  STA $0243
  LDA $022F
  CLC
  ADC movementSpeed
  STA $022F
  STA $023B
  STA $0247
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

  LDA $0224
  CMP #$88
  BEQ Fall

  LDA falling
  CMP #$01
  BEQ Fall

  LDA $0224
  SEC
  SBC jumpingVelocity
  STA $0224
  LDA $0228
  SEC
  SBC jumpingVelocity
  STA $0228
  LDA $022C
  SEC
  SBC jumpingVelocity
  STA $022C
  LDA $0230
  SEC
  SBC jumpingVelocity
  STA $0230
  LDA $0234
  SEC
  SBC jumpingVelocity
  STA $0234
  LDA $0238
  SEC
  SBC jumpingVelocity
  STA $0238
  LDA $023C
  SEC
  SBC jumpingVelocity
  STA $023C
  LDA $0240
  SEC
  SBC jumpingVelocity
  STA $0240
  LDA $0244
  SEC
  SBC jumpingVelocity
  STA $0244
  JMP EndJump
Fall:
  LDA #$01
  STA falling

  LDA $0227
  CMP #$42
  BCC LandOnFloor

  CMP #$56
  BCS LandOnFloor

LandOnBlock:
  LDA $0224
  CMP #$A8
  BEQ CompleteJump

LandOnFloor:
  LDA $0224
  CMP #$B0
  BEQ CompleteJump

  LDA $0224
  CLC
  ADC jumpingVelocity
  STA $0224
  LDA $0228
  CLC
  ADC jumpingVelocity
  STA $0228
  LDA $022C
  CLC
  ADC jumpingVelocity
  STA $022C
  LDA $0230
  CLC
  ADC jumpingVelocity
  STA $0230
  LDA $0234
  CLC
  ADC jumpingVelocity
  STA $0234
  LDA $0238
  CLC
  ADC jumpingVelocity
  STA $0238
  LDA $023C
  CLC
  ADC jumpingVelocity
  STA $023C
  LDA $0240
  CLC
  ADC jumpingVelocity
  STA $0240
  LDA $0244
  CLC
  ADC jumpingVelocity
  STA $0244
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

  LDA $0247;$020F
  CMP $0217
  BCC EndCheckPlayerCollision

  LDA $0247
  SEC
  SBC #$18
  TAX
  CPX $0217
  BCS EndCheckPlayerCollision

  LDA $0244;$020C
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

  LDA $0226
  AND #%01000000
  BNE KnockBackRight

KnockBackLeft:
  LDA $0227
  SEC
  SBC #$01
  STA $0227
  STA $0233
  STA $023F
  LDA $022B
  SEC
  SBC #$01
  STA $022B
  STA $0237
  STA $0243
  LDA $022F
  SEC
  SBC #$01
  STA $022F
  STA $023B
  STA $0247

  JMP EndIFramesCheck

KnockBackRight:
  LDA $0227
  CLC
  ADC #$01
  STA $0227
  STA $0233
  STA $023F
  LDA $022B
  CLC
  ADC #$01
  STA $022B
  STA $0237
  STA $0243
  LDA $022F
  CLC
  ADC #$01
  STA $022F
  STA $023B
  STA $0247

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
  .db $0F,$21,$15,$14,  $0F,$29,$15,$14,  $0F,$16,$15,$14,  $0F,$0F,$37,$11

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

  .db $B0, $7D, $03, $30
  .db $B0, $7E, $03, $38
  .db $B0, $7F, $03, $40
  .db $B8, $80, $03, $30
  .db $B8, $81, $03, $38
  .db $B8, $82, $03, $40
  .db $C0, $83, $03, $30
  .db $C0, $84, $03, $38
  .db $C0, $85, $03, $40

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
