DrawNextDialogScreen:
  INC currentDialogScreen

  JSR DisableGraphics

  JSR DrawTopSprite
  JSR DrawBottomSprite

  LDA currentDialogScreen
  CMP #$01
  BNE LoadIntro2

LoadIntro1:
  LDA #LOW(backgroundDialogTemplate)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogTemplate)
  STA pointerBackgroundHighByte
  JSR LoadBackground
  JSR LoadAttributeDialog
  JSR LoadDialogPalettes

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

  JSR WipeTopDialog
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

  JSR WipeBottomDialog
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

  JSR WipeTopDialog
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

  JSR WipeBottomDialog
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

  JSR WipeBottomDialog
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

  JSR WipeBottomDialog
  LDA #LOW(backgroundDialogIntro7)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro7)
  STA pointerBackgroundHighByte
  JSR LoadTopDialog
  JMP EndLoadingDialogBackground

LoadIntro8:
  LDA currentDialogScreen
  CMP #$08
  BNE LoadIntro9

  JSR WipeTopDialog
  LDA #LOW(backgroundDialogIntro8)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro8)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog
  JMP EndLoadingDialogBackground

LoadIntro9:
  LDA currentDialogScreen
  CMP #$09
  BNE LoadIntro10

  JSR WipeBottomDialog
  LDA #LOW(backgroundDialogIntro9)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro9)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog
  JMP EndLoadingDialogBackground

LoadIntro10:
  LDA currentDialogScreen
  CMP #$0A
  BNE LoadIntro11

  JSR WipeBottomDialog
  LDA #LOW(backgroundDialogIntro10)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro10)
  STA pointerBackgroundHighByte
  JSR LoadTopDialog
  JMP EndLoadingDialogBackground

LoadIntro11:
  LDA currentDialogScreen
  CMP #$0B
  BNE EndLoadingDialogBackground

  JSR WipeTopDialog
  LDA #LOW(backgroundDialogIntro11)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro11)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog

  LDA #$01
  STA endOfDialog
EndLoadingDialogBackground:
  RTS

DrawTopSprite:
  JSR LoadPlayerSprite

  LDA #$2F
  STA playerSprite1Y
  STA playerSprite2Y
  STA playerSprite3Y
  LDA #$37
  STA playerSprite4Y
  STA playerSprite5Y
  STA playerSprite6Y
  LDA #$3F
  STA playerSprite7Y
  STA playerSprite8Y
  STA playerSprite9Y

EndDrawTopSprite:
  RTS

DrawBottomSprite:
  JSR LoadTravelerSprite

  LDA #$30
  STA travelerSprite1X
  STA travelerSprite4X
  STA travelerSprite7X
  STA travelerSprite10X
  LDA #$38
  STA travelerSprite2X
  STA travelerSprite5X
  STA travelerSprite8X
  STA travelerSprite11X
  LDA #$40
  STA travelerSprite3X
  STA travelerSprite6X
  STA travelerSprite9X
  STA travelerSprite12X

  LDA #$A0
  STA travelerSprite1Y
  STA travelerSprite2Y
  STA travelerSprite3Y
  LDA #$A8
  STA travelerSprite4Y
  STA travelerSprite5Y
  STA travelerSprite6Y
  LDA #$B0
  STA travelerSprite7Y
  STA travelerSprite8Y
  STA travelerSprite9Y
  LDA #$B8
  STA travelerSprite10Y
  STA travelerSprite11Y
  STA travelerSprite12Y

EndDrawBottomSprite:
  RTS
