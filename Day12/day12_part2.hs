main :: IO ()
main = do input <- readFile "input.txt"
          print . manhattan . navigate (0, 0) (10, 1) . parseInput . words $ input
          
parseInput :: [String] -> [(Char, Int)]
parseInput [] = []
parseInput ((y:ys):xs) = (y, read ys) : parseInput xs

navigate :: (Int, Int) -> (Int, Int) -> [(Char, Int)] -> (Int, Int)
navigate pos wayP [] = pos
navigate pos wayP (x:xs) 
    | instr == 'L' = navigate pos (rot wayP (360-value)) xs
    | instr == 'R' = navigate pos (rot wayP value) xs
    | instr == 'N' = navigate pos (fst wayP, snd wayP + value) xs
    | instr == 'S' = navigate pos (fst wayP, snd wayP - value) xs
    | instr == 'E' = navigate pos (fst wayP + value, snd wayP) xs
    | instr == 'W' = navigate pos (fst wayP - value, snd wayP) xs
    | instr == 'F' = navigate (fst pos + value * fst wayP, snd pos + value * snd wayP) wayP xs
        where instr = fst x 
              value = snd x
    
rot :: (Int, Int) -> Int -> (Int, Int)
rot (a, b) degr
    | degr == 0 = (a, b) 
    | degr == 90 = (b, -a)
    | degr == 180 = (-a, -b)
    | degr == 270 = (-b, a)
    
              
manhattan :: (Int, Int) -> Int 
manhattan (a,b) = abs a + abs b
