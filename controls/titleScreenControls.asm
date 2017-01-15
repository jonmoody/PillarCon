  LDA #$01
  STA $4016
  LDA #$00
  STA $4016

  LDA $4016       ; Player 1 - A
  LDA $4016       ; Player 1 - B

ReadSelect:
  LDA $4016       ; Player 1 - Select
  AND #%00000001
  BEQ SelectButtonRelease

  LDA titleScreen
  CMP #$00
  BEQ EndReadSelect

  LDA selectButtonHeldDown
  CMP #$01
  BEQ EndReadSelect

  LDA #$01
  STA selectButtonHeldDown

  LDA creditsOptionSelected
  CMP #$01
  BEQ SelectStartOption

  LDA #$22
  STA $2006
  LDA #$4C
  STA $2006
  LDA #$00
  STA $2007

  LDA #$22
  STA $2006
  LDA #$8C
  STA $2006
  LDA #$0A
  STA $2007

  LDA #01
  STA creditsOptionSelected

  JMP EndReadSelect

SelectStartOption:

  LDA #$22
  STA $2006
  LDA #$4C
  STA $2006
  LDA #$0A
  STA $2007

  LDA #$22
  STA $2006
  LDA #$8C
  STA $2006
  LDA #$00
  STA $2007

  LDA #$00
  STA creditsOptionSelected

  JMP EndReadSelect

SelectButtonRelease:
  LDA #$00
  STA selectButtonHeldDown

EndReadSelect:

ReadStart:
  LDA $4016       ; Player 1 - Start
  AND #%00000001
  BEQ EndReadStart

  LDA titleScreen
  CMP #$00
  BEQ EndReadStart

  LDA creditsOptionSelected
  STA creditsScreen
  CMP #$01
  BEQ LeaveTitleScreen

  LDA #$01
  STA introScene

LeaveTitleScreen:
  LDA #$00
  STA titleScreen

EndReadStart:

  LDA $4016       ; Player 1 - Up
  LDA $4016       ; Player 1 - Down
  LDA $4016       ; Player 1 - Left
  LDA $4016       ; Player 1 - Right
