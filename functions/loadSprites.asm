LoadSprites:
  LDX #$00
LoadSpritesLoop:
  LDA sprites, x
  STA $0300, x
  INX
  CPX #$6C
  BNE LoadSpritesLoop
  RTS

LoadPlayerSprite:
  LDX #$00
.Loop
  LDA spritePlayer, x
  STA $0324, x
  INX
  CPX #$24
  BNE .Loop
  RTS

HideSprites:
  LDX #$00
.Loop
  LDA #$00
  STA $0300, x
  INX
  CPX #$6C
  BNE .Loop
  RTS
