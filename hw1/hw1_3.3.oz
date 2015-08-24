% 3.3.1
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

/*{Browse {TTT [[s s s] [s s o] [s s x]]}}
{Browse {TTT [[o o o] [s s o] [s s x]]}} % horizontal o
{Browse {TTT [[s s s] [s s o] [x x x]]}} % horizontal x
{Browse {TTT [[o o o] [s x o] [x x x]]}} % Look into this again
{Browse {TTT [[s x s] [s x o] [s x x]]}} % vertical x
{Browse {TTT [[o o x] [o x o] [o s x]]}} % vertical o
{Browse {TTT [[o s x] [o o s] [x s o]]}} % diagonal o
{Browse {TTT [[o s x] [o x s] [x s o]]}} % diagonal x
{Browse {TTT [[x o o] [s x o] [s s x]]}}
{Browse {TTT [[s o s] [x o x] [s x o]]}}*/

% 3.3.2
declare PossibleMoves Check1 Check2 Check3 Check4 Check5 Check6 Check7 Check8 Check9
fun{Check1 Position Turn List}
   case Position
   of (s|A)|B then ((Turn|A)|B)|List
   else List
   end
end
fun{Check2 Position Turn List}
   case Position
   of (A|s|B)|C then ((A|Turn|B)|C)|List
   else List
   end
end
fun{Check3 Position Turn List}
   case Position
   of (A|B|s|nil)|D then ((A|B|Turn|nil)|D)|List
   else List
   end
end
fun{Check4 Position Turn List}
   case Position
   of X|(s|A)|B then (X|(Turn|A)|B)|List
   else List
   end
end
fun{Check5 Position Turn List}
   case Position
   of X|(A|s|B)|C then (X|(A|Turn|B)|C)|List
   else List
   end
end
fun{Check6 Position Turn List}
   case Position
   of X|(A|B|s|nil)|D then (X|(A|B|Turn|nil)|D)|List
   else List
   end
end
fun{Check7 Position Turn List}
   case Position
   of X|Y|(s|A)|nil then (X|Y|(Turn|A)|nil)|List
   else List
   end
end
fun{Check8 Position Turn List}
   case Position
   of X|Y|(A|s|B)|nil then (X|Y|(A|Turn|B)|nil)|List
   else List
   end
end
fun{Check9 Position Turn List}
   case Position
   of X|Y|(A|B|s|nil)|nil then (X|Y|(A|B|Turn|nil)|nil)|List
   else List
   end
end

fun{PossibleMoves Position Turn}
   {Check1 Position Turn {Check2 Position Turn {Check3 Position Turn {Check4 Position Turn {Check5 Position Turn {Check6 Position Turn {Check7 Position Turn {Check8 Position Turn {Check9 Position Turn nil}}}}}}}}}
end

/*{Browse '3.3.2'}
{Browse 1# {PossibleMoves [[o o s] [x o x] [x o s]] o}}
{Browse 2# {PossibleMoves [[o o s] [x s x] [x o s]] o}}
{Browse 3# {PossibleMoves [[s s s] [s s s] [s s s]] o}}*/
