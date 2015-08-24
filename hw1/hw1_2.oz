local ZipWith Length Dummy FoldR_Map BinOp FoldL FoldR Subtract Divide ReverseFoldR in
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
	 else 'Something went wrong'
	 end
      else
	 'The 2 Lists are not of equal size'
      end
   end

   % Defining a dummy binary operator function to test ZipWith
   fun{Dummy A B}
      A+B
   end
   % Testing the ZipWith function
   /*{Browse 'Testing 2.1'}
   {Browse {ZipWith Dummy [1 3 5] [2 4 6]}}
   {Browse {ZipWith Dummy nil nil}}
   {Browse {ZipWith Dummy [1 2] [2 4 5]}}*/

   % Answer 2.2
   /*
   * The unary function that has to be passed in the
   * desired Map function, should be specified under
   * function F defined below   
   */
   fun {BinOp F X}
      {F X}
   end

   fun {FoldR_Map F Xs}
      case Xs
      of nil then nil
      [] H|T then {BinOp F H}|{FoldR_Map F T}
      end
   end
   % Test cases for 2.2
/*   {Browse 2.2# {FoldR_Map fun{$ A} A*A end [1 2 3]}}
   {Browse 2.2# {FoldR_Map fun{$ X} X+X end [3 2 4]}}*/

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
   
   % Test cases
/*   {Browse 'Testing 2.3'}
   fun{Subtract X Y}
      X - Y
   end
   fun{Divide X Y}
      X / Y
   end
   fun {FoldR BinOp Xs Identity}
      case Xs
      of nil then Identity
      [] H|T then {BinOp H {FoldR BinOp T Identity}}
      end
   end
   {Browse foldR# {FoldR Subtract [1 2 3] 0}} % Expected 2
   {Browse foldL# {FoldL Subtract [1 2 3] 0}} % Expected -6
   % Division
   {Browse foldR# {FoldR Divide [8. 4. 2.] 1.}} % Expected 4
   {Browse foldL# {FoldL Divide [8. 4. 2.] 1.}} % Expected 1/64
   % Exponent
   {Browse foldR# {FoldR fun{$ X Y} {Pow X Y}+2 end [1 2 3] 3}} % 3
   {Browse foldL# {FoldL fun{$ X Y} {Pow X Y}+2 end [1 2 3] 3}} % 19,685*/
end