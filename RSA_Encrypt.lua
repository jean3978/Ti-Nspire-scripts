variablesText = ""
messageText = ""
blocText = ""
messageAjustedByScript = false 

function on.construction()
timer.start(0.4)
TextBox1 = D2Editor.newRichText()
var.monitor("m")
var.monitor("n")
var.monitor("e")
askForVariables()
setText()
end

function on.resize()
W = platform.window:width()
H = platform.window:height()

TextBox1:move(0, 0)
TextBox1:resize(W,H)

fontSize = math.floor(W/32)
fontSize = fontSize > 6 and fontSize or 7
TextBox1:setFontSize(fontSize)

TextBox1:setBorderColor(500)
TextBox1:setBorder(1)
TextBox1:setTextColor(200*200*200)
TextBox1:setFocus(true)
TextBox1:setExpression("")
askForVariables()
end

function myerrorhandler( err )
 return err
end

function askForVariables()
platform.window:invalidate()
variables = var.list()

txt = "RSA Encryption\n"
m = false
n = false
e = false
for i=1, table.getn(variables) do
  if variables[i] == "m" and var.recallStr(variables[i]) ~= nil then
    m = true
    txt = txt.."\n  "..variables[i].." := "..var.recallStr(variables[i])
  elseif variables[i] == "n" and var.recall(variables[i]) ~= nil then
    n = true
    txt = txt.."\n  "..variables[i].." := "..var.recall(variables[i])
  elseif variables[i] == "e" and var.recall(variables[i]) ~= nil then
    e = true
    txt = txt.."\n  "..variables[i].." := "..var.recall(variables[i])
  end
end

if not m then
  txt = txt.."\n Please define a string variables m"
end 
if not n then
  txt = txt.."\n Please define variables n"
end 
if not e then
  txt = txt.."\n Please define variables e"
end 

print(txt)
_G.variablesText = txt
setText()
end


function on.varChange(varlist)
 askForVariables()
 for k, v in pairs(varlist) do
    if v == "m" then 
    if (var.recall("m") ~= nil and messageAjustedByScript == false) then
      translateMessage()
      end
    elseif v == "n" then
      if (var.recall("n") ~= nil) then
      determineBlocs()
      end
    end
    
    if var.recallStr("m") ~= nil and var.recall("n") ~= nil and var.recall("e") ~= nil and messageAjustedByScript == false then
      encrypt()
    end
 end
 
 setText()
 return 0 -- allow modifications of other monitored variables if any
end

function on.enterKey()
  
end  

function on.getFocus()
TextBox1:setFocus()
end


function translateMessage()
  local message = var.recallStr("m")
  translation = ""
  for i = 1, #message do
    local c = message:sub(i,i)
    if c == "a" then
      translation = translation.."00"
    elseif c== "b" then
      translation = translation.."01"
    elseif c== "c" then
      translation = translation.."02"
    elseif c== "d" then
      translation = translation.."03"
    elseif c== "e" then
      translation = translation.."04"
    elseif c== "f" then
      translation = translation.."05"
    elseif c== "g" then
      translation = translation.."06"
    elseif c== "h" then
      translation = translation.."07"
    elseif c== "i" then
      translation = translation.."08"
    elseif c== "j" then
      translation = translation.."09"
    elseif c== "k" then
      translation = translation.."10"
    elseif c== "l" then
      translation = translation.."11"
    elseif c== "m" then
      translation = translation.."12"
    elseif c== "n" then
      translation = translation.."13"
    elseif c== "o" then
      translation = translation.."14"
    elseif c== "p" then
      translation = translation.."15"
    elseif c== "q" then
      translation = translation.."16"
    elseif c== "r" then
      translation = translation.."17"
    elseif c== "s" then
      translation = translation.."18"
    elseif c== "t" then
      translation = translation.."19"
    elseif c== "u" then
      translation = translation.."20"
    elseif c== "v" then
      translation = translation.."21"
    elseif c== "w" then
      translation = translation.."22"
    elseif c== "x" then
      translation = translation.."23"
    elseif c== "y" then
      translation = translation.."24"
    elseif c== "z" then
      translation = translation.."25"
    end
  end
  
  messageText = var.recall("m").." => "..translation
end

function determineBlocs()
local key = var.recall("n")
local last = ""
local attempt = ""
local attemptValue = -1
while attemptValue < key do
  last = attempt
  attempt = attempt.."25"
  attemptValue = tonumber(attempt)
end

bloc = #last
blocText = "bloc value: "..last.." < "..tostring(key)
end


function setText()
  print("setText")
  print(variablesText)
  TextBox1:setExpression(variablesText.."\n"..messageText.."\n"..blocText)
  mathTextBox = TextBox1:createMathBox()
end

function encrypt()
  messageAjustedByScript = true
  translateMessage()
  determineBlocs()
  local toAdd = (#translation % bloc) / 2
  local message = var.recall("m")
  print("toAdd"..toAdd)
  for i = 1, toAdd do
    message = message.."x"
  end
  
  var.store("m", message)
  translateMessage()
  
  partIndex = 1
  
  encrypted = ""
  
  stopper = 0
  
  while partIndex ~= translation / bloc do
    local part = string.sub(translation, partIndex, partIndex + bloc)
    local partIndex = partIndex + bloc
    local letter = math.evalStr("numtheory\pwrmod("..part..","..tostring(n)..","..tostring(e)..")")
    encrypted = encrypted..letter
    print("part: "..part)
    print("partIndex: "..partIndex)
    print("condition: "..translation / bloc)
    print("letter: "..letter)
    print("encrypted: "..encrypted)
    stopper = stopper + 1
    if stopper >= 30 then
      partIndex = translation / bloc
    end
  end
  
  print(encrypted)
  messageAjustedByScript = false
end
