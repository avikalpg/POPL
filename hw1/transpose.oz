declare Transpose TransposeAux 
fun {TransposeAux X Y}
   case X|Y
   of nil|nil then nil
   [] (H|T)|(F|B) then [H F]|{TransposeAux T B}
   end
end

fun {Transpose L}
   case L
   of nil then nil
   [] H|M|T|nil then {TransposeAux {TransposeAux H M} T}
   end
end

{Browse {TransposeAux [[1 4] [2 5] [3 6]] [7 8 9]}}
