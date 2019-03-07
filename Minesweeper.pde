

import de.bezier.guido.*;
private final static int NUM_ROWS = 40;
private final static int NUM_COLS = 40;
private final static int NUM_BOMBS = 100;
//Declare and initialize NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> bombs; //ArrayList of just the minesweeper buttons that are mined

void setup ()
{
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    buttons = new MSButton[NUM_ROWS][NUM_COLS];
    for (int i = 0; i < NUM_ROWS; i++)
    {
      for (int j = 0; j < NUM_COLS; j++)
      {
        buttons[i][j] = new MSButton(i,j);
      }
    }
    bombs = new ArrayList <MSButton>();
    
    setBombs();
}
public void setBombs()
{
    //your code
    while (bombs.size() < NUM_BOMBS)
    {
      int h = (int)(Math.random() * NUM_ROWS);
      int w = (int)(Math.random() * NUM_COLS);
      if (bombs.contains(buttons[h][w]) == false)
      {  
        bombs.add(buttons[h][w]);
        System.out.println(h + ", " + w);
      }
    }
}

public void draw ()
{
    background( 0 );
    if(isWon())
        displayWinningMessage();
}
public boolean isWon()
{
    //your code here
   for (int i = 0; i < NUM_ROWS; i++)
   {
     for (int j = 0; j < NUM_COLS; j++)
     {
       if (!bombs.contains(buttons[i][j]))
       {
         if (!buttons[i][j].isClicked())
          return false; 
       }
     }
   }
    return true;
}
public void displayLosingMessage()
{
    //your code here
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][10].setLabel("L");
    buttons[9][11].setLabel("O");
    buttons[9][12].setLabel("S");
    buttons[9][13].setLabel("E");
    for (int a = 0; a < bombs.size(); a++)
    {
      bombs.get(a).clicked = true;
    }
    noLoop();
}
public void displayWinningMessage()
{
    //your code here
    buttons[9][6].setLabel("Y");
    buttons[9][7].setLabel("O");
    buttons[9][8].setLabel("U");
    buttons[9][10].setLabel("W");
    buttons[9][11].setLabel("I");
    buttons[9][12].setLabel("N");
    buttons[9][13].setLabel("!");
    //noLoop();
}

public class MSButton
{
    private int r, c;
    private float x,y, width, height;
    private boolean clicked, marked;
    private String label;
    
    public MSButton ( int rr, int cc )
    {
        width = 400/NUM_COLS;
        height = 400/NUM_ROWS;
        r = rr;
        c = cc; 
        x = c*width;
        y = r*height;
        label = "";
        marked = clicked = false;
        Interactive.add( this ); // register it with the manager
    }
    public boolean isMarked()
    {
        return marked;
    }
    public boolean isClicked()
    {
        return clicked;
    }
    // called by manager
    
    public void mousePressed () 
    {
        if (clicked == false)
        {  
          if (mouseButton == RIGHT)
          {
            marked = !marked;
            if (marked == false)
              clicked = false;
          }
          if (mouseButton == LEFT)
          {
            if (!marked)
            {
              clicked = true;
              if (bombs.contains(this))
                displayLosingMessage();
              else if (countBombs(r,c) > 0)
                setLabel("" + countBombs(r,c));
              else
              {
                for (int a = r - 1; a <= r + 1; a++)
                {
                  for (int b = c - 1; b <= c + 1; b++)
                  {
                    if (isValid(a,b))
                      buttons[a][b].mousePressed();
                  }
                }
              }
            }
          }
        }
        //your code here
    }

    public void draw () 
    {    
        if (marked)
            fill(0);
        else if( clicked && bombs.contains(this) ) 
            fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        text(label,x+width/2,y+height/2);
    }
    public void setLabel(String newLabel)
    {
        label = newLabel;
    }
    public boolean isValid(int r, int c)
    {
        //your code here
        if ((r >= 0 && r < NUM_ROWS) && (c >= 0 && c < NUM_COLS))
          return true;
        return false;
    }
    public int countBombs(int row, int col)
    {
        int numBombs = 0;
        //your code here
        for (int i = row - 1; i <= row + 1; i++)
        {
          for (int j = col - 1; j <= col + 1; j++)
          {
            if (isValid(i,j) && bombs.contains(buttons[i][j]))
            {
              if (i != row || j != col)
                numBombs++;
            }
          }
        }
           
        return numBombs;
    }
}
