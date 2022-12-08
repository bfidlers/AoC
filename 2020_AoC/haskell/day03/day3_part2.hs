main :: IO ()
main = do input <- readFile "input.txt"
          print . calculateDiffSlopes . words $ input
    
walkHelp :: Int -> Int -> [String] -> Int 
walkHelp slope n [] = 0  
walkHelp slope n (x:xs) 
    | x !! (mod (n*slope) (length x)) == '#' = 1 + walkHelp slope (n+1) xs
    | otherwise = 0 + walkHelp slope (n+1) xs
    
walkHelp2 :: Int -> [String] -> Int 
walkHelp2 n [] = 0  
walkHelp2 n (x1:[])    
    | x1 !! (mod n (length x1)) == '#' = 1 
    | otherwise = 0 
walkHelp2 n (x1:x2:xs) 
    | x1 !! (mod n (length x1)) == '#' = 1 + walkHelp2 (n+1) xs
    | otherwise = 0 + walkHelp2 (n+1) xs
    
calculateDiffSlopes :: [String] -> Int
calculateDiffSlopes list = slope1 * slope2 * slope3 * slope4 * slope5
    where slope1 = walkHelp 1 0 list 
          slope2 = walkHelp 3 0 list 
          slope3 = walkHelp 5 0 list 
          slope4 = walkHelp 7 0 list 
          slope5 = walkHelp2 0 list 
    
