LoadBackground:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
  LDY #$00
.Loop:
  LDA [pointerBackgroundLowByte], y
  STA $2007

  INY
  CPY #$00
  BNE .Loop

  INC pointerBackgroundHighByte
  INX
  CPX #$04
  BNE .Loop
  RTS

ClearBackground:
  LDA $2002
  LDA #$20
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
  LDY #$00
.Loop:
  LDA #$00
  STA $2007

  INY
  CPY #$00
  BNE .Loop

  INX
  CPX #$04
  BNE .Loop
  RTS

LoadTimeTravelTransition:
  LDA $2002
  LDA #$21
  STA $2006
  LDA #$00
  STA $2006

  LDX #$00
.Loop:
  LDA timeTravelTransition, x
  STA $2007

  INX
  CPX #$E0
  BNE .Loop
  RTS
