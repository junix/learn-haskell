module Codewars.Seven where
import Control.Monad.State
{-
to be divisible or not by 7 is obtained; you can stop when this number has at most 2 digits because you are supposed to know if a number of at most 2 digits is divisible by 7 or not.
The original number is divisible by 7 if and only if the last number obtained using this procedure is divisible by 7.

Examples:

1 - m = 371 -> 37 − (2×1) -> 37 − 2 = 35 ; thus, since 35 is divisible by 7, 371 is divisible by 7.

The number of steps to get the result is 1.

2 - m = 1603 -> 160 - (2 x 3) -> 154 -> 15 - 8 = 7 and 7 is divisible by 7.

3 - m = 372 -> 37 − (2×2) -> 37 − 4 = 33 ; thus, since 33 is not divisible by 7, 372 is not divisible by 7.

The number of steps to get the result is 1.

4 - m = 477557101->47755708->4775554->477547->47740->4774->469->28 and 28 is divisible by 7, so is 477557101.

The number of steps is 7.

Task:

Your task is to return to the function seven(m) (m integer >= 0) an array (or a pair, depending on the language) of numbers, the first being the last number m with at most 2 digits obtained by your function (this last m will be divisible or not by 7), the second one being the number of steps to get the result.

seven(371) should return [35, 1]
seven(1603) should return [7, 2]
seven(477557101) should return [28, 7]
-}

seven :: Integer -> (Integer, Int)
seven m = swap $ runState calc'' m

iter (m, n) = if m' <= 0 then (m, n) else iter (m', n+1)
  where m' = step m

step x = d - 2 * r
  where (d, r) = x `quotRem` 10

calc :: Integer -> State Integer Integer
calc n = state $ \x ->
    let v = step x
    in  if v <= 0
        then (v, x)
        else (v, v)

calc' :: Integer -> State Integer Integer
calc' n = do
    v <- calc n
    if v <= 0
        then return (n-1)
        else calc' (n+1)

calc'' :: State Integer Integer
calc'' = calc' 1

swap :: (Integer, Integer) ->  (Integer, Int)
swap (a,b) = (b, fromInteger a)


