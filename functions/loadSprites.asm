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

HidePlayerSprite:
  LDX #$00
.Loop
  LDA #$FF
  STA $0324, x
  INX
  INX
  INX
  INX
  CPX #$24
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

ShowTravelerSprite:
  LDA #$40
  STA travelerSprite1Y
  STA travelerSprite2Y
  STA travelerSprite3Y
  LDA #$48
  STA travelerSprite4Y
  STA travelerSprite5Y
  STA travelerSprite6Y
  LDA #$50
  STA travelerSprite7Y
  STA travelerSprite8Y
  STA travelerSprite9Y
  LDA #$58
  STA travelerSprite10Y
  STA travelerSprite11Y
  STA travelerSprite12Y
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

LoadPlayerTimeBubbleSprite:
  LDX #$00
.Loop
  LDA spritePlayerTimeBubble, x
  STA $03CC, x
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

HidePlayerTimeBubbleSprite:
  LDX #$00
.Loop
  LDA #$FF
  STA $03CC, x
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

  JSR ShowTravelerSprite
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

AlternateBubbleAndPlayer:
  LDA playerVisibility
  CMP #$00
  BEQ .ShowBubble

  JSR LoadPlayerSprite
  JSR HidePlayerTimeBubbleSprite
  JMP .ToggleVisibility

.ShowBubble:
  JSR LoadPlayerTimeBubbleSprite
  JSR HidePlayerSprite

.ToggleVisibility:
  LDA playerVisibility
  EOR #$01
  STA playerVisibility
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
