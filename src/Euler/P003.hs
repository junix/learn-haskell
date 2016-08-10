module Euler.P003 where

primes = filterPrime [2..]
  where filterPrime (p:xs) =
          p : filterPrime [x | x <- xs, x `mod` p /= 0]

maxFactor = go primes
    where go (x:xs) v
            | x > v     = v
            | r == 0    = max x (go primes d)
            | otherwise = go xs v
            where (d,r) = v `quotRem` x

