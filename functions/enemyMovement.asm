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
