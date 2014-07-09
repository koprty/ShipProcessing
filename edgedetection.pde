//EDGE DETECTION WITH loaded IMAGE

PImage img;
final int THRESHOLD = 55;
float[][][] orig;
PImage edged;

void setup(){
 size (800, 640);
 
 img = loadImage("robot.jpg");
 orig = new float[img.width][img.height][3];
 noLoop(); 
  
}
void draw(){
  image(img,0, 0);
  img.loadPixels();
  PImage edged = createImage(img.width, img.height, RGB);
  for (int i = 1; i < img.width -1; i++){
    for (int j = 1; j < img.height-1; j++){
      orig[i][j][0] = get(i,j) >> 16 & 0xFF;
      orig[i][j][1] = get(i,j) & 0xFF;    //blue via bit masking which makes it quicker 
      orig[i][j][2] = get(i,j) >> 8 & 0xFF;     
    }
  }
  //calculating number to be compared to the threshold
  for (int i = 1; i < img.width-1; i++){
    for (int j = 1; j < img.height-1; j++){
      float value;
      float blues, reds, greens;
      reds=sqrt(sq(orig[i-1][j][0] - orig[i+1][j][0]) + sq(orig[i][j-1][0] - orig[i][j+1][0])); 
      blues=sqrt(sq(orig[i-1][j][1] - orig[i+1][j][1]) + sq(orig[i][j-1][1] - orig[i][j+1][1]));
      greens=sqrt(sq(orig[i-1][j][2] - orig[i+1][j][2]) + sq(orig[i][j-1][2] - orig[i][j+1][2]));
      value = (reds + blues + greens)/3;
      if(value > THRESHOLD){
        set(i,j,color(255)); //black with white edges
        //set(i,j,color(0)); // pencil mode
      }
      else{
        set(i,j,color(0)); //black with white edges
        //set(i,j,color(255));   // pencil mode
      }
      
    }
  } 
 
}
