import java.util.Random;

class Game
{
  private Random rnd;
  private int width;
  private int height;
  private int[][] board;
  private Keys keys;
  private int playerLife;
  private Dot player;
  private Dot[] enemies;
  //
  //
  private Dot[] foods = new Dot[0];
  private Dot player2 = null;
  public int player2Life = 100;
  private Keys keys2 = null;

  Game(int width, int height, int numberOfEnemies, int numberOfFoods)
  {
    if (width < 10 || height < 10)
    {
      throw new IllegalArgumentException("Width and height must be at least 10");
    }
    if (numberOfEnemies < 0)
    {
      throw new IllegalArgumentException("Number of enemies must be positive");
    } 
    //
    //
    if (numberOfFoods < 0)
      throw new IllegalArgumentException("Number of foods must be 0 or greater!");
    //
    //
    this.rnd = new Random();
    this.board = new int[width][height];
    this.width = width;
    this.height = height;
    keys = new Keys(false);
    player = new Dot(0, 0, width-1, height-1);
    enemies = new Dot[numberOfEnemies];
    for (int i = 0; i < numberOfEnemies; ++i)
    {
      enemies[i] = new Dot(width-1, height-1, width-1, height-1);
    }
    this.playerLife = 100;

    //
    //
    player2 = new Dot(width - 1, 0, width-1, height-1);
    keys2 = new Keys(true);

    foods = new Dot[numberOfFoods];
    for (int i = 0; i < numberOfFoods; i++)
      foods[i] = new Dot((int)random(width - 1), (int)random(height - 1), width - 1, height - 1);
  }

  public int getWidth()
  {
    return width;
  }

  public int getHeight()
  {
    return height;
  }

  public int getPlayerLife()
  {
    return playerLife;
  }

  public void onKeyPressed(char ch)
  {
    keys.onKeyPressed(ch, 0);
    keys2.onKeyPressed(' ', keyCode);
  }

  public void onKeyReleased(char ch)
  {
    keys.onKeyReleased(ch, 0);
    keys2.onKeyReleased(' ', keyCode);
  }

  public void update()
  {
    if (playerLife > 0 && player2Life > 0) {
      updatePlayer();
      updateEnemies();
      checkForCollisions();
      clearBoard();
      populateBoard();

      //
      //
      UpdateFood();
    } else {
      background(0);

      if (playerLife > 0 )
        text("Player 1 Wins!", width/2, height/2);
      else 
      text("Player 2 Wins!", width/2, height/2);
    }
  }



  public int[][] getBoard()
  {
    //ToDo: Defensive copy?
    return board;
  }

  private void clearBoard()
  {
    for (int y = 0; y < height; ++y)
    {
      for (int x = 0; x < width; ++x)
      {
        board[x][y]=0;
      }
    }
  }

  private void updatePlayer()
  {
    //Update player
    if (keys.wDown() && !keys.sDown())
    {
      player.moveUp();
    }
    if (keys.aDown() && !keys.dDown())
    {
      player.moveLeft();
    }
    if (keys.sDown() && !keys.wDown())
    {
      player.moveDown();
    }
    if (keys.dDown() && !keys.aDown())
    {
      player.moveRight();
    }

    if (keys2.wDown() && !keys2.sDown())
      player2.moveUp();
    if (keys2.aDown() && !keys2.dDown())
      player2.moveLeft();
    if (keys2.sDown() && !keys2.wDown())
      player2.moveDown();
    if (keys2.dDown() && !keys2.aDown())
      player2.moveRight();
  }

  private void updateEnemies()
  {
    for (int i = 0; i < enemies.length; ++i)
    {
      Dot p = null;
      if (dist(player.getX(), player.getY(), enemies[i].getX(), enemies[i].getY())
        < dist(player2.getX(), player2.getY(), enemies[i].getX(), enemies[i].getY()))
        p = player;
      else
        p = player2;

      //Should we follow or move randomly?
      //2 out of 3 we will follow..
      if (rnd.nextInt(3) < 2)
      {
        //We follow
        int dx = p.getX() - enemies[i].getX();
        int dy = p.getY() - enemies[i].getY();
        if (abs(dx) > abs(dy))
        {
          if (dx > 0)
          {
            //Player is to the right
            enemies[i].moveRight();
          } else
          {
            //Player is to the left
            enemies[i].moveLeft();
          }
        } else if (dy > 0)
        {
          //Player is down;
          enemies[i].moveDown();
        } else
        {//Player is up;
          enemies[i].moveUp();
        }
      } else
      {
        //We move randomly
        int move = rnd.nextInt(4);
        if (move == 0)
        {
          //Move right
          enemies[i].moveRight();
        } else if (move == 1)
        {
          //Move left
          enemies[i].moveLeft();
        } else if (move == 2)
        {
          //Move up
          enemies[i].moveUp();
        } else if (move == 3)
        {
          //Move down
          enemies[i].moveDown();
        }
      }
    }
  }

  private void populateBoard()
  {
    //Insert player
    board[player.getX()][player.getY()] = 1;
    //Insert enemies
    for (int i = 0; i < enemies.length; ++i)
    {
      board[enemies[i].getX()][enemies[i].getY()] = 2;
    }

    //
    //
    for (int i = 0; i < foods.length; i++)
      board[foods[i].getX()][foods[i].getY()] = 3;

    board[player2.getX()][player2.getY()] = 4;
  }

  private void checkForCollisions()
  {
    //Check enemy collisions
    for (int i = 0; i < enemies.length; ++i)
    {
      if (enemies[i].getX() == player.getX() && enemies[i].getY() == player.getY())
      {
        //We have a collision
        --playerLife;
      }
      if (enemies[i].getX() == player2.getX() && enemies[i].getY() == player2.getY())
        player2Life--;
    }

    //
    //
    for (int i = 0; i < foods.length; i++) {
      if (foods[i].getX() == player.getX() && foods[i].getY() == player.getY()) {
        playerLife += 10;
        if (playerLife > 100)
          playerLife = 100;
        foods[i] = new Dot((int)random(width - 1), (int)random(height - 1), width - 1, height - 1);
      } else if (foods[i].getX() == player2.getX() && foods[i].getY() == player2.getY()) {
        player2Life += 10;
        if (player2Life > 100)
          player2Life = 100;
        foods[i] = new Dot((int)random(width - 1), (int)random(height - 1), width - 1, height - 1);
      }
    }
  }


  //
  //
  private void UpdateFood() {
    for (int i = 0; i < foods.length; ++i)
    {
      Dot food = foods[i];
      for (int j = 0; j < 2; j++) {
        Dot p = null;
        if (j == 0)
          p = player;
        else
          p = player2;

        if (rnd.nextInt(3) < 2)
        {
          //We follow
          int dx = p.getX() - food.getX();
          int dy = p.getY() - food.getY();
          if (abs(dx) < abs(dy))
          {
            if (dx < 0)
              food.moveRight();
            else
              food.moveLeft();
          } else if (dy < 0)
            food.moveDown();
          else
            food.moveUp();
        } else
        {
          int move = rnd.nextInt(4);
          if (move == 0)
            food.moveRight();
          else if (move == 1)
            food.moveLeft();
          else if (move == 2)
            food.moveUp();
          else if (move == 3)
            food.moveDown();
        }
      }
    }
  }
}
