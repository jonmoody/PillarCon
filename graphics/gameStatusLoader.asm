CheckGameVictory:
  LDA gameWin
  CMP #$00
  BEQ EndCheckGameVictory

  LDA gameWinLoaded
  CMP #$01
  BEQ EndCheckGameVictory

  JSR DisableGraphics

.ClearSpritesVictory:
  LDA #$00
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  INX
  BNE .ClearSpritesVictory

  LDA #LOW(backgroundGameWin)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundGameWin)
  STA pointerBackgroundHighByte
  JSR LoadBackground

  LDA #$01
  STA gameWinLoaded

  JSR EnableGraphics
EndCheckGameVictory:

CheckGameOver:
  LDA gameOver
  CMP #$00
  BEQ EndCheckGameOver

  LDA gameOverLoaded
  CMP #$01
  BEQ EndCheckGameOver

  JSR DisableGraphics

.ClearSpritesGameOver:
  LDA #$00
  STA $0100, x
  STA $0300, x
  STA $0400, x
  STA $0500, x
  STA $0600, x
  STA $0700, x
  INX
  BNE .ClearSpritesGameOver

  LDA #LOW(backgroundGameOver)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundGameOver)
  STA pointerBackgroundHighByte
  JSR LoadBackground

  LDA #$01
  STA gameOverLoaded

  JSR EnableGraphics
EndCheckGameOver:

CheckCreditsScreen:
  LDA creditsScreen
  CMP #$00
  BEQ EndCheckCreditsScreen

  LDA creditsScreenLoaded
  CMP #$01
  BEQ EndCheckCreditsScreen

  JSR DisableGraphics

  LDA #LOW(backgroundCredits)
  STA pointerBackgroundLowByte
  LDA #HIGH(backgroundCredits)
  STA pointerBackgroundHighByte
  JSR LoadBackground
  JSR LoadAttributeCredits

  LDA #$01
  STA creditsScreenLoaded

  JSR EnableGraphics
EndCheckCreditsScreen:
