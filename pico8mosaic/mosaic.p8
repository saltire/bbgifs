xstep = 7
ystep = 5

radius = 6
maxArms = 10
armsSpeed = 1 / 20
curveSize = 15
pulseSize = 150
pulseSpeed = 1
colors = {2, 4, 9, 10, 7}

cols = ceil(128 / xstep) + 1
rows = ceil(128 / ystep) + 1

xmid = flr(cols / 2)
ymid = flr(rows / 2)

cls()

::_::
t = time()

// move centre around in a circle, counter-clockwise
cx = xmid + (sin(t / 10) * radius)
cy = ymid + (sin(t / 10 + .25) * radius)

for y = 0, rows do
  xoffset = 1
  if (y % 2 == 1) xoffset += flr(xstep / 2)

  for x = 0, cols do
    dx = cx - x
    dy = cy - y
    angle = atan2(dx, dy)
    dist = sqrt((dx * dx) + (dy * dy))

    color = colors[flr(
      ((
        sin((angle * sin(t * armsSpeed) * maxArms) + (dist / curveSize) + t) + 
        sin((dx * dy) / pulseSize + t * pulseSpeed)
      ) * 5.5 / 5) + 3.5
    )]

    px = x * xstep - xoffset
    py = y * ystep - 4
    px += rnd(2)
    py += rnd(2)

    print("◆", px, py, color)
  end
end 

goto _
