part of spaceinvader;

class Play extends State {
  Play(String name, [String nextState]) : super(name, nextState);

  run() {
    
    Background bg = new Background.textureatlas(this, 'purple', 'spaceinvader',
        isMovable: true, repeatMode: Background.REPEAT_XY)
        ..vx = 100
        ..vy = 250;

    int score = 0;
    Text scoreText = new Text(this, "Score: $score", size: 20);

    /*Button leftButton = new Button.textureatlas(this, 'flatDark23',
        'spaceinvader', 'L')
        ..x = 0
        ..y = game.stage.sourceHeight - 100;*/
    Button leftButton = game.add.button('flatDark23', 'L')
        ..x = 0
        ..y = game.stage.sourceHeight - 100;

    /*Button rightButton = new Button.textureatlas(this, 'flatDark24',
        'spaceinvader', "R");*/
    Button rightButton = game.add.button('flatDark24', 'R');
    rightButton
        ..x = game.stage.sourceWidth - rightButton.width.toInt()
        ..y = game.stage.sourceHeight - 100;

    Ship player = new Ship.textureatlas(this, 'playerShip1_blue', 'spaceinvader' 
        )
        ..x = game.stage.sourceWidth ~/ 2
        ..y = game.stage.sourceHeight - 200
        ..vx = 300;

    leftButton.onTouchBegin.listen((_) {
      player.movingLeft = true;
    });

    leftButton.onTouchEnd.listen((_) {
      player.movingLeft = false;
    });

    rightButton.onTouchBegin.listen((_) {
      player.movingRight = true;
    });

    rightButton.onTouchEnd.listen((_) {
      player.movingRight = false;
    });


    Group<Sprite> bullets = new Group<Sprite>();
    for (int i = 0; i < 5; i++) {      
      bullets.add(game.add.sprite('laserBlue01', addToStage: false)..vy=-500);
    }

    Ufo ufo;
    Group<Ufo> ufos = new Group<Ufo>();
    for (int j = 0; j < 1; j++) {
      for (int i = 0; i < 7; i++) {
        ufo = new Ufo.textureatlas(this, 'ufoRed', 'spaceinvader')
            ..x = (i * 100 + 10)
            ..y = 100 * j
            ..vy = 30
            ..alive = true;
        ufos.add(ufo);
      }
    }


    Sound laserSound = new Sound(this, "laser");

    Sprite bullet;
    Timer bulletTimer = new Timer.periodic(new Duration(milliseconds: 450), 
      (_){
        if (bullets.any((item) => !item.alive)) {
          bullet = bullets.firstWhere((item) => !item.alive)
              ..x = player.x + player.width ~/ 2
              ..y = player.y
              ..alive = true;

          bullet.addToStage();
          laserSound.play();
      }
    });

    game.stage.onKeyDown.listen((value) {
      switch (value.keyCode) {
        case KeyCode.LEFT:
          player.movingLeft = true;
          break;
        case KeyCode.RIGHT:
          player.movingRight = true;
          break;
      }

    });

    game.stage.onKeyUp.listen((value) {
      switch (value.keyCode) {
        case KeyCode.LEFT:
          player.movingLeft = false;
          break;
        case KeyCode.RIGHT:
          player.movingRight = false;
          break;
      }
    });

    game.stage.onEnterFrame.listen((_) {

      if (!ufos.anyAlive()) {
        bulletTimer.cancel();
        killState();
      }

      /*ufos.forEachAlive((ufo) {
        bullets.forEachAlive((bullet) {
          if (ufo.hitTestObject(bullet)) {
            ufo.alive = false;
            bullet.removeFromStage();
            scoreText.text = "Score: ${score+=10}";
          }
        });
        if (ufo.hitTestObject(player)) {
          bulletTimer.cancel();
          killState();
        }
      });*/
      
      game.physics.collison(ufos, bullets, (Ufo ufo,Sprite bullet){
        ufo.alive = false;
        bullet.removeFromStage();
        scoreText.text = "Score: ${score+=10}";
      });
      
      game.physics.collison(ufos, player, (Ufo ufo, Ship player){
        bulletTimer.cancel();
        killState();
      });

    });
  }
}
