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
  BEQ .FlipRight

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

EndFlipEnemySprite:
  RTS
