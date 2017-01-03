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
  LDA currentDialogScreen
  CMP #$08
  BNE LoadIntro9

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

  LDA #LOW(backgroundDialogIntro11)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundDialogIntro11)
  STA pointerBackgroundHighByte
  JSR LoadBottomDialog

  LDA #$01
  STA endOfDialog
EndLoadingDialogBackground:
  RTS
