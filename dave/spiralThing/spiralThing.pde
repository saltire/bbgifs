// by dave @beesandbombs :)

float[][] result;
float t, c;

float ease(float p) {
  p = c01(p);
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  p = c01(p);
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

float c01(float g) {
  return constrain(g, 0, 1);
}

float millisFrame1;

void draw() {
  if (recording) {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      t %= 1;
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += sq(red(pixels[i])/255.0);
        result[i][1] += sq(green(pixels[i])/255.0);
        result[i][2] += sq(blue(pixels[i])/255.0);
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = color(255*sqrt(result[i][0]/samplesPerFrame),
        255*sqrt(result[i][1]/samplesPerFrame),
        255*sqrt(result[i][2]/samplesPerFrame));
    updatePixels();

    saveFrame("f###.png");
    if (frameCount==numFrames)
      exit();
  } else if (preview) {
    if (frameCount==1)
      millisFrame1 = millis();
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    t = ((millis()-millisFrame1)/(20.0*numFrames))%1;
    draw_();
  } else {
    t = mouseX*1.0/width;
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    draw_();
  }
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 4;
int numFrames = 300;
float shutterAngle = .3;

boolean recording = false,
  preview = true;

void setup() {
  size(750, 750, P3D);
  smooth(8);
  result = new float[width*height][3];
  noStroke();
  ortho();
}

float x, y, z, tt;

float myR(float q) {
  return lerp(200, 80, ease(q)) + 60*exp(-50*sq(q-.35)) - 45*exp(-90*sq(q-.5));
}
float myG(float q) {
  return lerp(60, 10, q) + map(cos(TAU*q), 1, -1, 0, 180) + 45*exp(-150*sq(q-.33)) -25*exp(-120*sq(q-.51));
}
float myB(float q) {
  return map(cos(.92*TAU*q*q), 1, -1, 0, 150) + lerp(36, 100, q);
}
color myCol(float q) {
  q = c01(q);
  return color(myR(q), myG(q), myB(q));
}

float l = 90, w = 40;
float qq;
int N = 1200;
float r = 120, th, ph;

PImage fr;

void draw_() {
  background(0);
  push();
  translate(width/2, height/2);

  scale(1.2);

  beginShape(TRIANGLE_STRIP);
  for(int i=0; i<N; i++){
    qq = i/float(N-1);
    th = TAU*t;
    x = r*sin(3*(th - PI*qq));
    y = r*sin(2*(th - PI*qq)-TAU*t);
    z = r*cos(th-PI*qq-TAU*t);

    ph = TAU*6*(qq-t);

    fill(myCol(.9*(qq)));
    vertex(x+l/2*cos(ph),y+l/2*sin(ph),z);
    fill(myCol(.9*(qq)+.1));
    vertex(x-l/2*cos(ph),y-l/2*sin(ph),z);
  }
  endShape();

  pop();
}
