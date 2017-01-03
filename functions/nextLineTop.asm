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
