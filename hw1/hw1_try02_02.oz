/*
* The unary function that has to be passed in the
* desired Map function, should be specified under
* function F defined below   
*/
declare FoldR BinOp
fun {F A}
   A*A
end

fun {BinOp F X}
   {F X}
end

fun {FoldR BinOp Xs Identity}
   case Xs
   of nil then Identity
   [] H|T then {BinOp F H}|{FoldR BinOp T Identity}
   end
end

{Browse {FoldR BinOp [1 2 3] nil}}
















