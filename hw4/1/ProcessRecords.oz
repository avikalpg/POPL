%==============
% Code for processing records.
%
% Author: Satyadev Nandakumar
% Date  : Fri Sep 28 18:34:06 2012
%==============

declare
%==========
% Check if the entries in a *sorted* list
% are unique.
%==========
fun {HasUniqueEntries L}
   case L
   of H|T then
      case T
      of nil then true
      [] !H|T1 then false
      else {HasUniqueEntries T}
      end
   end
end

declare
%===========================
% equals Value.'<' if A and B are of the same type.
% Otherwise, any number is treated less than any literal.
%===========================
fun {MixedCompare A B}
   C D
in
   case A
   of literal(C)
   then
      case B
      of literal(D)
      then
	 if {IsNumber C}=={IsNumber D}
	 then C<D
	 else {IsNumber C} end
      end
   end
end

%=== Example Usage ===
% {Browse {HasUniqueEntries {Sort [a 1 2 d c 3] MixedCompare}}}
%=====================
   

declare
%==================
% The list of fieldname#value pairs can be specified in any
% order. The function returns a list of pairs sorted in the "arity"
% order - numerical fieldnames first, sorted in ascending order, 
% followed by lexicographic fieldnames in alphabetical order.
%==================
fun {Canonize Pairs}
   Keys = {Map Pairs fun {$ X} X.1 end}
   SortedKeys = {Sort Keys MixedCompare}
   FindPairWithKey
   Result
in
   if {HasUniqueEntries SortedKeys}
   then
      %=======================
      % return unique K#value pair
      %=======================
      fun {FindPairWithKey K}
	 {Filter Pairs fun {$ Y} Y.1 == K end}.1
      end
      
      {Map SortedKeys FindPairWithKey}
   else illegalRecord(Pairs)
   end
end

