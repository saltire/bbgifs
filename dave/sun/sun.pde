// by dave :)

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

float c01(float g) {
  return constrain(g, 0, 1);
}

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

    saveFrame("f###.png");
    if (frameCount==numFrames)
      exit();
  } else if (preview) {
    c = mouseY*1.0/height;
    if (mousePressed)
      println(c);
    t = (millis()/(20.0*numFrames))%1;
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

int samplesPerFrame = 8;
int numFrames = 240;
float shutterAngle = .5;

boolean recording = false,
  preview = true;

void setup() {
  size(760, 760, P3D);
  smooth(8);
  result = new int[width*height][3];
  stroke(255);
  noFill();
  strokeWeight(3);
}

float x, y, z, tt;
int N = 12;
PImage fr;
float r = 180, th, tw, mtw = 1.5*PI;
int n = 1080;

float x_, y_;

void twister(float rot) {
  beginShape();
  for (int i=0; i<n; i++) {
    th = TWO_PI*i/n;
    x_ = r*cos(th);
    y_ = r*sin(th);

    tw = mtw*sin(th) + rot;

    x = x_*cos(tw);
    y = y_;
    z = x_*sin(tw);

    stroke(lerpColor(c1,c2,map(z*cos(TWO_PI*t) + x*sin(TWO_PI*t),-r,r,0,1)));

    vertex(x, y, z);
  }
  endShape(CLOSE);
}

float sc;

color c1 = #ff0000, c2 = #ffff00;

void draw_() {
  background(10,12,18);
  push();
  translate(width/2, height/2);
  translate(0, 0, r);

  sc = map(cos(TWO_PI*t), 1, -1, 0, 1);
  sc = lerp(0.25, 3, ease(sc,3));

  scale(1, 1, sc);

  strokeWeight(4/pow(sc, 1/3.0));
  for (int a=0; a<5; a++) {
    push();
    twister(TWO_PI*(a+2*t)/5);
    pop();
  }
  pop();



  fr = get();
  fr.loadPixels();
  loadPixels();
  for (int i=0; i<pixels.length; i++) {
    pixels[i] = color(
      red(fr.pixels[constrain(i-1, 0, pixels.length-1)]),

      green(fr.pixels[constrain(i, 0, pixels.length-1)]),
      blue(fr.pixels[constrain(i+1, 0, pixels.length-1)]));
  }


  updatePixels();
}
