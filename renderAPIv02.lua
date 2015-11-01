--renderAPI for ComputerCraft by 7M351, NOT by Filipkovarik
function round(x)
  if math.ceil(x)-x>0.5 then
  return math.floor(x)
  else
  return math.ceil(x)
  end
end

function effTable( x )
return setmetatable({},{__index=function(t,a) t[a] = x(); return t[a] end}
)
end

function newSpace()
return setmetatable(effTable(function()return effTable(function()return effTable(function() return 0 end) end) end),{addLine=addLine, render=render})
end

function addLine(space,clr,x,y,z,xe,ye,ze)
space[x][y][z]=clr
space[xe][ye][ze]=clr
local xstep=xe-x
local ystep=ye-y
local zstep=ze-z
local length=math.sqrt(xstep^2+ystep^2+zstep^2)
xstep=xstep/length
ystep=ystep/length
zstep=zstep/length
  for a=0, length, 0.5 do
  space[math.floor(x+a*xstep)][math.floor(y+a*ystep)][math.floor(z+a*zstep)]=clr
  end
return space
end

function render(space,xstart,ystart,FOV,depth,af,bgcolor)
local x,y=term.getSize()
local pxw,pxh,clr1,clr2=0,0,0,0
local foc=math.sqrt(x*y)/2/math.tan(FOV/2)
local pxtab={}
local color={}
color[0]=0
  for a=1, af do
  pxtab[a]={}
    for b=1, af do
    pxtab[a][b]=0
    end
  end

  for yy=1, y do
  sleep(0)
    for xx=1, x do
      for zz=0, depth do
      pxw=math.min(round(((xx-x/2)-(xx-x/2+1))*zz/foc),af)
      pxh=math.min(round(((yy-y/2)-(yy-y/2+1))*zz/foc),af)
        for a=1, pxw do
          for b=1, pxh do
            if not pxtab[a][b] then
            pxtab[a][b]=space[round(xstart+xx+(xx-x/2)*zz/foc)][round(ystart+yy+(yy-y/2)*zz/foc)][zz+1]
            end
          end
        end
      end
      
      
      
      for i=0, 15 do
      color[2^i]=0
      end
      for a=1, pxw do
        for b=1, pxh do
          if pxtab[a][b] then
          color[pxtab[a][b]]=color[pxtab[a][b]]+1/a/b
          else
          color[bgcolor]=color[bgcolor]+1/a/b
          end
        end
      end
      for i=0, 15 do
        if color[2^i]>color[clr1] then
        clr2=clr1
        clr1=2^i
        elseif color[2^i]>color[clr2] then
        clr2=2^i
        end
      end
	  if clr1==0 then
	  clr1=bgcolor
	  end
	  if clr2==0 then
	  clr2=bgcolor
	  end
    term.setCursorPos(xx,yy)
    term.setBackgroundColor(clr1)
    term.setTextColor(clr2)
      if color[clr2]>0.33 then
      term.write("X")
      elseif color[clr2]>0.2 then
      term.write("+")
      elseif color[clr2]>0.01 then
      term.write(".")
      else
      term.write(" ")
      end
    end
  end
end

