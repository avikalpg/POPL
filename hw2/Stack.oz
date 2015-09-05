declare Push PopAux Top L
fun {Push L Key}
   Key|L
end

fun {Top L}
   L.1
end

fun {PopAux L}
   case L
   of X|Y then Y
   end
end

% Test code
/*L = {NewCell [1 2 3]}
{Browse @L}
L := {Push @L 4}
{Browse push#@L}
declare X I
X = {NewCell nil}
for I in 1..3 do
   X := {Top @L}
   L := {PopAux @L}
   {Browse popped# @X}
   {Browse rem# @L}
end
*/


