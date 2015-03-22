{-
    Given a string, find the length of the longest substring 
    without repeating characters. For example, the longest 
    substring without repeating letters for "abcabcbb" is "abc", 
    which the length is 3. For "bbbbb" the longest substring 
    is "b", with the length of 1.
-}

import Control.Monad.State

step c = state $ \(maxs,tails) -> 
    let 
      ntails  = c:(takeWhile (/=c) tails)
      maxLen  = length maxs
      tailLen = length ntails
      nmaxs   = if maxLen < tailLen then ntails else maxs
    in 
      (length nmaxs,(nmaxs,ntails))

eat ""     = do return 0
eat (x:xs) = do 
  v0 <-step x
  v1 <-eat xs
  return $ max v0 v1

calc str = evalState (eat str) ("","")
