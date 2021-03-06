{-
 Rotate an array of n elements to the right by k steps.
 For example, with n = 7 and k = 3, the array [1,2,3,4,5,6,7] 
 is rotated to [5,6,7,1,2,3,4].

 Note:
 Try to come up as many solutions as you can, there are at 
 least 3 different ways to solve this problem.

 Related problem: Reverse Words in a String II
-}

rotate :: [a] -> Int -> [a]
rotate xs n = let (h,t) = splitAt n xs in t ++ h
    
