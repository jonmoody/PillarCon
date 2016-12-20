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
firingProjectile  .rs 1

projectileY = $0210
projectileTile = $0211
projectileAttr = $0212
projectileX = $0213

playerSprite1Y = $0224
playerSprite1Tile = $0225
playerSprite1Attr = $0226
playerSprite1X = $0227

playerSprite2Y = $0228
playerSprite2Tile = $0229
playerSprite2Attr = $022A
playerSprite2X = $022B

playerSprite3Y = $022C
playerSprite3Tile = $022D
playerSprite3Attr = $022E
playerSprite3X = $022F

playerSprite4Y = $0230
playerSprite4Tile = $0231
playerSprite4Attr = $0232
playerSprite4X = $0233

playerSprite5Y = $0234
playerSprite5Tile = $0235
playerSprite5Attr = $0236
playerSprite5X = $0237

playerSprite6Y = $0238
playerSprite6Tile = $0239
playerSprite6Attr = $023A
playerSprite6X = $023B

playerSprite7Y = $023C
playerSprite7Tile = $023D
playerSprite7Attr = $023E
playerSprite7X = $023F

playerSprite8Y = $0240
playerSprite8Tile = $0241
playerSprite8Attr = $0242
playerSprite8X = $0243

playerSprite9Y = $0244
playerSprite9Tile = $0245
playerSprite9Attr = $0246
playerSprite9X = $0247

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
  LDA #$00
  STA firingProjectile

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
  CPX #$6C
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
  BNE StartFiringProjectile

  LDA #$00
  STA firingProjectile

  JMP ReadBDone

StartFiringProjectile:
  LDA #$01
  STA firingProjectile

  LDA playerSprite1Y
  TAX
  LDA projectileY
  TXA
  CLC
  ADC #$08
  STA projectileY

  LDA playerSprite1Attr
  CMP #%01000011
  BEQ FacingLeft

  LDA #$86
  STA playerSprite6Tile
  LDA #$87
  STA playerSprite9Tile

  LDA playerSprite1X
  TAX
  LDA projectileX
  TXA
  CLC
  ADC #$18
  STA projectileX
  JMP ReadBDone
FacingLeft:
  LDA #$86
  STA playerSprite4Tile
  LDA #$87
  STA playerSprite7Tile

  LDA playerSprite1X
  TAX
  LDA projectileX
  TXA
  SEC
  SBC #$08
  STA projectileX
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
  STA playerSprite1Attr
  STA playerSprite2Attr
  STA playerSprite3Attr
  STA playerSprite4Attr
  STA playerSprite5Attr
  STA playerSprite6Attr
  STA playerSprite7Attr
  STA playerSprite8Attr
  STA playerSprite9Attr
  LDA #%01000011
  STA projectileAttr

  LDA #$7F
  STA playerSprite1Tile
  LDA #$7D
  STA playerSprite3Tile
  LDA #$80
  STA playerSprite6Tile
  LDA #$83
  STA playerSprite9Tile

  LDA firingProjectile
  CMP #$01
  BEQ CheckBoxCollisionLeft

  LDA #$82
  STA playerSprite4Tile
  LDA #$85
  STA playerSprite7Tile

CheckBoxCollisionLeft:

  LDA playerSprite1X

  TAX
  CPX #$00
  BEQ ReadLeftDone

  LDA playerSprite1Y
  CMP #$A8
  BCC JumpOverLeft

  CPX #$56
  BNE JumpOverLeft

  JMP ReadRightDone

JumpOverLeft:
  LDA playerSprite1X
  SEC
  SBC movementSpeed
  STA playerSprite1X
  STA playerSprite4X
  STA playerSprite7X
  LDA playerSprite2X
  SEC
  SBC movementSpeed
  STA playerSprite2X
  STA playerSprite5X
  STA playerSprite8X
  LDA playerSprite3X
  SEC
  SBC movementSpeed
  STA playerSprite3X
  STA playerSprite6X
  STA playerSprite9X
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
  STA playerSprite1Attr
  STA playerSprite2Attr
  STA playerSprite3Attr
  STA playerSprite4Attr
  STA playerSprite5Attr
  STA playerSprite6Attr
  STA playerSprite7Attr
  STA playerSprite8Attr
  STA playerSprite9Attr
  LDA #%00000011
  STA projectileAttr

  LDA #$7D
  STA playerSprite1Tile
  LDA #$7F
  STA playerSprite3Tile
  LDA #$80
  STA playerSprite4Tile
  LDA #$83
  STA playerSprite7Tile

  LDA firingProjectile
  CMP #$01
  BEQ CheckBoxCollisionRight

  LDA #$82
  STA playerSprite6Tile
  LDA #$85
  STA playerSprite9Tile

CheckBoxCollisionRight:

  LDA playerSprite1X       ; Sprite X position

  TAX
  CPX #$E8
  BEQ ReadRightDone

  LDA playerSprite1Y
  CMP #$A8
  BCC JumpOverRight

  CPX #$3A
  BEQ ReadRightDone

JumpOverRight:
  LDA playerSprite1X
  CLC
  ADC movementSpeed
  STA playerSprite1X
  STA playerSprite4X
  STA playerSprite7X
  LDA playerSprite2X
  CLC
  ADC movementSpeed
  STA playerSprite2X
  STA playerSprite5X
  STA playerSprite8X
  LDA playerSprite3X
  CLC
  ADC movementSpeed
  STA playerSprite3X
  STA playerSprite6X
  STA playerSprite9X
ReadRightDone:

MoveProjectile:
  LDA projectileX
  CMP #$F8
  BCS HideProjectile
  CMP #$04
  BCC HideProjectile
  LDA playerSprite1Attr
  CMP #%01000011
  BEQ MoveProjectileLeft
  LDA projectileX
  CLC
  ADC projectileSpeed
  STA projectileX
  JMP HideProjectileEnd
MoveProjectileLeft:
  LDA projectileX
  SEC
  SBC projectileSpeed
  STA projectileX
  JMP HideProjectileEnd

HideProjectile:
  LDA #$FF
  STA projectileY
HideProjectileEnd:

Jump:
  LDA jumping
  CMP #$00
  BNE StartJump

  JMP EndJump

StartJump:

  LDA playerSprite1Y
  CMP #$88
  BEQ Fall

  LDA falling
  CMP #$01
  BEQ Fall

  LDA playerSprite1Y
  SEC
  SBC jumpingVelocity
  STA playerSprite1Y
  LDA playerSprite2Y
  SEC
  SBC jumpingVelocity
  STA playerSprite2Y
  LDA playerSprite3Y
  SEC
  SBC jumpingVelocity
  STA playerSprite3Y
  LDA playerSprite4Y
  SEC
  SBC jumpingVelocity
  STA playerSprite4Y
  LDA playerSprite5Y
  SEC
  SBC jumpingVelocity
  STA playerSprite5Y
  LDA playerSprite6Y
  SEC
  SBC jumpingVelocity
  STA playerSprite6Y
  LDA playerSprite7Y
  SEC
  SBC jumpingVelocity
  STA playerSprite7Y
  LDA playerSprite8Y
  SEC
  SBC jumpingVelocity
  STA playerSprite8Y
  LDA playerSprite9Y
  SEC
  SBC jumpingVelocity
  STA playerSprite9Y
  JMP EndJump
Fall:
  LDA #$01
  STA falling

  LDA playerSprite1X
  CMP #$42
  BCC LandOnFloor

  CMP #$56
  BCS LandOnFloor

LandOnBlock:
  LDA playerSprite1Y
  CMP #$A8
  BEQ CompleteJump

LandOnFloor:
  LDA playerSprite1Y
  CMP #$B0
  BEQ CompleteJump

  LDA playerSprite1Y
  CLC
  ADC jumpingVelocity
  STA playerSprite1Y
  LDA playerSprite2Y
  CLC
  ADC jumpingVelocity
  STA playerSprite2Y
  LDA playerSprite3Y
  CLC
  ADC jumpingVelocity
  STA playerSprite3Y
  LDA playerSprite4Y
  CLC
  ADC jumpingVelocity
  STA playerSprite4Y
  LDA playerSprite5Y
  CLC
  ADC jumpingVelocity
  STA playerSprite5Y
  LDA playerSprite6Y
  CLC
  ADC jumpingVelocity
  STA playerSprite6Y
  LDA playerSprite7Y
  CLC
  ADC jumpingVelocity
  STA playerSprite7Y
  LDA playerSprite8Y
  CLC
  ADC jumpingVelocity
  STA playerSprite8Y
  LDA playerSprite9Y
  CLC
  ADC jumpingVelocity
  STA playerSprite9Y
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
  LDA projectileX
  CLC
  ADC #$08
  TAX
  CPX $024B
  BCS CheckCollision2

  JMP EndCheckProjectileCollision

CheckCollision2:
  LDA projectileY
  CLC
  ADC #$08
  TAX
  CPX $0248
  BCS EnemyDie

  JMP EndCheckProjectileCollision

EnemyDie:
  LDA enemyDeathTimer
  CMP #$00
  BNE MoveEnemyParts

  LDA #$FF
  STA $0248
  STA $024C
  STA $0250
  STA $0254
  STA $0258
  STA $025C
  STA $0260
  STA $0264
  STA $0268

  JMP EndCheckProjectileCollision

MoveEnemyParts:
  LDA $0248
  SEC
  SBC deathSpeed
  STA $0248
  LDA $024B
  SEC
  SBC deathSpeed
  STA $024B

  LDA $024C
  SEC
  SBC deathSpeed
  STA $024C

  LDA $0250
  SEC
  SBC deathSpeed
  STA $0250
  LDA $0253
  CLC
  ADC deathSpeed
  STA $0253

  LDA $0257
  SEC
  SBC deathSpeed
  STA $0257

  LDA $025F
  CLC
  ADC deathSpeed
  STA $025F

  LDA $0260
  CLC
  ADC deathSpeed
  STA $0260
  LDA $0263
  SEC
  SBC deathSpeed
  STA $0263

  LDA $0264
  CLC
  ADC deathSpeed
  STA $0264

  LDA $0268
  CLC
  ADC deathSpeed
  STA $0268
  LDA $026B
  CLC
  ADC deathSpeed
  STA $026B

  LDA enemyDeathTimer
  SEC
  SBC #$01
  STA enemyDeathTimer
EndCheckProjectileCollision:

CheckPlayerCollision:
  LDA enemyDeathTimer
  CMP #$3C
  BNE EndCheckPlayerCollision

  LDA playerSprite9X
  CMP $024B
  BCC EndCheckPlayerCollision

  LDA playerSprite9X
  SEC
  SBC #$20
  TAX
  CPX $024B
  BCS EndCheckPlayerCollision

  LDA playerSprite9Y
  CMP $0248
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

  LDA playerSprite1Attr
  AND #%01000000
  BNE KnockBackRight

KnockBackLeft:
  LDA playerSprite1X
  SEC
  SBC #$01
  STA playerSprite1X
  STA playerSprite4X
  STA playerSprite7X
  LDA playerSprite2X
  SEC
  SBC #$01
  STA playerSprite2X
  STA playerSprite5X
  STA playerSprite8X
  LDA playerSprite3X
  SEC
  SBC #$01
  STA playerSprite3X
  STA playerSprite6X
  STA playerSprite9X

  JMP EndIFramesCheck

KnockBackRight:
  LDA playerSprite1X
  CLC
  ADC #$01
  STA playerSprite1X
  STA playerSprite4X
  STA playerSprite7X
  LDA playerSprite2X
  CLC
  ADC #$01
  STA playerSprite2X
  STA playerSprite5X
  STA playerSprite8X
  LDA playerSprite3X
  CLC
  ADC #$01
  STA playerSprite3X
  STA playerSprite6X
  STA playerSprite9X

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
  STA playerSprite1Y
  STA playerSprite2Y
  STA playerSprite3Y
  STA playerSprite4Y
  STA playerSprite5Y
  STA playerSprite6Y
  STA playerSprite7Y
  STA playerSprite8Y
  STA playerSprite9Y

  JMP EndCheckPlayerDeath

MoveParts:
  LDA playerSprite1Y
  SEC
  SBC deathSpeed
  STA playerSprite1Y
  LDA playerSprite1X
  SEC
  SBC deathSpeed
  STA playerSprite1X

  LDA playerSprite2Y
  SEC
  SBC deathSpeed
  STA playerSprite2Y

  LDA playerSprite3Y
  SEC
  SBC deathSpeed
  STA playerSprite3Y
  LDA playerSprite3X
  CLC
  ADC deathSpeed
  STA playerSprite3X

  LDA playerSprite4X
  SEC
  SBC deathSpeed
  STA playerSprite4X

  LDA playerSprite6X
  CLC
  ADC deathSpeed
  STA playerSprite6X

  LDA playerSprite7Y
  CLC
  ADC deathSpeed
  STA playerSprite7Y
  LDA playerSprite7X
  SEC
  SBC deathSpeed
  STA playerSprite7X

  LDA playerSprite8Y
  CLC
  ADC deathSpeed
  STA playerSprite8Y

  LDA playerSprite9Y
  CLC
  ADC deathSpeed
  STA playerSprite9Y
  LDA playerSprite9X
  CLC
  ADC deathSpeed
  STA playerSprite9X

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
  .db $0F,$21,$15,$14,  $0F,$29,$15,$14,  $0F,$16,$10,$0F,  $0F,$0F,$37,$11

sprites:
  .db $FF, $70, $00, $30 ; Not in use anymore
  .db $FF, $71, $00, $38
  .db $FF, $72, $00, $30
  .db $FF, $73, $00, $38

  .db $FF, $74, $03, $00 ; Projectile

  .db $FF, $71, %01000001, $B0 ; Derp
  .db $FF, $70, %01000001, $B8
  .db $FF, $73, %01000001, $B0
  .db $FF, $72, %01000001, $B8

  .db $B0, $7D, $03, $30 ; Player character
  .db $B0, $7E, $03, $38
  .db $B0, $7F, $03, $40
  .db $B8, $80, $03, $30
  .db $B8, $81, $03, $38
  .db $B8, $82, $03, $40
  .db $C0, $83, $03, $30
  .db $C0, $84, $03, $38
  .db $C0, $85, $03, $40

  .db $B0, $89, $02, $B0 ; Enemy character
  .db $B0, $8A, $02, $B8
  .db $B0, $8B, $02, $C0
  .db $B8, $8C, $02, $B0
  .db $B8, $8D, $02, $B8
  .db $B8, $8E, $02, $C0
  .db $C0, $8F, $02, $B0
  .db $C0, $90, $02, $B8
  .db $C0, $91, $02, $C0

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
