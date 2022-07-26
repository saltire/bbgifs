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
int numFrames = 240;
float shutterAngle = .5;

boolean recording = false,
  preview = true;

void setup() {
  size(750, 750, P3D);
  smooth(8);
  rectMode(CENTER);
  pixelDensity(recording ? 1 : 2);
  result = new int[width*height][3];
  strokeWeight(2);
  noFill();

  blendMode(ADD);
}

color[] cs = { #d00000, #00d000, #0000d0};

float x, y, z, tt;
int N = 8;

float r = 20;


float qq, tick;

void hex(float q) {
  beginShape();
  for (int i=0; i<3; i++) {
    for (int j=0; j<64; j++) {
      qq = j/64.0;
      x = lerp(-r*mn, r*mn, qq);
      y = map(j, 0, 64, r, r/2);
      tick = c01(map(qq, .25, .75, 0, 1));
      tick = abs(2*tick-1);
      tick = map(tick, 0, 1, r/2*ease(c01(1.5*q-0.5*tick)), 0);
      y = map(abs(2*qq-1), 0, 1, r, r/2) - tick;
      vertex(x*cos(TWO_PI*i/3) + y*sin(TWO_PI*i/3),
        y*cos(TWO_PI*i/3) - x*sin(TWO_PI*i/3));
    }
  }
  endShape();

  y = lerp(r, r/2, ease(c01(1.5*q)));

  for (int i=0; i<3; i++) {
    push();
    rotate(TWO_PI*i/3);
    line(0, y, 0, y-r/2*ease(c01(1.5*q-.25)));
    pop();
  }
}

float sp,dd ;

void draw_() {
  background(20);
  push();
  translate(width/2, height/2);

  for (int a=0; a<3; a++) {
    r = 36*pow(2, t-0.005*a);
    sp = 2*r*mn;
    stroke(cs[a]);

    for (int i=-N; i<N; i++) {
      for (int j=-N; j<N; j++) {
        x = i*sp;
        y = (j+2/3.0)*mn*sp;
        if (j%2 != 0)
          x += .5*sp;

        dd = dist(x,y,0,0);

        tt = c01(2.5*t-0.0025*dd - 0.025*a);
        tt = .5*tt + .5*ease(tt);

        push();
        translate(x, y);
        hex(tt);
        pop();
      }
    }
  }

  pop();
}
