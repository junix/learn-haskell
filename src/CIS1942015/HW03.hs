module HW03 where

data Expression =
    Var String                   -- Variable
  | Val Int                      -- Integer literal
  | Op Expression Bop Expression -- Operation
  deriving (Show, Eq)

-- Binary (2-input) operators
data Bop = 
    Plus     
  | Minus    
  | Times    
  | Divide   
  | Gt
  | Ge       
  | Lt  
  | Le
  | Eql
  deriving (Show, Eq)

data Statement =
    Assign   String     Expression
  | Incr     String
  | If       Expression Statement  Statement
  | While    Expression Statement       
  | For      Statement  Expression Statement Statement
  | Sequence Statement  Statement        
  | Skip
  deriving (Show, Eq)

type State = String -> Int

-- Exercise 1 -----------------------------------------

extend :: State -> String -> Int -> State
extend s var val = \v -> if v == var then val else s v

empty :: State
empty = \_ -> 0

-- Exercise 2 -----------------------------------------

evalE :: State -> Expression -> Int
evalE s (Var v) = s v
evalE _ (Val v) = v
evalE s (Op lexpr op rexpr)
    |op == Plus   = l + r
    |op == Minus  = l - r
    |op == Times  = l * r
    |op == Divide = l `div` r
    |op == Gt     = b2i $ l > r
    |op == Ge     = b2i $ l >= r
    |op == Lt     = b2i $ l < r
    |op == Le     = b2i $ l <= r
    |op == Eql    = b2i $ l == r
    where l = evalE s lexpr
          r = evalE s rexpr
          b2i :: Bool -> Int
          b2i True  = 1
          b2i False = 0

-- Exercise 3 -----------------------------------------

data DietStatement = DAssign String Expression
                   | DIf Expression DietStatement DietStatement
                   | DWhile Expression DietStatement
                   | DSequence DietStatement DietStatement
                   | DSkip
                     deriving (Show, Eq)

desugar :: Statement -> DietStatement
desugar Skip               = DSkip
desugar (Assign v e)       = DAssign v e
desugar (Incr v)           = DAssign v (Op (Var v) Plus (Val 1))
desugar (If e thens elses) = DIf e (desugar thens) (desugar elses)
desugar (While e s)        = DWhile e (desugar s)
desugar (Sequence s1 s2)   = DSequence (desugar s1) (desugar s2)
desugar (For init cond step body) =
    DSequence (desugar init) (DWhile cond (DSequence (desugar body) (desugar step)))

-- Exercise 4 -----------------------------------------

evalSimple :: State -> DietStatement -> State
evalSimple s DSkip             = s
evalSimple s (DAssign v e)     = extend s v $ evalE s e
evalSimple s (DSequence s1 s2) = evalSimple (evalSimple s s1) s2
evalSimple s (DIf cond thens elses) = if evalE s cond > 0
                                      then evalSimple s thens
                                      else evalSimple s elses
evalSimple s stmt@(DWhile cond body) = if c == 0
                                       then s
                                       else let s1 = evalSimple s body
                                            in  evalSimple s1 stmt
                                       where c = evalE s cond



run :: State -> Statement -> State
run s stmt = evalSimple s $ desugar stmt

-- Programs -------------------------------------------

slist :: [Statement] -> Statement
slist [] = Skip
slist l  = foldr1 Sequence l

{- Calculate the factorial of the input

   for (Out := 1; In > 0; In := In - 1) {
     Out := In * Out
   }
-}
factorial :: Statement
factorial = For (Assign "Out" (Val 1))
                (Op (Var "In") Gt (Val 0))
                (Assign "In" (Op (Var "In") Minus (Val 1)))
                (Assign "Out" (Op (Var "In") Times (Var "Out")))


{- Calculate the floor of the square root of the input

   B := 0;
   while (A >= B * B) {
     B++
   };
   B := B - 1
-}
squareRoot :: Statement
squareRoot = slist [ Assign "B" (Val 0)
                   , While (Op (Var "A") Ge (Op (Var "B") Times (Var "B")))
                       (Incr "B")
                   , Assign "B" (Op (Var "B") Minus (Val 1))
                   ]

{- Calculate the nth Fibonacci number

   F0 := 1;
   F1 := 1;
   if (In == 0) {
     Out := F0
   } else {
     if (In == 1) {
       Out := F1
     } else {
       for (C := 2; C <= In; C++) {
         T  := F0 + F1;
         F0 := F1;
         F1 := T;
         Out := T
       }
     }
   }
-}
fibonacci :: Statement
fibonacci = slist [ Assign "F0" (Val 1)
                  , Assign "F1" (Val 1)
                  , If (Op (Var "In") Eql (Val 0))
                       (Assign "Out" (Var "F0"))
                       (If (Op (Var "In") Eql (Val 1))
                           (Assign "Out" (Var "F1"))
                           (For (Assign "C" (Val 2))
                                (Op (Var "C") Le (Var "In"))
                                (Incr "C")
                                (slist
                                 [ Assign "T" (Op (Var "F0") Plus (Var "F1"))
                                 , Assign "F0" (Var "F1")
                                 , Assign "F1" (Var "T")
                                 , Assign "Out" (Var "T")
                                 ])
                           )
                       )
                  ]
