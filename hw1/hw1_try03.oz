declare FoldR
fun {FoldR BinOp Xs Identity}
   case Xs
   of nil then Identity
   [] H|T then {BinOp H {FoldR BinOp T Identity}}
   end
end

fun {Map F Xs}
   case Xs
   of nil then nil
   [] H|T then {F H}|{Map F T}
   end
end
   
declare Horizontal FindSign

fun{FindSign X Y}
   case X|Y
   of _|x then x
   [] _|o then o
   [] x|_ then x
   [] o|_ then o
   else s
   end
end

fun {Horizontal L}
      {FoldR FindSign {Map fun{$ Sign} {FoldR FindSign {Map fun {$ Row}
	      {FoldR fun{$ X Y}
			if X == Y then X
			else s
			end
		     end Row Sign}
	   end L } s} end [x o] } s}
end

declare Vertical FindVert

fun{FindVert X Y Z}
   case X|Y|Z
   of nil|nil|nil then draw
   [] (x|_)|(x|_)|(x|_) then x
   [] (o|_)|(o|_)|(o|_) then o
   [] (_|A)|(_|B)|(_|C) then {FindVert A B C}
   else 'Case not considered'
   end
end

fun{Vertical L}
   case L
   of X|Y|Z|nil then {FindVert X Y Z}
   else 'Something went wrong'
   end
end

declare Diagonal EqSign

fun{EqSign X Y}
   if X == Y then X
   else notEqual
   end
end

fun{Diagonal L}
   case L.2.1.2.1
   of s then draw
   [] x then if {EqSign L.1.1 L.2.2.1.2.2.1} == x then x
	     else if {EqSign L.2.2.1.1 L.1.2.2.1} == x then x
		  else draw
		  end
	     end
   [] o then if {EqSign L.1.1 L.2.2.1.2.2.1} == o then o
	     else if {EqSign L.2.2.1.1 L.1.2.2.1} == o then o
		  else draw
		  end
	     end
   else draw
   end
end

declare Diagonal2 FindDiag2

fun {FindDiag2 X Y Z}
   case X|Y|Z
   of nil|nil|nil then draw
   [] (x|_)|(_|x|_)|(_|_|x|nil) then x
   [] (_|_|x|nil)|(_|x|_)|(x|_) then x
   [] (o|_)|(_|o|_)|(_|_|o|nil) then o
   [] (_|_|o|nil)|(_|o|_)|(o|_) then o      
   else draw
   end
end

fun {Diagonal2 L}
   case L
   of X|Y|Z|nil then {FindDiag2 X Y Z}
   else 'Something went wrong'
   end
end

declare TTT

fun{TTT L}
   if {Horizontal L} \= s then {Horizontal L}
   else if {Vertical L} \= draw then {Vertical L}
	else {Diagonal2 L} % or {Diagonal L}
	end
   end
end

{Browse {TTT [[s s s] [s s o] [s s x]]}}
{Browse {TTT [[o o o] [s s o] [s s x]]}} % horizontal o
{Browse {TTT [[s s s] [s s o] [x x x]]}} % horizontal x
{Browse {TTT [[o o o] [s x o] [x x x]]}} % Look into this again
{Browse {TTT [[s x s] [s x o] [s x x]]}} % vertical x
{Browse {TTT [[o o x] [o x o] [o s x]]}} % vertical o
{Browse {TTT [[o s x] [o o s] [x s o]]}} % diagonal o
{Browse {TTT [[o s x] [o x s] [x s o]]}} % diagonal x
{Browse {TTT [[x o o] [s x o] [s s x]]}}
{Browse {TTT [[s o s] [x o x] [s x o]]}}
