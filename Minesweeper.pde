import de.bezier.guido.*;
//Declare and initialize constants NUM_ROWS and NUM_COLS = 20
private MSButton[][] buttons; //2d array of minesweeper buttons
private ArrayList <MSButton> mines; //ArrayList of just the minesweeper buttons that are mined
public String gameState = "Ongoing";
void setup ()
{
    buttons = new MSButton[8][8];
    mines = new ArrayList <MSButton>();
    size(400, 400);
    textAlign(CENTER,CENTER);
    
    // make the manager
    Interactive.make( this );
    
    //your code to initialize buttons goes here
    for(int i = 0; i<8;i++){
      for(int z = 0; z<8; z++){
        buttons[i][z] = new MSButton(i,z);
        if(Math.random()<0.15){
          mines.add(buttons[i][z]);
        }
      }
    }
    for(int i = 0;i<mines.size();i++){
      //System.out.print(mines.get(i).getRow());
      ////System.out.println(mines.get(i).getCol());
    }
    
    setMines();
}
public void setMines()
{
    //your code
}

public void draw ()
{
    background( 0 );
    if(gameState == "WON")
        displayWinningMessage();
     if(gameState == "LOST")
      displayLosingMessage();
}
public boolean isWon()
{
    //your code here
    return false;
}
public void displayLosingMessage()
{
    //your code here
    for(int i = 0;i<mines.size();i++){
      mines.get(i).clicked = true;
    }
    textSize(30);
    fill(0);
    text("You Lost LMAO",200,200);
}
public void displayWinningMessage()
{
    //your code here
    //textSize(30);
    fill(0);
    text("You Won, Congrats!",200,200);
}
public boolean isValid(int r, int c)
{
    //your code here
    if(r>=0&&r<8&&c>=0&&c<8){
      return true;
    }
    return false;
}
public int countMines(int row, int col)
{
  //System.out.println("countMines called"+row+col);
  MSButton[][] grid=buttons;
    int numMines = 0;
    for(int i = row-1;i<row+2;i++){

    for(int ai = col-1;ai<col+2;ai++){
      if((i==row&&col==ai)){
        continue;
      }
      //System.out.println("minescontains called");
      if(isValid(i,ai)&&mines.contains(grid[i][ai])){
        numMines++;
      }
    }
    
  }
    //your code here
    //System.out.println("numMines:"+numMines);
    return numMines;
}
public class MSButton
{
    private int myRow, myCol;
    private float x,y, width, height;
    private boolean clicked, flagged;
    private String myLabel;
    
    public MSButton ( int row, int col )
    {
         width = 400/8;
         height = 400/8;
        myRow = row;
        myCol = col; 
        x = myCol*width;
        y = myRow*height;
        myLabel = "";
        flagged = clicked = false;
        Interactive.add( this ); // register it with the manager
        //System.out.println(""+myRow+" "+myCol);
    }
    private void click(int r,int t){
      //System.out.println("Clicked:"+r+" "+t);
      if(!buttons[r][t].isClicked()){
        //buttons[r][t].setClicked(true);
        //System.out.println("Passed first if statement");
        buttons[r][t].setClicked(true);
        int c = countMines(r,t);
            if(c==0){
              for(int i = r-1; i<r+2;i++){
                for(int z = t-1; z<t+2;z++){
                  if(isValid(i,z)){
                    click(i,z);
                  }
                }
              }
            }else{

              buttons[r][t].setLabel(parseInt((countMines(r,t)));
            }
        }
    }
    public int getRow(){return myRow;}
    public int getCol(){return myCol;}
    // called by manager
    public void mousePressed () 
    {
      if(gameState == "Ongoing"){
      //System.out.println("beginning mouse pressed function");
      //clicked = true;
      if(mouseButton==LEFT&&!flagged){

        //your code here
        if(mines.contains(this)){
          displayLosingMessage();
          gameState = "LOST";
        }else{
          //System.out.println("clicking at"+myRow+" "+myCol);
          click(myRow,myCol);
        }
      }else{
        if(!clicked){
        if(mouseButton==RIGHT){
          if(flagged){
            flagged = false;
            clicked = false;
          }else{
            flagged = true;
          }
        }
        }
      }
      if(allFlagsPlaced()&&allSpacesClicked()&&!(gameState=="LOST")){
        gameState = "WON";
      }
      }
    }
    public void draw () 
    {    
        if (flagged)
            fill(0);
         else if( clicked && mines.contains(this) ) 
             fill(255,0,0);
        else if(clicked)
            fill( 200 );
        else 
            fill( 100 );

        rect(x, y, width, height);
        fill(0);
        //textSize(12);
        text(myLabel,x+width/2,y+height/2);
        if(gameState == "WON")
          displayWinningMessage();
        if(gameState == "LOST")
          displayLosingMessage();
    }
    public void setLabel(String newLabel)
    {
        myLabel = newLabel;
    }
    public void setLabel(int newLabel)
    {
        myLabel = ""+ newLabel;
    }
    public boolean isFlagged()
    {
        return flagged;
    }
    public boolean isClicked(){return clicked;}
    public void setClicked(boolean m){clicked = m;}
}
public boolean allFlagsPlaced(){
  boolean uh = true;
  for(int i = 0; i<mines.size();i++){
    if(!mines.get(i).isFlagged()){
      uh = false;
    }
  }
  return uh;
}
public boolean allSpacesClicked(){
  boolean uh = true;
  for(int r = 0; r<buttons.length;r++){
    for(int c = 0; c<buttons[0].length; c++){
      if(!buttons[r][c].isClicked()&&!mines.contains(buttons[r][c])){
        uh = false;
      }
    }
  }
  return uh;
}
