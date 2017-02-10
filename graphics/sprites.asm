  .db $FF, $70, $00, $30 ; Not in use anymore
  .db $FF, $71, $00, $38

spriteProjectile:
  .db $FF, $74, $03, $00
  .db $FF, $74, $03, $00
  .db $FF, $74, $03, $00

spriteEnemyProjectile:
  .db $FF, $74, $02, $00

  .db $FF, $70, %01000001, $B8 ; Derp
  .db $FF, $73, %01000001, $B0
  .db $FF, $72, %01000001, $B8

spritePlayer:
  .db $A8, $7D, $03, $30
  .db $A8, $7E, $03, $38
  .db $A8, $7F, $03, $40
  .db $B0, $80, $03, $30
  .db $B0, $81, $03, $38
  .db $B0, $82, $03, $40
  .db $B8, $83, $03, $30
  .db $B8, $84, $03, $38
  .db $B8, $85, $03, $40

spriteEnemy:
  .db $A8, $89, $02, $B0
  .db $A8, $8A, $02, $B8
  .db $A8, $8B, $02, $C0
  .db $B0, $8C, $02, $B0
  .db $B0, $8D, $02, $B8
  .db $B0, $8E, $02, $C0
  .db $B8, $8F, $02, $B0
  .db $B8, $90, $02, $B8
  .db $B8, $91, $02, $C0

spriteTraveler:
  .db $40, $A9, $01, $B0
  .db $40, $AA, $01, $B8
  .db $40, $AB, $01, $C0
  .db $48, $AC, $01, $B0
  .db $48, $AD, $01, $B8
  .db $48, $AE, $01, $C0
  .db $50, $AF, $01, $B0
  .db $50, $B0, $01, $B8
  .db $50, $B1, $01, $C0
  .db $58, $B2, $01, $B0
  .db $58, $B3, $01, $B8
  .db $58, $B4, $01, $C0

spriteTravelerTimeBubble:
  .db $48, $B5, $01, $B0
  .db $48, $B6, $01, $B8
  .db $48, $B7, $01, $C0
  .db $50, $B8, $01, $B0
  .db $50, $B9, $01, $B8
  .db $50, $BA, $01, $C0
  .db $58, $BB, $01, $B0
  .db $58, $BC, $01, $B8
  .db $58, $BD, $01, $C0

spritePlayerTimeBubble:
  .db $A8, $B5, $01, $30
  .db $A8, $B6, $01, $38
  .db $A8, $B7, $01, $40
  .db $B0, $B8, $01, $30
  .db $B0, $B9, $01, $38
  .db $B0, $BA, $01, $40
  .db $B8, $BB, $01, $30
  .db $B8, $BC, $01, $38
  .db $B8, $BD, $01, $40
