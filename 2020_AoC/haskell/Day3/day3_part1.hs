main :: IO ()
main = do input <- readFile "input.txt"
          print . walk . words $ input
        
walk ::[String] -> Int 
walk = walkHelp 0  
    
walkHelp :: Int -> [String] -> Int 
walkHelp n [] = 0  
walkHelp n (x:xs) 
    | x !! (mod (n*3) width) == '#' = 1 + walkHelp (n+1) xs
    | otherwise = 0 + walkHelp (n+1) xs
        where width = length x
    
