int[][] result;
float t, c;

float ease(float p) {
  return 3*p*p - 2*p*p*p;
}

float ease(float p, float g) {
  if (p < 0.5)
    return 0.5 * pow(2*p, g);
  else
    return 1 - 0.5 * pow(2*(1 - p), g);
}

float mn = .5*sqrt(3), ia = atan(sqrt(.5));

void push() {
  pushMatrix();
  pushStyle();
}

void pop() {
  popStyle();
  popMatrix();
}

float c01(float g) {
  return constrain(g, 0, 1);
}

void draw() {

  if (!recording) {
    if (mouseControl) {
      t = mouseX * 1.0 / width;
      c = mouseY * 1.0 / height;

      if (mousePressed) {
        println(c);
      }
    }
    else {
      t = norm((frameCount - 1) % numFrames, 0, numFrames);
    }
    draw_();
  } else {
    for (int i=0; i<width*height; i++)
      for (int a=0; a<3; a++)
        result[i][a] = 0;

    c = 0;
    for (int sa=0; sa<samplesPerFrame; sa++) {
      t = map(frameCount-1 + sa*shutterAngle/samplesPerFrame, 0, numFrames, 0, 1);
      draw_();
      loadPixels();
      for (int i=0; i<pixels.length; i++) {
        result[i][0] += pixels[i] >> 16 & 0xff;
        result[i][1] += pixels[i] >> 8 & 0xff;
        result[i][2] += pixels[i] & 0xff;
      }
    }

    loadPixels();
    for (int i=0; i<pixels.length; i++)
      pixels[i] = 0xff << 24 |
        int(result[i][0]*1.0/samplesPerFrame) << 16 |
        int(result[i][1]*1.0/samplesPerFrame) << 8 |
        int(result[i][2]*1.0/samplesPerFrame);
    updatePixels();

    saveFrame("f###.gif");
    if (frameCount==numFrames)
      exit();
  }
}

//////////////////////////////////////////////////////////////////////////////

int samplesPerFrame = 4;
int numFrames = 180;
float shutterAngle = .6;

boolean recording = false;
boolean mouseControl = false;

void setup() {
  size(720, 720, P3D);
  pixelDensity(recording ? 1 : 2);
  smooth(8);
  result = new int[width*height][3];
  rectMode(CENTER);
  fill(32);
  noStroke();
  blendMode(MULTIPLY);
}

float x, y, z, tt;
int N = 8;
float r = 250;
int n = 120, m = 120;
float qq;
float wh = 16;
float sw = .2;

void circ(float q) {
  for (int i=0; i<N; i++)
    slice(map(i+.5-sw, 0, N, -r, r), map(i+.5+sw, 0, N, -r, r), q);
}

void waveVertex(float x_, float y_, float q) {
  vertex(x_, y_+wh*sin(.02*x_ + TWO_PI*t + q));
}

void slice(float y1, float y2, float q) {
  beginShape();
  for (int i=0; i<n; i++) {
    qq = i/float(n);
    y = lerp(y1, y2, qq);
    x = -sqrt(r*r-y*y);
    waveVertex(x, y, q);
  }
  for (int i=0; i<m; i++) {
    qq = i/float(m);
    y = y2;
    x = lerp(-sqrt(r*r-y*y), sqrt(r*r-y*y), qq);
    waveVertex(x, y, q);
  }
  for (int i=0; i<n; i++) {
    qq = i/float(n-1);
    y = lerp(y2, y1, qq);
    x = sqrt(r*r-y*y);
    waveVertex(x, y, q);
  }
  for (int i=0; i<m; i++) {
    qq = i/float(m);
    y = y1;
    x = lerp(sqrt(r*r-y*y), -sqrt(r*r-y*y), qq);
    waveVertex(x, y, q);
  }
  endShape();
}

void draw_() {
  background(250);
  push();
  translate(width/2, height/2);
  fill(#30E0FF);
  circ(0);
  fill(#FD22F3);
  circ(TWO_PI/3);
  fill(#FFE210);
  circ(2*TWO_PI/3);
  pop();
}
