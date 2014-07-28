//EDGE DETECTION/COLOR EFFECTS CAM
//NOTE: just be careful... if you reopen the cam and take pics, they might overwrite past pics taken by the cam...
/*
E= edge detection 
P= pencil (requires e to be pressed)
C= colored pencil (requires p to be pressed)
B= sepia
G = gray
*/

int counter;
import processing.video.*;

Capture cam;
String filename;
int num;
boolean stopped;
boolean edge, pencil, colorpencil = false; // edge techniques
boolean sepia;
boolean gray = false;
final String end=".png";
final int THRESHOLD = 35;
float[][][] ori;


void setup(){
 size (640, 500);
 
 ori = new float[width][height][3];
 
 String[] cameras = Capture.list();
 filename = "Pic";
 num = 1;
 
 if (cameras.length == 0) {
   println("There are no cameras available for capture.");
   exit();
  } else {
   println("Available cameras:");
   for (int i = 0; i < cameras.length; i++) {
     println(cameras[i]);
   }  
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
  counter++;
  System.out.println(counter);
  image(cam,0,0);  
  loadPixels();
 
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
  
  /*
  if (edge || pencil || colorpencil){
    loadPixels();
    for (int i = 1; i < width-1; i++){
     for (int j = 1; j < height-1; j++){
      ori[i][j][0] = pixels[j*width+i] >> 16 & 0xFF; // red via bit masking which makes it quicker
      ori[i][j][1] = pixels[j*width+i] >> 8 & 0xFF;     //green via bit masking which makes it quicker
      ori[i][j][2] = pixels[j*width+i] & 0xFF;    //blue via bit masking which makes it quicker 
      
     }
    }
  
  //calculating number to be compared to the threshold
   for (int i = 1; i < width-1; i++){
     for (int j = 1; j < height-1; j++){
       float value;
       float blues, reds, greens;
       reds=sqrt(sq(ori[i-1][j][0] - ori[i+1][j][0]) + sq(ori[i][j-1][0] - ori[i][j+1][0])); 
       blues=sqrt(sq(ori[i-1][j][1] - ori[i+1][j][1]) + sq(ori[i][j-1][1] - ori[i][j+1][1]));
       greens=sqrt(sq(ori[i-1][j][2] - ori[i+1][j][2]) + sq(ori[i][j-1][2] - ori[i][j+1][2]));
       value = (reds + greens + blues)/3;
       if(value > THRESHOLD){
         //set(i,j,color(255));   // pencil mode-> set is the slower way to set pixels
         if (pencil || colorpencil){
             if (colorpencil)
               pixels[j*width+i] = color(ori[i][j][0],ori[i][j][1],ori[i][j][2]);//colorpencil 
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
   }
  }
  */
  if (gray){
     
        for (int i = 1; i < width; i++){
          for (int j = 1; j < height; j++){            
             colorMode(RGB);    
            float r = pixels[j*width+i] >> 16 & 0xFF;
            float g = pixels[j*width+i] >> 8 & 0xFF;      
            float b = pixels[j*width+i] & 0xFF; 
           
            float newr = .3* r + .59 * g + .11 * b;        
            float newg = .3 * r + .59* g + .11 * b;
            float newb = .3 * r + .59 * g + .11 * b;
            
            if (newr >255){
              newr = 255;
            }
            if (newg >255){
              newg = 255;
            }
            if (newb >255){
              newb = 255;
            }
  
            pixels[j*width+i] = color(newr,newg,newb);
            
          }
      }     
    }
    else if (sepia){   
        for (int i = 0; i < width; i++){
          for (int j = 0; j < height; j++){

            colorMode(RGB);   
            
            float r = red( pixels[j*width+i]);
            float g = green( pixels[j*width+i]);     
            float b = blue( pixels[j*width+i]);
            
            float newr = .623 * r + .769 * g + .189 * b;        
            float newg = .339 * r + .686 * g + .168 * b;
            float newb = .292 * r + .534 * g + .131 * b;

            if (newr >255){
              newr = 255;
            }
            if (newg >255){
              newg = 255;
            }
            if (newb >255){
              newb = 255;
            }
            
           
          pixels[j*width+i] = color(newr,newg,newb);
                       
          colorMode(HSB);
          pixels[j*width+i] = color(hue(pixels[j*width+i]),saturation(pixels[j*width+i])+20,brightness(pixels[j*width+i]));
  
           
          }
        }
        
   
     }  
     updatePixels();
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
    if (key =='b' || key == 'B'){
      if (!sepia){
        gray = false;
        sepia =true; 
      }
      else  
        sepia = false;
    }
  
    if (key == 'g'|| key == 'G'){
        if (gray)
          gray = false;
        else{
          sepia = false;
          gray = true;
    }
        
    }
}
