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

  .include "functions/enableGraphics.asm"
  .include "functions/disableGraphics.asm"
  .include "functions/vBlank.asm"
  .include "functions/loadSprites.asm"
  .include "functions/loadPalettes.asm"
  .include "functions/loadDialogPalettes.asm"
  .include "functions/loadAttribute.asm"
  .include "functions/loadAttributeTitle.asm"
  .include "functions/loadAttributeCredits.asm"
  .include "functions/loadAttributeDialog.asm"
  .include "functions/loadBackground.asm"
  .include "functions/nextLineTop.asm"
  .include "functions/nextLineBottom.asm"
  .include "functions/loadTopDialog.asm"
  .include "functions/loadBottomDialog.asm"
  .include "functions/drawHearts.asm"
  .include "functions/loseHealth.asm"
  .include "functions/drawNextDialogScreen.asm"
  .include "functions/wipeDialog.asm"

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

  JMP EndCheckIntroDialog

EndCheckingDelay:

  LDA advanceDialog
  CMP #$01
  BEQ DrawDialog

  LDA #$01
  STA dialogDelay

  LDA introDialog
  CMP #$01
  BNE EndCheckIntroDialog

  LDA introDialogLoaded
  CMP #$01
  BEQ EndCheckIntroDialog

DrawDialog:
  JSR DrawNextDialogScreen

  ; JSR LoadAttributeDialog
  ; JSR LoadDialogPalettes

  LDA #$01
  STA introDialogLoaded

  LDA #$00
  STA advanceDialog
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

backgroundDialogIntro8:
  .include "graphics/dialog/intro08.asm"

backgroundDialogIntro9:
  .include "graphics/dialog/intro09.asm"

backgroundDialogIntro10:
  .include "graphics/dialog/intro10.asm"

backgroundDialogIntro11:
  .include "graphics/dialog/intro11.asm"

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
