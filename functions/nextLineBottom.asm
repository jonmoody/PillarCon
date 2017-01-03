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
