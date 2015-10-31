%% Examples slightly adapted from that of S. Tulsiani and A. Singh
%% These are some of the examples that you can test your code on.
%% Note that the keywords may be different from those you have
%% used. Make suitable changes before using these examples to test
%% your code.

%%-------------- Record bind ----------------


%% x = label(f1:y f2:z)
%% x = label(f1:2 f2:1)
[localvar ident(x)
 [localvar ident(y)
  [localvar ident(z)
   [[bind ident(x)
     [record literal(label)
      [literal(f1) ident(y)]
      [literal(f2) ident(z)]]]
    [bind ident(x)
     [record literal(label) [literal(f1) 2] [literal(f2) 1]]]]]]]


%% foo = person(name:bar)
%% bar = person(name:foo)
%% foo = bar                
[localvar ident(foo)
 [localvar ident(bar)
  [[bind ident(foo) [record literal(person) [literal(name) ident(bar)]]]
   [bind ident(bar) [record literal(person) [literal(name) ident(foo)]]]
    [bind ident(foo) ident(bar)]]]]

%% foo = person(name:foo)
%% bar = person(name:bar)
%% foo = bar
[localvar ident(foo)
  [localvar ident(bar)
   [[bind ident(foo) [record literal(person) [literal(name) ident(foo)]]]
    [bind ident(bar) [record literal(person) [literal(name) ident(bar)]]]
    [bind ident(foo) ident(bar)]]]]


%%---------------- Conditional ---------------

%% (local x
%%   ( local y
%%     ( local x
%%       ( x = y;
%%         y = true;
%%         if y then nop else x = true;)))
%%   x=35)
[localvar ident(x)
 [[localvar ident(y)
   [[localvar ident(x)
     [[bind ident(x) ident(y)]
      [bind ident(y) true]
      [conditional ident(y)#nop
       [bind ident(x) true]]]]
    [bind ident(x) literal(35)]]]]]


%% foo = true
%% if foo then result = true else result = false
%% result = true
[localvar ident(foo)
  [localvar ident(result)
   [[bind ident(foo) literal(t)]
    [conditional ident(foo)#[bind ident(result) literal(t)]
     [bind ident(result) literal(f)]]
    %% Check
    [bind ident(result) literal(t)]]]]


%% false case of the above code
[localvar ident(foo)
  [localvar ident(result)
   [[bind ident(foo) literal(f)]
    [conditional ident(foo)#[bind ident(result) literal(t)]
     [bind ident(result) literal(f)]]
    %% Check
    [bind ident(result) literal(f)]]]]




%%---------- Procedure definition and application ---------


%% x = proc ($ y x) ; end
%% x(1,2)
[localvar ident(x)
 [[bind ident(x)
   [subr [ident(y) ident(x)] [nop]]]]
 [apply ident(x) literal(1) literal(2)]]

%% x = proc($ y x) ; end
%% x(1, label(f1:1)
[localvar ident(x)
 [[bind ident(x)
   [subr [ident(y) ident(x)] [nop]]]
  [apply ident(x)
   literal(1)
   [record literal(label) [literal(f1) literal(1)]]]]]


%% bar = proc ($ baz)
%%         baz = person(age:foo)     ; foo is free
%%       end
%% bar(quux)
%% quux = person(age:40)
%% foo = 42
[localvar ident(foo)
 [localvar ident(bar)
  [localvar ident(quux)
   [[bind ident(bar) [subr [ident(baz)]
		      [bind [record literal(person)
			     [literal(age) ident(foo)]] ident(baz)]]]
    [apply ident(bar) ident(quux)]
    [bind [record literal(person) [literal(age) literal(40)]] ident(quux)]
    [bind literal(42) ident(foo)]]]]]

%% bar = proc($ baz) baz=person(age:foo) end
%% bar(quux)
%% quux=person(age:40)
%% 42=foo
[localvar ident(foo)
    [localvar ident(bar)
     [localvar ident(quux)
      [[bind ident(bar) [subr [ident(baz)]
        [bind [record literal(person) [literal(age) ident(foo)]] ident(baz)]]]
       [apply ident(bar) ident(quux)]
       [bind [record literal(person) [literal(age) literal(40)]] ident(quux)]
       [bind literal(40) ident(foo)]]]]]

%%------------ Pattern Match -------------------


%% x = label(f1:1 f2:2)
%% case x
%% of label(f1:1 f2:2) then ;
%% else ;
%% end
[localvar ident(x)
 [[bind ident(x)
   [record literal(label)
    [literal(f1) literal(1)]
    [literal(f2) literal(2)]]]
  [match ident(x)
   [record literal(label)
    [literal(f1) literal(1)]
    [literal(f2) literal(2)]]#[nop] [nop]]]]
   

%% foo = bar(baz:42 quux:314)
%% case foo
%% of bar(baz:fortytwo quux:pitimes100) then result=fortytwo
%% else result=314
%% end
%% result = 42
[localvar ident(foo)
 [localvar ident(result)
  [[bind ident(foo) [record literal(bar)
		     [literal(baz) literal(42)]
		     [literal(quux) literal(314)]]]
   [match ident(foo) [record literal(bar)
		      [literal(baz) ident(fortytwo)]
		      [literal(quux) ident(pitimes100)]]#[bind ident(result) ident(fortytwo)] %% if matched
    [bind ident(result) literal(314)]]
    %% This will raise an exception if result is not 42
   [bind ident(result) literal(42)]
   [nop]]]]

%% foo = bar
%% 20  = bar
%% case foo
%% of 21 then baz = t
%% else baz = f
%% end
%% bind = f
[localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [[bind ident(foo) ident(bar)]
     [bind literal(20) ident(bar)]
     [match ident(foo) literal(21)#[bind ident(baz) literal(t)]
      [bind ident(baz) literal(f)]]
     %% Check
     [bind ident(baz) literal(f)]
     [nop]]]]]


%% foo = person
%% bar = age
%% baz = person(age:25)
%% case baz
%% of foo(bar:quux) then result=quux
%% else result=f
%% end
%% result = 25
[localvar ident(foo)
  [localvar ident(bar)
   [localvar ident(baz)
    [localvar ident(result)
     [[bind ident(foo) literal(person)]
      [bind ident(bar) literal(age)]
      [bind ident(baz) [record literal(person) [literal(age) literal(25)]]]
      [match ident(baz) [record ident(foo) [ident(bar) ident(quux)]]#[bind ident(result) ident(quux)]
       [bind ident(result) literal(f)]]
      %% Check
      [bind ident(result) literal(25)]]]]]]
