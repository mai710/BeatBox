Maxim maxim;
AudioPlayer [] players;
String [] sounds;

boolean [] snSeq;

int playHead;
int playPos;
int prevPlayPos;

int xSpacing;
int ySpacing;
boolean [][] beats;

void setup()
{
  //draw background
  frameRate(60);
  size(960,640);
  background(255);
  xSpacing = width/16;
  for(int i=0; i<width; i++){
    if(i % xSpacing == 0){
      line(i,0, i,height);
    }
  }
  ySpacing = height/8;
  for(int i=0; i<height; i++){
    if(i % ySpacing == 0){
      line(0,i, width,i);
    }
  }
  
  //init sounds
  sounds = new String[]{"bbox-a-misc.wav", "snare.wav", "tom-2.wav", "pedal-hi-hat.wav", "snare-rim.wav", "kick-bass.wav", "un-hunh.wav", "ready.wav"};
  //init audio players
  maxim = new Maxim(this);
  players = new AudioPlayer[8];
  for(int i=0; i<8; i++){
    players[i] = maxim.loadFile(sounds[i]);
//    players[i].speed(i+1);
    players[i].setLooping(false);
  }
  
  //init the play head
  playHead = 0;//represents which frame we're on
  playPos = 0; //represents which column we're on
  prevPlayPos = 0;
  
  //init the beats as "off"
  beats = new boolean[16][8];
  for(int i=0; i<16; i++){
    for(int k=0; k<8; k++){
      beats[i][k] = false;
    }
  }
}

void draw()
{
  playHead++;
  
  //run the playhead through
  if(playHead % 15 == 0){ //1/4 a second has passed
    prevPlayPos = playPos;
    playPos = (playPos + 1) % 16;
    println(playPos);
    for(int i=0; i<8; i++){
      if(beats[playPos][i]){
        players[i].cue(0);
        players[i].play();
      }
    }
  
    
    fill(200,0,0,20);
    rect(playPos*xSpacing,0, xSpacing, height);
   
   
    //clear the playhead color
    fill(255);
    rect(prevPlayPos*xSpacing,0, xSpacing, height);
    //redraw the horizontal lines
    for(int i=0; i<height; i++){
      if(i % ySpacing == 0){
        line(0,i, width,i);
      }
    }
    //redraw any "ON" beats
    for(int i=0; i<8; i++){
      if(beats[prevPlayPos][i]){
        fill(0);
        rect(prevPlayPos*xSpacing, i*ySpacing, xSpacing, ySpacing);
      }
    }
    
  }
}

void mousePressed()
{
  int [] box = checkHit(mouseX, mouseY);
  int startX = box[0]*xSpacing;
  int startY = box[1]*ySpacing;
  
  if(beats[box[0]][box[1]]){
    fill(255);
    beats[box[0]][box[1]] = false;
  }
  else{
    fill(0);
    beats[box[0]][box[1]] = true;
  }
 
  rect(startX, startY, xSpacing, ySpacing);
//  players[box[1]-1].cue(0);
//  players[box[1]-1].play();
}

int [] checkHit(int touchX, int touchY)
{
  int [] pos = new int[2];
  pos[0] = (touchX / xSpacing);
  pos[1] = (touchY / ySpacing);
  
  return pos;
}
