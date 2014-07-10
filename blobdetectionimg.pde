// Blob detection  with image
import ddf.minim.*;
import processing.video.*;
PImage img;
final int THRESHOLD = 55;
float[][][] orig;
PImage edged;
boolean[] unchecked;
color blobcolor;
boolean edge;
boolean pencil;
boolean colorpencil;

void setup(){
 
 
 img = loadImage("../img/img2.png");
 size (img.width,img.height);
 orig = new float[img.width][img.height][3];
 unchecked = new boolean[img.width*img.height];
 edge = false;
 pencil = false; 
 colorpencil = false;
    
}
void draw(){
  image(img,0, 0);
  img.loadPixels();
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
    }
   updatePixels(); 
  }

  if (mousePressed){
    loadPixels();
    for (int i = 1; i < width-1; i++){
     for (int j = 1; j < height-1; j++){
      orig[i][j][0] = pixels[j*width+i] >> 16 & 0xFF; // red via bit masking which makes it quicker
      orig[i][j][1] = pixels[j*width+i] >> 8 & 0xFF;     //green via bit masking which makes it quicker
      orig[i][j][2] = pixels[j*width+i] & 0xFF;    //blue via bit masking which makes it quicker    
     }
    }
    
    int x = mouseX;
    int y= mouseY;
    blobcolor = color (255,255,0);
    //blobcolor = color(orig[x][y][0],orig[x][y][1],orig[x][y][2]);
    //pixels[y*width+x];
    fill(x,y);
    
  }
}

void fill(int x, int y){
  try{
    loadPixels();
    if (unchecked[y*width+x]){
  
  //calculating number to be compared to the threshold
       float value;
       float blues, reds, greens;
       reds=sqrt(sq(orig[x-1][y][0] - orig[x+1][y][0]) + sq(orig[x][y-1][0] - orig[x][y+1][0])); 
       blues=sqrt(sq(orig[x-1][y][1] - orig[x+1][y][1]) + sq(orig[x][y-1][1] - orig[x][y+1][1]));
       greens=sqrt(sq(orig[x-1][y][2] - orig[x+1][y][2]) + sq(orig[x][y-1][2] - orig[x][y+1][2]));
       value = (reds + greens + blues)/3;
       if(value <  THRESHOLD){
          pixels[y*width+x] = blobcolor; 
          unchecked[y*width+x]=false; 
          fill(x-1,y);
          fill(x,y-1);
          fill(x,y+1);
          fill(x+1,y);
       }
    }
  }
  catch (ArrayIndexOutOfBoundsException e){
   System.out.println("ERROR"); 
  }
}
void keyPressed(){
  
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
  
  

