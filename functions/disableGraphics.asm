DisableGraphics:
  LDX #$00
  STX $2000    ; Disable NMI
  STX $2001    ; Disable rendering
  STX $4010    ; Disable DMC IRQs
  RTS
