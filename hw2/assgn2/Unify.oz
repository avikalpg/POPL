%==============
% Code for unification
%
% Unify two expressions. An expression can be
% 1. A literal
% 2. A record
% 3. An identifier
%
% Please refer to the problem statement for the syntax of the
% language.
%
% Author: Satyadev Nandakumar
% Date  : Fri Sep 28 18:32:54 2012
% Modified from the code of Siddharth Agarwal
%==============

\insert 'SingleAssignmentStore.oz'
\insert 'ProcessRecords.oz'

declare
proc {Unify Exp1 Exp2 Env}
   SubstituteIdentifiers
   WeakSubstitute
   UnifyRecursive
in
   %==================
   % Replace every identifier in the code with
   % (1) its key in the SAS store if it is unbound (or)
   % (2) with its value if it is bound [determined]
   % Code by Siddharth Agarwal
   %=================
   fun {SubstituteIdentifiers Exp Env}
      case Exp
      of H|T then  
	 {SubstituteIdentifiers H Env}|{SubstituteIdentifiers T Env}
      [] ident(X) then {RetrieveFromSAS Env.X}
      else Exp end
   end

   %=================
   % Used when unifying records. Similar to SubstituteIdentifiers,
   % except that lists are not unified.
   %=================
   fun {WeakSubstitute X}
      case X
      of equivalence(A) then {RetrieveFromSAS A}
      else X end
   end
   
   %=================
   % Main unification procedure.
   % Assumes that identifiers have been substituted away, by calling
   % SubstituteIdentifiers.
   %==================
   proc {UnifyRecursive Exp1 Exp2 UnificationsSoFar}
      Unifications % New list of unifications
   in
      %==================
      % Ensure that we do not go into an infinite loop
      % unifying already unified expressions.
      % Code modified from Siddharth Agarwal's code
      %==================
      if {List.member [Exp1 Exp2] UnificationsSoFar}
      then skip
      else
	 Unifications = {List.append [Exp1 Exp2] UnificationsSoFar}
	 case Exp1
	 of equivalence(X) then
	    case Exp2
	    of equivalence(Y) then {BindRefToKeyInSAS X Y}
	    else {BindValueToKeyInSAS X Exp2} end
	 [] literal(X) then
	    case Exp2
	    of equivalence(_) then
	       {UnifyRecursive Exp2 Exp1 Unifications}
	    [] literal(!X) then skip
	    else raise incompatibleTypes(Exp1 Exp2) end
	    end
	 [] record | L | Pairs1 then % not label(L)
	    case Exp2
	    of equivalence(_) then
	       {UnifyRecursive Exp2 Exp1 Unifications}
	    [] record|!L|Pairs2 then % recursively unify
	       Canon1 = {Canonize Pairs1.1}
	       Canon2 = {Canonize Pairs2.1}
	    in
	       {List.zip Canon1 Canon2
		fun {$ X Y}
		   {UnifyRecursive
		    {WeakSubstitute X.2.1} {WeakSubstitute Y.2.1}
		    Unifications}
		   unit
		end
		_}
	    else raise incompatibleTypes(Exp1 Exp2) end
	    end %
	 else
	    raise incompatibleTypes(Exp1 Exp2) end
	 end
      end % if
   end % UnifyRecursive

   %========= Start Unification ======
   {UnifyRecursive {SubstituteIdentifiers Exp1 Env}
    {SubstituteIdentifiers Exp2 Env} nil}
end





