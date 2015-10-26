--A Lua API I made for my ComputerCraft programs
function shuffleParams(f,t)
local function anonymous (...)
  local arg2={}
  local arg={...}
  for i,j in ipairs(t) do
    arg2[i]=arg[j]
  end
  return f(unpack(arg2))
end
return anonymous
end

function partial(f,t)
local function anonymous (...)
return f(unpack(t),...)
end
return anonymous
end

function HanoiTConcat(a)
local strings=a or {}
local function fixTower()
local d = table.getn(strings);
 while d>=2 do
  if #(strings[d])>=#(strings[d-1]) then 
   strings[d-1]=strings[d-1]..strings[d]
   strings[d]=nil
  end
  d=d-1
 end
end
return {
push=function(a) table.insert(strings,a); fixTower()  end,
concatAll=function() local k="";  for _,j in ipairs(strings) do k=k..j end return k  end,
serialize=function() return textutils.serialize(strings) end
}
end

function tobase(num,base,minlength) 
base=math.floor(base)
local output=""
local digits={}
for i in string.gmatch("0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZ","%w") do digits[tonumber(i,36)]=i end

if base<1 or base>36 then error("Base out of range (1-36)") end
if base==1 then for _=1,num do output=output.."0" return output  end end
local reminders={}
while num~=0 do 
local mod=num%base
table.insert(reminders,0,mod)
num=math.floor(num/base)
end

reminders=map(reminders,function(a)  return digits[a]  end)
local outnum = PhilsUtils.HanoiTConcat{table.concat(reminders,"")}
if minlength then for _=1,minlength-#outnum do outnum.push("0") end end
return outnum.concatAll();
end

function reduce(t,callback,carryvar)
local carryvar=carryvar or 0
for i,j in ipairs(t) do
carryvar = callback(j,carryvar,i,t)
end
return carryvar
end

function map (t,callback)
local new = {}
 for i,j in ipairs(t) do
 new[i] = callback(j,i,t)
 end
 return new
end

function contains(t,x)
for i,j in ipairs(t) do
if j==x then return i end
end
end

function split(st,chunk)
local t={}
chunk=chunk or "."
for i in string.gmatch(st,chunk) do
table.insert(t,i)
end
return t
end

function reverse(t) 
local t2={}
for i=1,(#t)/2 do
t2[i],t2[#t-i+1]=t[#t-i+1],t[i]
end
return t2
end

function every(t,callback)
for i,j in ipairs(t) do
 if not callback(j,i,t) then return false end
end
return true
end

function Constructor(f,t)
t.__index=t
t.is=function(...)if #arg<1 then error"Expected table" end return every(arg,function(a) return getmetatable(a)==t end) end
setmetatable(t,{__call=function(cls,...) return cls.new(...) end})
t.new=function(...) local F=f(...); return setmetatable(F,getmetatable(F) and merge(t,getmetatable(F)) or t) end
return t
end

function shallowCopy(a)
local t={}
for i,j in pairs(a) do t[i] = j end
return t
end

function merge(a,b)
local t = shallowCopy(a)
for i,j in pairs(b) do
t[i]=j
end
return t
end

function inherit(a,b)
setmetatable(a,PhilsUtils.merge(getmetatable(a),{__index=b}))
end

function eventWait(delay)
os.startTimer(delay)
local event={os.pullEvent()}
if event[1]=="timer" then return nil end
return event
end

function pullAll(delay)
local t={}
local s={}
repeat
s=eventWait(delay)
table.insert(t,s)
until (s)
return t
end

function indexQueue(q)
return (function (o,k)
local u; 
for _,j in ipairs(q) do
    if type(j)=="function" then u=j(o,k)
	else u=rawget(j,k) end 
	if u~=nil then return u end
end end)end

function newIndexQueue(q)
return (function (o,k,v)
local u; 
for _,j in ipairs(q) do
    if type(j)=="function" then u=j(o,k,v) --should return "handled" boolean
	else rawset(j,k,v) u=true end 
	if u~=nil then return u end
end end)end
