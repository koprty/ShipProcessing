/*
Bugs:
1)resaves files if webcam was opened before
*/
import ddf.minim.*;
import processing.video.*;


Capture cam;
String filename;
int num;
boolean stopped;
boolean gray;
boolean rand;
final String end=".jpg";
Minim minim;
AudioPlayer player;

void setup() {
  size(640, 480);

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
    stopped = false;
    gray = false;
    cam.start();     
  }      
}

void draw() {
  if(cam.available()) {
     cam.read();
  }
 
  image(cam, 0, 0);
 
  
  // The following does the same, and is faster when just drawing the image
  // without any additional resizing, transformations, or tint.
  //set(0, 0, cam);
 
  if (mousePressed){
    int mill = millis();
    saveFrame(filename+num+end);
    cam.stop();
    while (millis()-mill<100){}
    cam.start();
    num++;
  }

}
void keyPressed(){
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
 
}

