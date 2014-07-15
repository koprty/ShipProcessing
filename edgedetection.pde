//EDGE DETECTION WITH loaded IMAGE
//press e to edge, p to pencil, c to color,q to quit all unnatural modes
PImage img;
final int THRESHOLD = 35;
float[][][] orig;
PImage edged;
boolean edge,pencil, colorpencil;
void setup(){
 size (800, 640);
 img = loadImage("robot.jpg");
 
 orig = new float[img.width][img.height][3];

 pencil = false;
 edge = false;
 colorpencil = false;
 
}
void draw(){
  image(img,0, 0);
  loadPixels();
  if (edge || pencil || colorpencil){
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
  
  if (key =='g'|| key == 'G'){
    
    
  }
  
  
  
}
