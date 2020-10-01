class Keys
{
  boolean p2 = false;

  private boolean wDown = false;
  private boolean aDown = false;
  private boolean sDown = false;
  private boolean dDown = false;

  public Keys(boolean player2) {
    p2 = player2;
  }

  public boolean wDown()
  {
    return wDown;
  }

  public boolean aDown()
  {
    return aDown;
  }

  public boolean sDown()
  {
    return sDown;
  }

  public boolean dDown()
  {
    return dDown;
  }



  void onKeyPressed(char ch, int code)
  {
    if (!p2) {
      if (ch == 'W' || ch == 'w')
      {
        wDown = true;
      } else if (ch == 'A' || ch == 'a')
      {
        aDown = true;
      } else if (ch == 'S' || ch == 's')
      {
        sDown = true;
      } else if (ch == 'D' || ch == 'd')
      {
        dDown = true;
      }
    } else {
      if (code == 38)
        wDown = true;
      else if (code == 39)
        dDown = true;
      else if (code == 40)
        sDown = true;
      else if (code == 37)
        aDown = true;
    }
  }

  void onKeyReleased(char ch, int code)
  {
    if (!p2) {
      if (ch == 'W' || ch == 'w')
      {
        wDown = false;
      } else if (ch == 'A' || ch == 'a')
      {
        aDown = false;
      } else if (ch == 'S' || ch == 's')
      {
        sDown = false;
      } else if (ch == 'D' || ch == 'd')
      {
        dDown = false;
      }
    } else {
      if (code == 38)
        wDown = false;
      else if (code == 39)
        dDown = false;
      else if (code == 40)
        sDown = false;
      else if (code == 37)
        aDown = false;
    }
  }
}
