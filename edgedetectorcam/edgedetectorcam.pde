//EDGE DETECTION CAM
//NOTE: just be careful... if you reopen the cam and take pics, they might overwrite past pics taken by the cam...
/*
E= edge detection 
P= pencil (requires e to be pressed)
C= colored pencil (requires p to be pressed

*/
import ddf.minim.*;
import processing.video.*;

Capture cam;
String filename;
int num;
boolean stopped;
boolean edge, pencil, colorpencil = false; // edge techniques
final String end=".png";
Minim minim;
AudioPlayer player;
final int THRESHOLD = 20;
float[][][] orig;


void setup(){
 size (640, 500);
 
 orig = new float[width][height][3];
 
 String[] cameras = Capture.list();
 filename = "pic-";
 num = 1;
 
 if (cameras.length == 0) {
   println("There are no cameras available for capture.");
   exit();
  } else {
   println("Available cameras:");
   for (int i = 0; i < cameras.length; i++) {
     println(cameras[i]);
   }
  //initialize audio
  minim = new Minim(this);
  //  player = minim.loadFile(".mp3"); 
  
   // The camera can be initialized directly using an 
   // element from the array returned by list():
   cam = new Capture(this, cameras[0]);
    // initialize variables
   stopped = false;
   cam.start();
  }
}
void draw(){
  if(cam.available()) {
     cam.read();
  }
  
  image(cam,0,0);  
  
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  if (edge || pencil || colorpencil){
    loadPixels();
    for (int i = 1; i < width-1; i++){
     for (int j = 1; j < height-1; j++){
      orig[i][j][0] = pixels[j*width+i] >> 16 & 0xFF; // red via bit masking which makes it quicker
      orig[i][j][1] = pixels[j*width+i] >> 8 & 0xFF;     //green via bit masking which makes it quicker
      orig[i][j][2] = pixels[j*width+i] & 0xFF;    //blue via bit masking which makes it quicker 
      
     }
    }
  
  //calculating number to be compared to the threshold
   for (int i = 1; i < width-1; i++){
     for (int j = 1; j < height-1; j++){
       float value;
       float blues, reds, greens;
       reds=sqrt(sq(orig[i-1][j][0] - orig[i+1][j][0]) + sq(orig[i][j-1][0] - orig[i][j+1][0])); 
       blues=sqrt(sq(orig[i-1][j][1] - orig[i+1][j][1]) + sq(orig[i][j-1][1] - orig[i][j+1][1]));
       greens=sqrt(sq(orig[i-1][j][2] - orig[i+1][j][2]) + sq(orig[i][j-1][2] - orig[i][j+1][2]));
       value = (reds + greens + blues)/3;
       if(value > THRESHOLD){
         //set(i,j,color(255));   // pencil mode-> set is the slower way to set pixels
         if (pencil || colorpencil){
             if (colorpencil)
               pixels[j*width+i] = color(orig[i][j][0],orig[i][j][1],orig[i][j][2]);//colorpencil 
             else
               pixels[j*width+i] = color(0);//pencil    
         }
         else  
           pixels[j*width+i] = color(255); 
       }      
       else{
         if (pencil || colorpencil){
           pixels[j*width+i] = color(255); //pencil shading
         }else
           pixels[j*width+i] = color(0); //black with white edges
       }
      }
   
      updatePixels();
    }
  }
 
  
}

void keyPressed(){
  if (key == ' '){
      int mill = millis();
      cam.stop();
      saveFrame(filename+num+end);
      
      //while (millis()-mill<80){}
      cam.start();
      num++;
  }
   if (key== 's' || key == 'S'){
      System.out.println("sadf");      
      cam.stop();      
      if (stopped){
         cam.start();
         stopped = false;
      }
      else{
         cam.stop();
         stopped = true;
      }
    }
    
  if (key =='e' || key == 'E'){
    if (edge){
      edge = false;
    }else{
      edge = true;
    }
  }
  if (key=='p' || key =='P'){
    if (pencil){
      pencil = false;
    }
    else{
      pencil = true;
    }
  }
  if (key =='c' || key == 'C'){
    if (colorpencil)
      colorpencil = false;
    else
      colorpencil = true;
  }
    if (key == 'q' || key == 'Q'){
    edge = false;
    colorpencil = false;
    pencil = false;
    }
}