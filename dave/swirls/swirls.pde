// by dave
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

int samplesPerFrame = 8;
int numFrames = 240;
float shutterAngle = .6;

boolean recording = false,
  preview = true;

void setup() {
  size(750, 750, P3D);
  smooth(8);
  rectMode(CENTER);
  pixelDensity(recording ? 1 : 2);
  result = new float[width*height][3];
  noFill();
  strokeWeight(1.8);
}

color c1 = #d70441, c2 = #f4e904, c3 = #009978, c4 = #5e3688;
color myCol(float q) {
  q = (q+120)%1;
  if (q<.25)
    return  lerpColor(c1, c2, map(q, 0, .25, 0, 1));
  else if (q<.45)
    return  lerpColor(c2, c3, map(q, .25, .45, 0, 1));
  else if (q<.75)
    return  lerpColor(c3, c4, map(q, .45, .75, 0, 1));
  else
    return  lerpColor(c4, c1, map(q, .75, 1, 0, 1));
}

float x, y, z, tt;
int N = 120, n = 48;

float qq, th;

void draw_() {
  background(0);
  push();
  translate(width/2, height/2);
  blendMode(SCREEN);
  noFill();
  for (int a=0; a<n; a ++) {
    beginShape();
    for (int i=0; i<N; i++) {
      qq = i/float(N-1);
      stroke(myCol(t+.5*qq+.5*a/n));
      th = PI*qq + TAU*t + TAU*a/n;
      x = 240*cos(th) + 24*cos(3*th);
      y = 48*sin(2*th) + map(a,0,n-1,-200,200);
      vertex(x, y);
    }
    endShape();
  }
  pop();
}
