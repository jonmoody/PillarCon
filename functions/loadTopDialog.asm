LoadTopDialog:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$8C
  STA $2006

  LDY #$00
.Loop:
  LDA [pointerBackgroundLowByte], y
  STA $2007

  INY
  JSR NextLineTop

  CPY #$70
  BNE .Loop
  RTS
