PlayProjectileSound:
  LDA #%00000001
  STA $4015       ; Enable Square 1

  LDA #%10011011  ; Duty 10, Use Volume, Length Enabled, Volume 11
  STA $4000

  LDA #Cs5
  ASL a
  TAY
  LDA noteTable, y
  STA $4002
  LDA noteTable+1, y
  ADC #%00010000
  STA $4003
  RTS
