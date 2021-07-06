import Data.List

main = do input <- readFile "input.txt"
--          print . group . sort . map (calculatePos . makePath . countOccurences . parse) . lines $ input
          print . length . filter (\ x -> mod (length x) 2 == 1) . group . sort . map (calculatePos . makePath . countOccurences . parse) . lines $ input

parse :: String -> [String]
parse [] = []
parse (x:xs) 
    | x == 'e' || x == 'w' = [x] : parse xs
    | otherwise = (\ (a:as) -> [x:a] ++ as) (parse xs)

data Path = Path Int -- e
                 Int -- w
                 Int -- ne
                 Int -- sw
                 Int -- nw
                 Int -- se
    deriving (Eq, Ord, Show) 

data Pos = Pos Double -- x
               Double -- y
    deriving (Ord, Show) 

instance Eq Pos where
    Pos a1 a2 == Pos b1 b2 = abs (a1 - b1) < 1e-7 && abs (a2 - b2) < 1e-7

countOccurences :: [String] -> (Int, Int, Int, Int, Int, Int) 
countOccurences [] = (0, 0, 0, 0, 0, 0)
countOccurences (x:xs)
    | x == "e" = (\ (a, b, c, d, e, f) -> (a + 1, b, c, d, e, f)) (countOccurences xs)
    | x == "w" = (\ (a, b, c, d, e, f) -> (a, b + 1, c, d, e, f)) (countOccurences xs)
    | x == "ne" = (\ (a, b, c, d, e, f) -> (a, b, c + 1, d, e, f)) (countOccurences xs)
    | x == "sw" = (\ (a, b, c, d, e, f) -> (a, b, c, d + 1, e, f)) (countOccurences xs)
    | x == "nw" = (\ (a, b, c, d, e, f) -> (a, b, c, d, e + 1, f)) (countOccurences xs)
    | x == "se" = (\ (a, b, c, d, e, f) -> (a, b, c, d, e, f + 1)) (countOccurences xs)

makePath :: (Int, Int, Int, Int, Int, Int) -> Path 
makePath (a,b,c,d,e,f) = Path a b c d e f

--simplify :: Path -> Path 
--simplify (Path e w ne sw nw se) = Path (e-min1) (w-min1) (ne-min2) (se-min2) (nw-min3) (sw-min3)
--    where min1 = minimum [e,w]
--          min2 = minimum [ne,sw]
--          min3 = minimum [nw,se]

calculatePos :: Path -> Pos 
calculatePos (Path e w ne sw nw se) = Pos (fromIntegral (round (x*100))/100) (fromIntegral (round (y*100))/100) 
    where x = fromIntegral e - fromIntegral w + (fromIntegral ne * cos(pi/3)) + (fromIntegral se * cos(pi/3)) - (fromIntegral nw * cos(pi/3)) - (fromIntegral sw * cos(pi/3))
          y = (fromIntegral ne * sin(pi/3)) - (fromIntegral se * sin(pi/3)) + (fromIntegral nw * sin(pi/3)) - (fromIntegral sw * sin(pi/3))
