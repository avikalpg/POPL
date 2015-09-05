%%Cells%%

local A X Y B in
   A = {NewCell 0}
   B = {NewCell 2}
  % Y = {NewCell 3}
   A := 1
   X = @A
   {Browse X}
   {Browse @B}
   {Browse {IsCell B}}
   {Exchange B Y 9}
   {Browse Y}
end

%%Dictionaries%%

local X Y Z in
   X = {Dictionary.new} 
   {Browse {Dictionary.isEmpty X}}
end

