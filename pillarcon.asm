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
enemyHealth  .rs 1
iFrames  .rs 1
enemyIFrames  .rs 1
deathSpeed  .rs 1
deathTimer  .rs 1
enemyDeathTimer  .rs 1
movementEnabled  .rs 1
firingProjectile  .rs 1
gameOver  .rs 1
gameWin  .rs 1
titleScreen  .rs 1
creditsScreen  .rs 1
gameInProgress  .rs 1
introDialog  .rs 1
introDialogLoaded  .rs 1
advanceDialog  .rs 1
currentDialogScreen  .rs 1
endOfDialog  .rs 1
dialogDelay  .rs 1
creditsOptionSelected  .rs 1
selectButtonHeldDown  .rs 1
enemyFireTimer  .rs 1

  .include "reference/spriteMemoryLocations.asm"

  .bank 0
  .org $C000

RESET:
  SEI
  CLD
  LDX #$40
  STX $4017    ; Disable APU frame IRQ
  LDX #$FF
  TXS
  JSR DisableGraphics

  JSR VBlank

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

  JSR VBlank

  LDA #$01
  STA titleScreen
  STA jumpingVelocity
  STA movementSpeed
  STA deathSpeed
  STA movementEnabled

  LDA #$03
  STA playerHealth
  STA enemyHealth
  STA projectileSpeed

  LDA #$3C
  STA deathTimer
  STA enemyDeathTimer

  JSR LoadPalettes

  LDA #LOW(backgroundTitle)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundTitle)
  STA pointerBackgroundHighByte
  JSR LoadBackground

  JSR LoadAttributeTitle

  JSR EnableGraphics

InfiniteLoop:
  JMP InfiniteLoop

EnableGraphics:
  LDA #%10000000   ; Enable NMI, sprites and background on table 0
  STA $2000
  LDA #%00011110   ; Enable sprites, enable backgrounds
  STA $2001
  LDA #$00         ; No background scrolling
  STA $2006
  STA $2006
  STA $2005
  STA $2005
  RTS

DisableGraphics:
  LDX #$00
  STX $2000    ; Disable NMI
  STX $2001    ; Disable rendering
  STX $4010    ; Disable DMC IRQs
  RTS

VBlank:
  BIT $2002
  BPL VBlank
  RTS

LoadSprites:
  LDX #$00
LoadSpritesLoop:
  LDA sprites, x
  STA $0200, x
  INX
  CPX #$6C
  BNE LoadSpritesLoop
  RTS

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
  RTS

LoadDialogPalettes:
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
LoadDialogPalettesLoop:
  LDA paletteDialog, x
  STA $2007
  INX
  CPX #$20
  BNE LoadDialogPalettesLoop
  RTS

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
  RTS

LoadAttributeTitle:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributeTitleLoop:
  LDA attributeTitle, x
  STA $2007
  INX
  CPX #$40
  BNE LoadAttributeTitleLoop
  RTS

LoadAttributeCredits:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributeCreditsLoop:
  LDA attributeCredits, x
  STA $2007
  INX
  CPX #$40
  BNE LoadAttributeCreditsLoop
  RTS

LoadAttributeDialog:
  LDA $2002
  LDA #$23
  STA $2006
  LDA #$C0
  STA $2006
  LDX #$00
LoadAttributeDialogLoop:
  LDA attributeDialog, x
  STA $2007
  INX
  CPX #$40
  BNE LoadAttributeDialogLoop
  RTS

LoadBackground:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

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
  RTS

NextLineTop:
  CPY #$10
  BNE TopLine3

  LDA $2002
  LDA #$20
  STA $2006
  LDA #$AC
  STA $2006
  JMP EndNextLineTop

TopLine3:
  CPY #$20
  BNE TopLine4

  LDA $2002
  LDA #$20
  STA $2006
  LDA #$CC
  STA $2006
  JMP EndNextLineTop

TopLine4:
  CPY #$30
  BNE TopLine5

  LDA $2002
  LDA #$20
  STA $2006
  LDA #$EC
  STA $2006
  JMP EndNextLineTop

TopLine5:
  CPY #$40
  BNE TopLine6

  LDA $2002
  LDA #$21
  STA $2006
  LDA #$0C
  STA $2006
  JMP EndNextLineTop

TopLine6:
  CPY #$50
  BNE TopLine7

  LDA $2002
  LDA #$21
  STA $2006
  LDA #$2C
  STA $2006
  JMP EndNextLineTop

TopLine7:
  CPY #$60
  BNE EndNextLineTop

  LDA $2002
  LDA #$21
  STA $2006
  LDA #$4C
  STA $2006
EndNextLineTop:
  RTS

NextLineBottom:
  CPY #$10
  BNE BottomLine3

  LDA $2002
  LDA #$22
  STA $2006
  LDA #$8C
  STA $2006
  JMP EndNextLineBottom

BottomLine3:
  CPY #$20
  BNE BottomLine4

  LDA $2002
  LDA #$22
  STA $2006
  LDA #$AC
  STA $2006
  JMP EndNextLineBottom

BottomLine4:
  CPY #$30
  BNE BottomLine5

  LDA $2002
  LDA #$22
  STA $2006
  LDA #$CC
  STA $2006
  JMP EndNextLineBottom

BottomLine5:
  CPY #$40
  BNE BottomLine6

  LDA $2002
  LDA #$22
  STA $2006
  LDA #$EC
  STA $2006
  JMP EndNextLineBottom

BottomLine6:
  CPY #$50
  BNE BottomLine7

  LDA $2002
  LDA #$23
  STA $2006
  LDA #$0C
  STA $2006
  JMP EndNextLineBottom

BottomLine7:
  CPY #$60
  BNE EndNextLineBottom

  LDA $2002
  LDA #$23
  STA $2006
  LDA #$2C
  STA $2006
EndNextLineBottom:
  RTS

LoadTopDialog:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$8C
  STA $2006

  LDY #$00
LoadTopDialogLoop:
  LDA [pointerBackgroundLowByte], y
  STA $2007

  INY
  JSR NextLineTop

  CPY #$70
  BNE LoadTopDialogLoop
  RTS

LoadBottomDialog:
  LDA $2002
  LDA #$22
  STA $2006
  LDA #$6C
  STA $2006

  LDY #$00
LoadBottomDialogLoop:
  LDA [pointerBackgroundLowByte], y
  STA $2007

  INY
  JSR NextLineBottom

  CPY #$70
  BNE LoadBottomDialogLoop
  RTS

DrawHearts:
  LDA #$20
  STA $2006
  LDA #$20
  CLC
  ADC playerHealth
  STA $2006
  LDA #$01
  STA $2007
  RTS

LoseHealth:
  LDA #$3C
  STA iFrames

  LDA playerHealth
  CMP #$00
  BEQ EndLoseHealth

  JSR DrawHearts
  DEC playerHealth
EndLoseHealth:
  RTS

DrawNextDialogScreen:
  INC currentDialogScreen

  JSR DisableGraphics

  LDA #LOW(backgroundDialogTemplate)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogTemplate)
  STA pointerBackgroundHighByte
  JSR LoadBackground

LoadIntro1:
  LDA currentDialogScreen
  CMP #$01
  BNE LoadIntro2

  LDA #LOW(backgroundDialogIntro1)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro1)
  STA pointerBackgroundHighByte
  JSR LoadTopDialog
  JMP EndLoadingDialogBackground

LoadIntro2:
  LDA currentDialogScreen
  CMP #$02
  BNE LoadIntro3

  LDA #LOW(backgroundDialogIntro2)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro2)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog
  JMP EndLoadingDialogBackground

LoadIntro3:
  LDA currentDialogScreen
  CMP #$03
  BNE LoadIntro4

  LDA #LOW(backgroundDialogIntro3)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro3)
  STA pointerBackgroundHighByte
  JSR LoadTopDialog
  JMP EndLoadingDialogBackground

LoadIntro4:
  LDA currentDialogScreen
  CMP #$04
  BNE LoadIntro5

  LDA #LOW(backgroundDialogIntro4)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro4)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog
  JMP EndLoadingDialogBackground

LoadIntro5:
  LDA currentDialogScreen
  CMP #$05
  BNE LoadIntro6

  LDA #LOW(backgroundDialogIntro5)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro5)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog
  JMP EndLoadingDialogBackground

LoadIntro6:
  LDA currentDialogScreen
  CMP #$06
  BNE LoadIntro7

  LDA #LOW(backgroundDialogIntro6)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro6)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog
  JMP EndLoadingDialogBackground

LoadIntro7:
  LDA currentDialogScreen
  CMP #$07
  BNE LoadIntro8

  LDA #LOW(backgroundDialogIntro7)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro7)
  STA pointerBackgroundHighByte
  JSR LoadTopDialog
  JMP EndLoadingDialogBackground

LoadIntro8:

  LDA #$01
  STA endOfDialog
EndLoadingDialogBackground:
  RTS

NMI:
  LDA #$00
  STA $2003
  LDA #$02
  STA $4014

GameVictory:
  LDA gameWin
  CMP #$00
  BEQ EndGameVictory

  JMP EndCheckGameVictory
EndGameVictory:

GameOver:
  LDA gameOver
  CMP #$00
  BEQ EndGameOver

  JMP EndCheckGameOver
EndGameOver:

Credits:
  LDA creditsScreen
  CMP #$00
  BEQ EndCredits

  JMP EndCurrentFrame
EndCredits:

  LDA playerHealth
  CMP #$00
  BNE ReadController

  JMP Die

ReadController:
  LDA titleScreen
  CMP #$01
  BEQ ReadTitleScreenControls

  JMP ReadGameplayControls

ReadTitleScreenControls:
  .include "controls/titleScreenControls.asm"

ReadGameplayControls:
  .include "controls/gameplayControls.asm"
EndReadController:

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

  SEC
  LDA playerSprite1Y
  SBC jumpingVelocity
  STA playerSprite1Y
  LDA playerSprite2Y
  SBC jumpingVelocity
  STA playerSprite2Y
  LDA playerSprite3Y
  SBC jumpingVelocity
  STA playerSprite3Y
  LDA playerSprite4Y
  SBC jumpingVelocity
  STA playerSprite4Y
  LDA playerSprite5Y
  SBC jumpingVelocity
  STA playerSprite5Y
  LDA playerSprite6Y
  SBC jumpingVelocity
  STA playerSprite6Y
  LDA playerSprite7Y
  SBC jumpingVelocity
  STA playerSprite7Y
  LDA playerSprite8Y
  SBC jumpingVelocity
  STA playerSprite8Y
  LDA playerSprite9Y
  SBC jumpingVelocity
  STA playerSprite9Y

  JMP EndJump

Fall:
  LDA #$01
  STA falling

LandOnFloor:
  LDA playerSprite1Y
  CMP #$A8
  BEQ CompleteJump

  CLC
  LDA playerSprite1Y
  ADC jumpingVelocity
  STA playerSprite1Y
  LDA playerSprite2Y
  ADC jumpingVelocity
  STA playerSprite2Y
  LDA playerSprite3Y
  ADC jumpingVelocity
  STA playerSprite3Y
  LDA playerSprite4Y
  ADC jumpingVelocity
  STA playerSprite4Y
  LDA playerSprite5Y
  ADC jumpingVelocity
  STA playerSprite5Y
  LDA playerSprite6Y
  ADC jumpingVelocity
  STA playerSprite6Y
  LDA playerSprite7Y
  ADC jumpingVelocity
  STA playerSprite7Y
  LDA playerSprite8Y
  ADC jumpingVelocity
  STA playerSprite8Y
  LDA playerSprite9Y
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
  BEQ CheckCollision1

  JMP EnemyDie

CheckCollision1:
  LDA projectileX
  CLC
  ADC #$08
  CMP enemySprite1X
  BCS CheckCollision2

  JMP EndCheckProjectileCollision

CheckCollision2:
  LDA projectileX
  SEC
  SBC #$08
  CMP enemySprite3X
  BCC CheckCollision3

  JMP EndCheckProjectileCollision

CheckCollision3:
  LDA projectileY
  CMP enemySprite1Y
  BCS CheckCollision4

  JMP EndCheckProjectileCollision

CheckCollision4:
  LDA projectileY
  CMP enemySprite8Y
  BCC EnemyLoseHealth

  JMP EndCheckProjectileCollision

EnemyLoseHealth:
  LDA enemyIFrames
  CMP #$00
  BNE EndEnemyLoseHealth

  LDA #$FF
  STA projectileY

  DEC enemyHealth

  LDA #$20
  STA $2006
  LDA #$3C
  CLC
  ADC enemyHealth
  STA $2006
  LDA #$01
  STA $2007

  LDA #$3C
  STA enemyIFrames
EndEnemyLoseHealth:

  LDA enemyHealth
  CMP #$00
  BEQ EnemyDie

  JMP EndCheckProjectileCollision

EnemyDie:
  LDA enemyDeathTimer
  CMP #$00
  BNE MoveEnemyParts

  LDA #$FF
  STA enemySprite1Y
  STA enemySprite2Y
  STA enemySprite3Y
  STA enemySprite4Y
  STA enemySprite5Y
  STA enemySprite6Y
  STA enemySprite7Y
  STA enemySprite8Y
  STA enemySprite9Y

  LDA #$01
  STA gameWin

  JMP CheckGameVictory

MoveEnemyParts:
  DEC enemySprite1Y
  DEC enemySprite1X

  DEC enemySprite2Y

  DEC enemySprite3Y
  INC enemySprite3X

  DEC enemySprite4X

  INC enemySprite6X

  INC enemySprite7Y
  DEC enemySprite7X

  INC enemySprite8Y

  INC enemySprite9Y
  INC enemySprite9X

  DEC enemyDeathTimer
EndCheckProjectileCollision:

CheckEnemyBulletCollision:
  LDA enemyProjectileX
  CLC
  ADC #$08
  CMP playerSprite1X
  BCC EndCheckEnemyBulletCollision

  LDA enemyProjectileX
  SEC
  SBC #$08
  CMP playerSprite3X
  BCS EndCheckEnemyBulletCollision

  LDA enemyProjectileY
  CMP playerSprite1Y
  BCC EndCheckEnemyBulletCollision

  LDA enemyProjectileY
  CMP playerSprite8Y
  BCS EndCheckEnemyBulletCollision

  LDA iFrames
  CMP #$00
  BNE EndCheckEnemyBulletCollision

  LDA #$FF
  STA enemyProjectileY

  JSR LoseHealth
EndCheckEnemyBulletCollision:

CheckPlayerCollision:
  LDA enemyDeathTimer
  CMP #$3C
  BNE EndCheckPlayerCollision

  LDA playerSprite9X
  CMP enemySprite1X
  BCC EndCheckPlayerCollision

  LDA playerSprite9X
  SEC
  SBC #$20
  CMP enemySprite1X
  BCS EndCheckPlayerCollision

  LDA playerSprite9Y
  CMP enemySprite1Y
  BCC EndCheckPlayerCollision

  LDA iFrames
  CMP #$00
  BNE EndCheckPlayerCollision

  JSR LoseHealth
EndCheckPlayerCollision:

EnemyFireProjectile:
  LDA enemyHealth
  CMP #$00
  BEQ EndEnemyFireProjectile

  LDA enemyFireTimer
  CMP #$00
  BNE EndEnemyFireProjectile

  LDA #$40
  STA enemyFireTimer

  LDA enemySprite1Y
  TAX
  LDA enemyProjectileY
  TXA
  CLC
  ADC #$08
  STA enemyProjectileY

  LDA enemySprite1X
  TAX
  LDA enemyProjectileX
  TXA
  CLC
  ADC #$00
  STA enemyProjectileX
EndEnemyFireProjectile:

  DEC enemyFireTimer

MoveEnemyProjectile:
  LDA enemyHealth
  CMP #$00
  BEQ HideEnemyProjectile

  LDA enemyProjectileX
  CMP #$F8
  BCS HideEnemyProjectile
  CMP #$04
  BCC HideEnemyProjectile

  LDA enemyProjectileX
  SEC
  SBC projectileSpeed
  STA enemyProjectileX
  JMP HideEnemyProjectileEnd

HideEnemyProjectile:
  LDA #$FF
  STA enemyProjectileY
HideEnemyProjectileEnd:

EnemyIFramesCheck:
  LDA enemyIFrames
  CMP #$00
  BEQ EndEnemyIFramesCheck

  DEC enemyIFrames
EndEnemyIFramesCheck:

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
  DEC playerSprite1X
  DEC playerSprite2X
  DEC playerSprite3X
  DEC playerSprite4X
  DEC playerSprite5X
  DEC playerSprite6X
  DEC playerSprite7X
  DEC playerSprite8X
  DEC playerSprite9X

  JMP EndIFramesCheck

KnockBackRight:
  INC playerSprite1X
  INC playerSprite2X
  INC playerSprite3X
  INC playerSprite4X
  INC playerSprite5X
  INC playerSprite6X
  INC playerSprite7X
  INC playerSprite8X
  INC playerSprite9X

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

  LDA #$01
  STA gameOver

  JMP EndCheckPlayerDeath

MoveParts:
  DEC playerSprite1Y
  DEC playerSprite1X

  DEC playerSprite2Y

  DEC playerSprite3Y
  INC playerSprite3X

  DEC playerSprite4X

  INC playerSprite6X

  INC playerSprite7Y
  DEC playerSprite7X

  INC playerSprite8Y

  INC playerSprite9Y
  INC playerSprite9X

  DEC deathTimer
EndCheckPlayerDeath:

CheckGameOver:
  LDA gameOver
  CMP #$00
  BEQ EndCheckGameOver

  JSR DisableGraphics

ClearSpritesGameOver:
  LDA #$00
  STA $0100, x
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE ClearSpritesGameOver

  LDA #LOW(backgroundGameOver)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundGameOver)
  STA pointerBackgroundHighByte
  JSR LoadBackground
EndCheckGameOver:

CheckCreditsScreen:
  LDA creditsScreen
  CMP #$00
  BEQ EndCheckCreditsScreen

  JSR DisableGraphics

  LDA #LOW(backgroundCredits)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundCredits)
  STA pointerBackgroundHighByte
  JSR LoadBackground
  JSR LoadAttributeCredits

  JSR EnableGraphics
  JMP EndCurrentFrame
EndCheckCreditsScreen:

CheckGameVictory:
  LDA gameWin
  CMP #$00
  BEQ EndCheckGameVictory

  JSR DisableGraphics

ClearSpritesVictory:
  LDA #$00
  STA $0100, x
  STA $0200, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  LDA #$FE
  STA $0300, x
  INX
  BNE ClearSpritesVictory

  LDA #LOW(backgroundGameWin)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundGameWin)
  STA pointerBackgroundHighByte
  JSR LoadBackground
EndCheckGameVictory:

CheckGameInProgress:
  LDA titleScreen
  CMP #$01
  BEQ EndCheckGameInProgress

  LDA introDialog
  CMP #$01
  BEQ EndCheckGameInProgress

  LDA gameInProgress
  CMP #$01
  BEQ EndCheckGameInProgress

  JSR DisableGraphics

  JSR LoadSprites

  LDA #LOW(background)
  STA pointerBackgroundLowByte
  LDA #HIGH(background)
  STA pointerBackgroundHighByte
  JSR LoadBackground

  JSR LoadAttribute
  JSR LoadPalettes

  LDA #$01
  STA gameInProgress
EndCheckGameInProgress:

CheckIntroDialog:
  LDA dialogDelay
  CMP #$00
  BEQ EndCheckingDelay

  DEC dialogDelay
  JMP EndCheckIntroDialog

EndCheckingDelay:

  LDA advanceDialog
  CMP #$01
  BEQ DrawDialog

  LDA introDialog
  CMP #$01
  BNE EndCheckIntroDialog

  LDA introDialogLoaded
  CMP #$01
  BEQ EndCheckIntroDialog

DrawDialog:
  JSR DrawNextDialogScreen

  JSR LoadAttributeDialog
  JSR LoadDialogPalettes

  LDA #$01
  STA introDialogLoaded

  LDA #$00
  STA advanceDialog

  LDA #$70
  STA dialogDelay
EndCheckIntroDialog:

  JSR EnableGraphics

EndCurrentFrame:
  RTI

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .bank 1
  .org $E000

palette:
  .include "graphics/palette.asm"

paletteDialog:
  .include "graphics/dialog/paletteIntro.asm"

sprites:
  .include "graphics/sprites.asm"

background:
  .include "graphics/background.asm"

backgroundGameOver:
  .include "graphics/backgroundGameOver.asm"

backgroundGameWin:
  .include "graphics/backgroundGameWin.asm"

backgroundTitle:
  .include "graphics/backgroundTitle.asm"

backgroundCredits:
  .include "graphics/backgroundCredits.asm"

backgroundDialogTemplate:
  .include "graphics/dialog/dialogTemplate.asm"

backgroundDialogIntro1:
  .include "graphics/dialog/intro01.asm"

backgroundDialogIntro2:
  .include "graphics/dialog/intro02.asm"

backgroundDialogIntro3:
  .include "graphics/dialog/intro03.asm"

backgroundDialogIntro4:
  .include "graphics/dialog/intro04.asm"

backgroundDialogIntro5:
  .include "graphics/dialog/intro05.asm"

backgroundDialogIntro6:
  .include "graphics/dialog/intro06.asm"

backgroundDialogIntro7:
  .include "graphics/dialog/intro07.asm"

attribute:
  .include "graphics/attributes.asm"

attributeTitle:
  .include "graphics/attributesTitle.asm"

attributeCredits:
  .include "graphics/attributesCredits.asm"

attributeDialog:
  .include "graphics/dialog/attributesIntro.asm"

  .org $FFFA
  .dw NMI
  .dw RESET
  .dw 0

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  .bank 2
  .org $0000
  .incbin "sprites.chr"
