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
