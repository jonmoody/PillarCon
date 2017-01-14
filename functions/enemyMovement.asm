MoveEnemyLeft:
  DEC enemySprite1X
  DEC enemySprite2X
  DEC enemySprite3X
  DEC enemySprite4X
  DEC enemySprite5X
  DEC enemySprite6X
  DEC enemySprite7X
  DEC enemySprite8X
  DEC enemySprite9X
  RTS

MoveEnemyRight:
  INC enemySprite1X
  INC enemySprite2X
  INC enemySprite3X
  INC enemySprite4X
  INC enemySprite5X
  INC enemySprite6X
  INC enemySprite7X
  INC enemySprite8X
  INC enemySprite9X
  RTS

FlipEnemySprite:
  LDA enemyDirection
  CMP #$01
  BNE .FlipLeft

  JMP .FlipRight

.FlipLeft:
  LDA #%00000010
  STA enemySprite1Attr
  STA enemySprite2Attr
  STA enemySprite3Attr
  STA enemySprite4Attr
  STA enemySprite5Attr
  STA enemySprite6Attr
  STA enemySprite7Attr
  STA enemySprite8Attr
  STA enemySprite9Attr

  LDA #$89
  STA enemySprite1Tile
  LDA #$8B
  STA enemySprite3Tile
  LDA #$8C
  STA enemySprite4Tile
  LDA #$8E
  STA enemySprite6Tile
  LDA #$8F
  STA enemySprite7Tile
  LDA #$91
  STA enemySprite9Tile

  JMP EndFlipEnemySprite

.FlipRight:
  LDA #%01000010
  STA enemySprite1Attr
  STA enemySprite2Attr
  STA enemySprite3Attr
  STA enemySprite4Attr
  STA enemySprite5Attr
  STA enemySprite6Attr
  STA enemySprite7Attr
  STA enemySprite8Attr
  STA enemySprite9Attr

  LDA #$8B
  STA enemySprite1Tile
  LDA #$89
  STA enemySprite3Tile
  LDA #$8E
  STA enemySprite4Tile
  LDA #$8C
  STA enemySprite6Tile
  LDA #$91
  STA enemySprite7Tile
  LDA #$8F
  STA enemySprite9Tile

EndFlipEnemySprite:
  RTS
