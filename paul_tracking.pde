import processing.video.*;

color colorToMatch = color(255);
float tolerance = 20;
Capture webcam;
int xpos = 0;
int ypos = 0;
PImage img;

void setup() {
  background(0);
  fullScreen();
  stroke(255);
  fill(0);
  
  xpos = (width-640)/2;
  ypos = (height-480)/2;
  
  img = loadImage("crtfilter.png");

  String[] inputs = Capture.list();
  if (inputs.length == 0) {
    println("Couldn't detect any webcams connected!");
    exit();
  }
  webcam = new Capture(this, inputs[0]);
  webcam.start();
}


void draw() {
  if (webcam.available()) {
    background(0);

    webcam.read();
    image(webcam, xpos,ypos);

    ArrayList<PVector> list = findColor(webcam, colorToMatch, tolerance);
    
    for (int i = 0; i < list.size() - 3; i+=3) {
      stroke(random(255), random(255), random(255));
      fill(random(255), random(255), random(255));
      triangle(list.get(i).x+xpos, list.get(i).y+ypos, list.get(i+1).x+xpos, list.get(i+1).y+ypos, list.get(i+2).x+xpos, list.get(i+2).y+ypos);
    }
    image(img, xpos, ypos);
  }
}


// click anywhere on the image to set the target color
void mousePressed() {
  loadPixels();
  colorToMatch = pixels[mouseY*width+mouseX];
}


ArrayList<PVector> findColor(PImage in, color c, float tolerance) {

  ArrayList<PVector> results = new ArrayList<PVector>();
  
  float matchR = c >> 16 & 0xFF;
  float matchG = c >> 8 & 0xFF;
  float matchB = c & 0xFF;
  
  in.loadPixels();
  for (int y=0; y<in.height; y++) {
    for (int x=0; x<in.width; x++) {

      color current = in.pixels[y*in.width+x];
      float r = current >> 16 & 0xFF;
      float g = current >> 8 & 0xFF;
      float b = current & 0xFF;
      
      if (r >= matchR-tolerance && r <=matchR+tolerance &&
        g >= matchG-tolerance && g <=matchG+tolerance &&
        b >= matchB-tolerance && b <=matchB+tolerance) {

        results.add(new PVector(x, y));
      }
    }
  }
  return results;
}