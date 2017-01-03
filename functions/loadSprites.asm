LoadSprites:
  LDX #$00
LoadSpritesLoop:
  LDA sprites, x
  STA $0200, x
  INX
  CPX #$6C
  BNE LoadSpritesLoop
  RTS
