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
  
