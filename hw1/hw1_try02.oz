local ZipWith Length Dummy FoldR Map FoldL Subtract Divide ReverseFoldR WrongFoldL in
   % May be this function definition can be removed, it is not really needed
   fun{Length Xs}
      case Xs
      of nil then 0
      [] _|T then 1+{Length T}
      end
   end

   % Answer 2.1
   fun{ZipWith BinOp Xs Ys}
      if {Length Xs} == {Length Ys} then
	 case Xs|Ys
	 of nil|nil then nil
	 [] (H|T)|(F|B) then {BinOp H F}|{ZipWith BinOp T B}
	 else {Browse 'Something went wrong'}
	    nil
	 end
      else
	 {Browse 'The 2 Lists are not of equal size'}
	 nil
      end
   end

   % Defining a dummy binary operator function to test ZipWith
   fun{Dummy A B}
      A+B
   end
   % Testing the ZipWith function
   {Browse {ZipWith Dummy [1 3 5] [2 4 6]}}
   {Browse {ZipWith Dummy nil nil}}
   {Browse {ZipWith Dummy [1 2] [2 4 5]}}

   % Answer 2.2
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
   % I do not know what did the question mean by "Rewrite Map using FoldR"
   % Sorry
   {Browse {Map fun{$ X} X*X end [1 2 3]}}
   %% So basically 2.2 is still incomplete

   % Answer 2.3
   fun{ReverseFoldR BinOp Xs Identity}
      case Xs
      of nil then Identity
      [] H|T then {BinOp {ReverseFoldR BinOp T Identity} H}
      end
   end
   fun{FoldL BinOp Xs Identity}
      case {Reverse Xs}
      of nil then Identity
      [] H|T then {BinOp {ReverseFoldR BinOp T Identity} H}
      end
   end
   fun{WrongFoldL BinOp Xs Identity}
      case {Reverse Xs}
      of nil then Identity
      [] H|T then {BinOp {WrongFoldL BinOp T Identity} H}
      end
   end
   
   % Test cases
   fun{Subtract X Y}
      X - Y
   end
   fun{Divide X Y}
      X / Y
   end
   % I've not yet understood the results
   % Why are the wrongFoldL and FoldL giving the same results
   % Not handled any exceptions in FoldL, as discussed in class, it has some exception if the number of elements in List is equal to 1
   {Browse foldR# {FoldR Subtract [1 2 3] 0}} % Expected 2
   {Browse foldL# {FoldL Subtract [1 2 3] 0}} % Expected -6
   {Browse wrongFoldL# {WrongFoldL Subtract [1 2 3] 0}}
   {Browse foldL# {FoldL Subtract [3 2 1] 0}}
   {Browse wrongFoldL# {WrongFoldL Subtract [3 2 1] 0}}
   % Division
   {Browse foldR# {FoldR Divide [8. 4. 2.] 1.}} % Expected 2
   {Browse foldL# {FoldL Divide [8. 4. 2.] 1.}} % Expected -6
   {Browse wrongFoldL# {WrongFoldL Divide [1. 2. 3.] 1.}}
   {Browse foldL# {FoldL Divide [1. 2. 3.] 1.}}
   {Browse wrongFoldL# {WrongFoldL Divide [3. 2. 1.] 1.}}
   % Exponent
   {Browse foldR# {FoldR fun{$ X Y} {Pow X Y}+2 end [1 2 3] 3}} % 3
   {Browse foldL# {FoldL fun{$ X Y} {Pow X Y}+2 end [1 2 3] 3}} % 19,685
   {Browse wrongFoldL# {WrongFoldL fun{$ X Y} {Pow X Y}+2 end [1 2 3] 3}} % 2199
end