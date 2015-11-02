PImage img;
float[][][] orig;

boolean sepia,gray,invert;
void setup(){
    size (800, 500);
    img = loadImage("../pics/tiger.jpg");
 
    orig = new float[width][height][3];

    sepia = false;
    gray = false;
    invert = false;
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
    else if (sepia){   
        for (int i = 0; i < width; i++){
          for (int j = 0; j < height; j++){
            colorMode(HSB);
            pixels[j*width+i] = color(hue(pixels[j*width+i]),saturation(pixels[j*width+i]),brightness(pixels[j*width+i])-0);
            colorMode(RGB);    
            float r = red( pixels[j*width+i]);
            float g = green( pixels[j*width+i]);     
            float b = blue( pixels[j*width+i]);
            
          
            float newr = .678 * r + .769 * g + .189 * b;        
            float newg = .349 * r + .686 * g + .168 * b;
            float newb = .272 * r + .534 * g + .131 * b;
            /*
            
            float newr = .393 * r + .769 * g + .189 * b;        
            float newg = .349 * r + .686 * g + .168 * b;
            float newb = .272 * r + .534 * g + .131 * b;
            */
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
         else if (invert){   
        for (int i = 0; i < width; i++){
          for (int j = 0; j < height; j++){
            colorMode(HSB);
            pixels[j*width+i] = color(hue(pixels[j*width+i]),saturation(pixels[j*width+i]),brightness(pixels[j*width+i])-0);
            colorMode(RGB);    
            float r = red( pixels[j*width+i]);
            float g = green( pixels[j*width+i]);     
            float b = blue( pixels[j*width+i]);
                 
            float newr = 255-r;        
            float newg = 255-g;
            float newb = 255-b;
           
            pixels[j*width+i] = color(newr,newg,newb);
          }
        }
        
   
     }
   else{
     noTint();
   }  
   
    updatePixels();     
}


void keyPressed(){
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
    
    if (key == 'i'|| key == 'I'){
        invert = true;
       
    }
    
    if (key == 'q'|| key == 'Q'){
        sepia = false;
        gray = false;
        invert = false;
       
    }
  
}
  