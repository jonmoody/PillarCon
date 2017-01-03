LoadDialogPalettes:
  LDA $2002
  LDA #$3F
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
LoadDialogPalettesLoop:
  LDA paletteDialog, x
  STA $2007
  INX
  CPX #$20
  BNE LoadDialogPalettesLoop
  RTS
