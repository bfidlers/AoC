main :: IO ()
main = do input <- readFile "input.txt"
          print . walk . extendList . words $ input
          
nbReps :: [[a]] -> Int
nbReps (x:[]) = 0
nbReps (x:xs) = 3 * (div (length (x:xs)) (length x) + 1) 

concatNTimes :: Int -> Int -> [String] -> [String]
concatNTimes _ _ [] =  []
concatNTimes 1 n (x:xs) =  x : concatNTimes n n xs
concatNTimes n0 n1 (x:xs) = (\(a:b) -> (x ++ a):b) (concatNTimes (n0-1) n1 (x:xs))

extendList :: [String] -> [String]
extendList list = concatNTimes reps reps list 
    where reps = nbReps list
        
walk ::[String] -> Int 
walk = walkHelp 0  
    
walkHelp :: Int -> [String] -> Int 
walkHelp n [] = 0  
walkHelp n (x:xs) 
    | x !! (n*2) == '#' = 1 + walkHelp (n+1) xs
    | otherwise = 0 + walkHelp (n+1) xs
    
