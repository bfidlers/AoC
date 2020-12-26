import Data.Maybe
import Data.List

main = do input <- readFile "input.txt"
          print . calc . map (\x -> read x :: Int) . words $ input

calc :: [Int] -> Int
calc (a:b:xs) = e
    where e = encryptionKey b loopSize1
          loopSize1 = findLoopSize a

findLoopSize :: Int -> Int 
findLoopSize nb = fromJust . elemIndex nb $ (iterate (\ x -> mod (7*x) 20201227) 1)

encryptionKey :: Int -> Int -> Int 
encryptionKey nb loop = (iterate' (\ x -> mod (nb*x) 20201227) 1) !! loop
