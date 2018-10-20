cls()
pal(15, 1, 1) // remap peach[15] to dark blue[1]

bounds = 64
xspd = .5
yspd = .3
sizespd = .25

::_::
t = time()

circx = (cos(t * xspd) + 1) * bounds
circy = (sin(t * yspd) + 1) * bounds
radius = 10 / (cos(t * sizespd) + 1.25)

for row = 0,42 do
  for col = 0,31 do
    px = col * 4 + (row % 2) * 2 // offset px by 2 on every other row
    py = row * 3

    color = 0 // black

    // check if this pixel is inside the circle
    dx = circx - px
    dy = circy - py
    if ((dx * dx) + (dy * dy) < (radius * radius)) then
      color = 7 // white
    else
      // get a random color within 2 pixels
      c2 = pget(px + rnd(5) - 2, py + rnd(5) - 2)
      if (c2 > 0) then
        // change to that color but one darker
        color = c2 + 1
      end
    end

    if (color > 0) then
      circfill(px, py, 1, color)
    end
  end
end
flip()
goto _
