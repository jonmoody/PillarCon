LoadSprites:
  LDX #$00
.Loop:
  LDA sprites, x
  STA $0300, x
  INX
  CPX #$6C
  BNE .Loop
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

LoadEnemySprite:
  LDX #$00
.Loop
  LDA spriteEnemy, x
  STA $0348, x
  INX
  CPX #$24
  BNE .Loop
  RTS

LoadTravelerSprite:
  LDX #$00
.Loop
  LDA spriteTraveler, x
  STA $036C, x
  INX
  CPX #$30
  BNE .Loop
  RTS

HideTravelerSprite:
  LDX #$00
.Loop
  LDA #$FF
  STA $036C, x
  INX
  INX
  INX
  INX
  CPX #$30
  BNE .Loop
  RTS

LoadTravelerTimeBubbleSprite:
  LDX #$00
.Loop
  LDA spriteTravelerTimeBubble, x
  STA $039C, x
  INX
  CPX #$24
  BNE .Loop
  RTS

HideTravelerTimeBubbleSprite:
  LDX #$00
.Loop
  LDA #$FF
  STA $039C, x
  INX
  INX
  INX
  INX
  CPX #$24
  BNE .Loop
  RTS

AlternateBubbleAndTraveler:
  LDA travelerVisibility
  CMP #$00
  BEQ .ShowBubble

  JSR LoadTravelerSprite
  JSR HideTravelerTimeBubbleSprite
  JMP .ToggleVisibility

.ShowBubble:
  JSR LoadTravelerTimeBubbleSprite
  JSR HideTravelerSprite

.ToggleVisibility:
  LDA travelerVisibility
  EOR #$01
  STA travelerVisibility
  RTS

HideSprites:
  LDX #$00
.Loop
  LDA #$00
  STA $0300, x
  INX
  CPX #$FF
  BNE .Loop
  RTS
