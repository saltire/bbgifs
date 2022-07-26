// by dave @beesandbombs

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
int numFrames = 144;
float shutterAngle = 1;

boolean recording = false,
  preview = true;

void setup() {
  size(750, 750, P3D);
  smooth(8);
  rectMode(CENTER);
  pixelDensity(recording ? 1 : 2);
  result = new int[width*height][3];
  noStroke();
  blendMode(EXCLUSION);
}

color[] rgb = { #ff0000, #00ff00, #0000ff};

float x, y;
int N = 17;
float l = 24;

float atans(float x_, float y_) {  // like atan2... but for a square!
  if (x_ == 0 && y_ == 0)
    return 0;

  float xa = x_/max(abs(x_), abs(y_));
  float ya = y_/max(abs(x_), abs(y_));

  if (xa == 1)
    return map(ya, -1, 1, 0, 0.25);
  else if (ya == 1)
    return map(xa, 1, -1, .25, .5);
  else if (xa == -1)
    return map(ya, 1, -1, .5, .75);
  else if (ya==-1)
    return map(xa, -1, 1, .75, 1);

  return 0;
}

float easedSine(float q) {
  float es = map(cos(TWO_PI*q), 1, -1, 0, 1);
  return lerp(-1, 1, ease(es, 6));
}

float diamondDist, diamondSize = 1530, rgbOffset = 0.025;

void draw_() {
  background(240);
  push();
  translate(width/2, height/2);

  fill(255);
  for (int i=-N; i<N; i++) {
    for (int j=-N; j<N; j++) {
      x = i*l;
      y = j*l;

      if ((i+j)%2 == 0)
        square(x, y, l);
    }
  }

  for (int a=0; a<3; a++) {
    fill(rgb[a]);
    for (int i=-N; i<N; i++) {
      for (int j=-N; j<N; j++) {
        x = (i+.5)*l;
        y = (j+.5)*l;

        diamondDist = max(abs(x+y), abs(x-y))/diamondSize;


        x -= l/2*easedSine(t - 2*atans(x, y) - rgbOffset*a );
        y += l/2*easedSine(t - diamondDist - rgbOffset*a);

        if ((i+j)%2 != 0)
          square(x, y, l/2);
      }
    }
  }
  pop();
}
