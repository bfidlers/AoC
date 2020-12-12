main :: IO ()
main = do input <- readFile "input.txt"
          print . manhattan . navigate (0, 0) 0 . parseInput . words $ input
          
parseInput :: [String] -> [(Char, Int)]
parseInput [] = []
parseInput ((y:ys):xs) = (y, read ys) : parseInput xs

navigate :: (Int, Int) -> Int -> [(Char, Int)] -> (Int, Int)
navigate pos ori [] = pos
navigate pos ori (x:xs) 
    | instr == 'L' = navigate pos (mod (ori - value) 360) xs
    | instr == 'R' = navigate pos (mod (ori + value) 360) xs
    | instr == 'N' = navigate (fst pos + value, snd pos) ori xs
    | instr == 'S' = navigate (fst pos - value, snd pos) ori xs
    | instr == 'E' = navigate (fst pos, snd pos + value) ori xs
    | instr == 'W' = navigate (fst pos, snd pos - value) ori xs
    | instr == 'F' = if ori == 0
                        then navigate (fst pos, snd pos + value) ori xs
                    else if ori == 90
                        then navigate (fst pos - value, snd pos) ori xs
                    else if ori == 180
                        then navigate (fst pos, snd pos - value) ori xs
                    else navigate (fst pos + value, snd pos) ori xs
        where instr = fst x 
              value = snd x
              
manhattan :: (Int, Int) -> Int 
manhattan (a,b) = abs a + abs b

