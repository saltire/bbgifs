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

int samplesPerFrame = 16;
int numFrames = 240;
float shutterAngle = 2;

boolean recording = false,
  preview = true;

void setup() {
  size(750, 750, P3D);
  smooth(8);
  rectMode(CENTER);
  result = new float[width*height][3];
  noFill();
  strokeWeight(1.7);
  blendMode(ADD);
}

color[] cs = { #ff0000, #00ff00, #0000ff};

float x, y, z, tt;
int N = 2400;

color c1 = #d70441, c2 = #f4e904, c3 = #009978, c4 = #5e3688;
color myCol(float q) {
  q = (q+120)%1;
  if (q<.25)
    return lerpColor(c1, c2, map(q, 0, .25, 0, 1));
  else if (q<.45)
    return lerpColor(c2, c3, map(q, .3, .45, 0, 1));
  else if (q< .75)
    return lerpColor(c3, c4, map(q, .45, .75, 0, 1));
  else
    return lerpColor(c4, c1, map(q, .75, 1, 0, 1));
}

color myCol;
float qq;
float d;

float R = 140, l = 180;
float th, r = 20;
float amt;

float hu, rot;

void hexx(float q) {
  beginShape();
  for (int i=0; i<=6; i++) {
    th = TWO_PI*i/6 + rot;
    myCol = myCol(0.2*cos(th) + hu);

    myCol = lerpColor(#000000, myCol, 0.08);
    stroke(myCol);

    vertex(r*cos(th), r*sin(th));
  }
  endShape();
}

int n = 2400;

void draw_() {
  background(0,0,0);
  push();
  translate(width/2, height/2);
    for (int i=0; i<n; i++) {
      th = TWO_PI*i/n;
      qq = i*1.0/n;
      hu = qq;
      rot = - TWO_PI*qq;
      push();
      x = -R*cos(th)*sin(TWO_PI*t);
      y = R*sin(th);
      z = R*cos(th)*cos(TWO_PI*t);

      r = 40/(1+.007*z);

      translate(x,y);
      hexx(t);
      pop();
    }
  pop();
}
