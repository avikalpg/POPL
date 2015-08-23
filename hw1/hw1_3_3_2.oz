
/*declare Build

fun{Build Xs Parent Turn}
   case Xs
      of X|Y then 
      */

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

{Browse {PossibleMoves [[o o s] [x o x] [x o s]] o}}
{Browse 'No.2'}
{Browse {PossibleMoves [[o o s] [x s x] [x o s]] o}}
{Browse 'No.3'}
{Browse {PossibleMoves [[s s s] [s s s] [s s s]] o}}
