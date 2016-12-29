  .db $FF, $70, $00, $30 ; Not in use anymore
  .db $FF, $71, $00, $38
  .db $FF, $72, $00, $30
  .db $FF, $73, $00, $38

  .db $FF, $74, $03, $00 ; Projectile
  .db $FF, $74, $02, $00 ; Enemy Projectile

  .db $FF, $70, %01000001, $B8 ; Derp
  .db $FF, $73, %01000001, $B0
  .db $FF, $72, %01000001, $B8

  .db $B0, $7D, $03, $30 ; Player character
  .db $B0, $7E, $03, $38
  .db $B0, $7F, $03, $40
  .db $B8, $80, $03, $30
  .db $B8, $81, $03, $38
  .db $B8, $82, $03, $40
  .db $C0, $83, $03, $30
  .db $C0, $84, $03, $38
  .db $C0, $85, $03, $40

  .db $B0, $89, $02, $B0 ; Enemy character
  .db $B0, $8A, $02, $B8
  .db $B0, $8B, $02, $C0
  .db $B8, $8C, $02, $B0
  .db $B8, $8D, $02, $B8
  .db $B8, $8E, $02, $C0
  .db $C0, $8F, $02, $B0
  .db $C0, $90, $02, $B8
  .db $C0, $91, $02, $C0
