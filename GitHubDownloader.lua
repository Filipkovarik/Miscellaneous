local configPath=shell.resolve("GitConfig")
local confLines={}
local lines=io.lines(configPath)
for url in lines do
 local req = http.get(url)
 print("Requesting from "..url)
 local code = req.getResponseCode()
 print("HTTP Code #"..code)
 if code ~= 200 then
   req.close()
   error("HTTP Error #"..code.." at "..url)
  end
 local targetPath = lines()
 local targetF = fs.open(shell.resolve(targetPath),"w")
 print("Opened "..targetPath.." for writing")
 targetF.write(req.readAll())
 print("Written requested page")
 req.close()
 targetF.close()
 print("Closed both file streams")
end
