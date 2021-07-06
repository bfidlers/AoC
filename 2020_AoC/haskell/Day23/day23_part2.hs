import Data.Char (digitToInt)
import Data.List
import Data.Maybe

main = do input <- readFile "input.txt"
          print . play 10000000 . parse $ input

parse :: String -> [Int]
parse = map (digitToInt)

play :: Int -> [Int] -> [Int]
play 0 game = game
play n game = play (n-1) newGameState
    where newGameState = dst1 ++ pickUp ++ dst2 ++ [current] 
          current = head game 
          pickUp = tail . fst $ split1 
          end = snd split1
          split1 = splitAt 4 game
          dst = findDst current end
          (dst1, dst2) = splitAt dst end
           
findDst :: Int -> [Int] -> Int 
findDst nb list
    | isNothing index = findDst dst list
    | otherwise = fromJust index + 1
    where index = elemIndex dst list
          dst = if nb == 1 then 9 else nb - 1
          
result :: [Int] -> String 
result input = concat r
    where r = drop (index+1) str ++ take index str
          index = fromJust . elemIndex "1" $ str 
          str = map (show) input
