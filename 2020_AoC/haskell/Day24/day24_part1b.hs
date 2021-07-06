import Data.List

main = do input <- readFile "test.txt"
          print . group . sort . map (simplifyPath . makePath . parse) . lines $ input

parse :: String -> [String]
parse [] = []
parse (x:xs) 
    | x == 'e' || x == 'w' = [x] : parse xs
    | otherwise = (\ (a:as) -> [x:a] ++ as) (parse xs)

data Path = Path Int -- e
                 Int -- ne
                 Int -- se
    deriving (Eq, Ord, Show) 

makePath :: [String] -> Path
makePath [] = Path 0 0 0
makePath (x:xs)
    | x == "e" = (\ (Path a b c) -> (Path (a+1) b c)) (makePath xs)
    | x == "w" = (\ (Path a b c) -> (Path (a-1) b c)) (makePath xs)
    | x == "ne" = (\ (Path a b c) -> (Path a (b+1) c)) (makePath xs)
    | x == "sw" = (\ (Path a b c) -> (Path a (b-1) c)) (makePath xs)
    | x == "se" = (\ (Path a b c) -> (Path a b (c+1))) (makePath xs)
    | x == "nw" = (\ (Path a b c) -> (Path a b (c-1))) (makePath xs)

simplifyPath :: Path -> Path 
simplifyPath (Path e ne se) = Path e2 ne2 se2 
    where e2 = e + min
          ne2 = ne - min
          se2 = se - min 
          min = if ne > 0 && se > 0 
                    then minimum [ne, se]
                else if ne < 0 && se < 0 
                    then maximum [ne, se]
                else 0
