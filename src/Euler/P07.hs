module Euler.P07 where


primes = filterPrime [2..]
  where filterPrime (p:xs) =
          p : filterPrime [x | x <- xs, x `mod` p /= 0]

calc n = (!!(n-1)) $ primes