//EDGE DETECTION WITH loaded IMAGE
//press e to edge, p to pencil, c to color, g to grayscale, b to blob, q to quit all unnatural modes
PImage img;
final int THRESHOLD = 35;
float[][][] orig;
PImage edged;
boolean edge,pencil, colorpencil,gray;
void setup(){
 size (800, 500);
 img = loadImage("../pics/tiger.jpg");
 
 orig = new float[img.width][img.height][3];

 pencil = false;
 edge = false;
 colorpencil = false;
 gray = false;
 
}
void draw(){
  image(img,0, 0);
  loadPixels();
  
    if (gray){
     
        for (int i = 1; i < width -1; i++){
          for (int j = 1; j < height-1; j++){            
             colorMode(RGB);    
            float r = red( pixels[j*width+i]);
            float g = green( pixels[j*width+i]);     
            float b = blue( pixels[j*width+i]);
            
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
  else if (edge || pencil || colorpencil){
    for (int i = 1; i < img.width -1; i++){
      for (int j = 1; j < img.height-1; j++){
        orig[i][j][0] = get(i,j) >> 16 & 0xFF;
        orig[i][j][1] = get(i,j) >> 8 & 0xFF;     
         orig[i][j][2] = get(i,j) & 0xFF;    //blue via bit masking which makes it quicker 
      }
    }
  //calculating number to be compared to the threshold
   for (int i = 1; i < width-1; i++){
     for (int j = 1; j < height-1; j++){
       float value;
       float blues, reds, greens;
       reds=sqrt(sq(orig[i-1][j][0] - orig[i+1][j][0]) + sq(orig[i][j-1][0] - orig[i][j+1][0])); 
       greens=sqrt(sq(orig[i-1][j][1] - orig[i+1][j][1]) + sq(orig[i][j-1][1] - orig[i][j+1][1]));
       blues=sqrt(sq(orig[i-1][j][2] - orig[i+1][j][2]) + sq(orig[i][j-1][2] - orig[i][j+1][2]));
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
}

void keyPressed(){
 if (key =='e' || key == 'E'){
    if (edge){
      edge = false;
    }else{
      edge = true;
    }
    gray = false;
  }
  if (key=='p' || key =='P'){
    if (pencil){
      pencil = false;
    }
    else{
      pencil = true;
    }
    gray = false;
  }
  if (key =='c' || key == 'C'){
    if (colorpencil)
      colorpencil = false;
    else
      colorpencil = true;
    gray = false;
  }
  if (key == 'q' || key == 'Q'){
    edge = false;
    colorpencil = false;
    pencil = false;
    gray = false;
  }
 
  
  
  
}