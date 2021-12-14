import Data.List
import Data.List.Split
import qualified Data.Map as M
import Data.Function

main :: IO ()
main = do input <- readFile "input.txt"
          print . answer . f . parse $ input
          
answer :: [(Char,Int)] -> Int
answer l = maximum freq - minimum freq
    where freq = map (sum . map snd) $ list
          list = groupBy ((==) `on` fst) . sort $ l

f :: (String,Rules) -> [(Char,Int)]
f (input,rules) = (end,1) : (map (\(a,b) -> (head a,b)) . M.toList $ cycles)
    where begin = zip' input (tail input)
          beginMap = foldr (\k m -> M.insert k 1 m) M.empty begin
          end = last input
          cycles = (!! 40) . iterate (step rules) $ beginMap

zip' :: [a] -> [a] -> [[a]]
zip' [] _         = []
zip' _ []         = []
zip' (x:xs) (y:ys) = [x,y] : zip' xs ys

step :: Rules -> M.Map String Int -> M.Map String Int
step r input = foldr (\(a,n) l -> M.insert a (d a l + n) l) M.empty (concat after)
    where elems = M.toList input 
          after = foldr (\(a,n) l -> map (\x -> (x,n)) (split' r a) : l) [] elems
          d x m = M.findWithDefault 0 x m

split' :: Rules -> String -> [String]
split' r [a,b] = [a:m, m ++ [b]]
    where m = r M.! [a,b]

type Rules = M.Map String String

parse :: String -> (String,Rules)
parse input = (first, M.fromList rules)
    where [first,second] = splitOn "\n\n" input
          rules = map ((\[x,y] -> (x,y)) . splitOn " -> ") . lines $ second
