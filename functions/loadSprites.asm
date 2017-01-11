LoadSprites:
  LDX #$00
LoadSpritesLoop:
  LDA sprites, x
  STA $0300, x
  INX
  CPX #$6C
  BNE LoadSpritesLoop
  RTS
