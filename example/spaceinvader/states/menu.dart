part of spaceinvader;

class Menu extends State {
  Menu(String name, [String nextState]) : super(name, nextState);

  run() {

    Text titleText = new Text(this, "SpaceInvader")
        ..x = 200
        ..y = 100
        ..defaultTextFormat.size = 56
        ..width = 600;

    String instructions = "You can move with left(<-) and right(->) cursor.";
    Text instructionsText = new Text(this, instructions)
        ..x = 40
        ..y = 300
        ..defaultTextFormat.size = 28
        ..width = 800;

    Button btn = new Button(this, "buttonUp", "continue")
        ..setCoordinates(300, 400)
        /*..onMouseClick.listen((_) {
          killteState();

        })*/
        ..onTouchEnd.listen((_) {
          game.stage.removeEventListeners("touchEnd");
          killteState();
        });


    const spaceBar = 32;
    game.stage.onKeyDown.listen((value) {
      if (value.keyCode == spaceBar) {
        game.stage.removeEventListeners("keyDown");
        killteState();
      }
    });
  }
}
