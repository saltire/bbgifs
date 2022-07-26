// by davey @beesandbombs

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

int samplesPerFrame = 4;
int numFrames = 144;
float shutterAngle = .6;

boolean recording = false,
  preview = true;

void setup() {
  size(750, 750, P3D);
  smooth(8);
  rectMode(CENTER);
  pixelDensity(recording ? 1 : 2);
  result = new float[width*height][3];
  fill(32);
  noStroke();
  ortho();
}

float x, y, z, tt;
int N = 12;
float l, L = 16;
float qq;
float ascent;
float noiseScale = 0.006, noiseAmt = 2;
color RED = #d02030, BLACK = #202020, WHITE = #fafafa;

void draw_() {
  background(RED);
  push();

  translate(width/2, height/2);
  scale(.7);
  rotateX(-ia);
  rotateY(-QUARTER_PI);
  for (int a=-N; a<N; a++) {
    z = a*L;
    push();
    translate(0, 0, z);
    for (int i=-N; i<N; i++) {
      for (int j=-N; j<N; j++) {
        x = (i+.5)*L;
        y = (j+.5)*L;
        tt = (t + 2*noiseAmt - noiseAmt*noise(noiseScale*x+123, noiseScale*y+234, noiseScale*z+345))%1;

        if (tt <= .25) {
          qq = ease(4*tt);
          fill(lerpColor(RED, BLACK, qq));
          l = L*qq;
          ascent = 0;
        } else {
          qq = (map(tt, .25, 1, 0, 1));
          fill(lerpColor(BLACK, WHITE, ease(qq)));
          l = L*(1-ease(qq));
          ascent = -180*sq(qq);
        }

        push();
        translate(x, y+40+ascent);
        box(l);
        pop();
      }
    }
    pop();
  }

  pop();
}
