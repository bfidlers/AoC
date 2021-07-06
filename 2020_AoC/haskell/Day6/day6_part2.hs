import Data.List

main :: IO ()
main = do input <- readFile "input.txt"
          print . sum . map length . parseInput $ input

parseInput :: String -> [String]
parseInput input = concatBlocks . lines $ input

concatBlocks :: [String] -> [String]
concatBlocks [] = []
concatBlocks (x:xs) 
    | null xs = [x] 
    | x == "" = ["#"] ++ (concatBlocks xs)
    | otherwise = (\ (y:ys) -> ((getDuplicates x y)):ys) (concatBlocks xs)
    
getDuplicates :: String -> String -> String 
getDuplicates x "#" = x
getDuplicates x [] = []
getDuplicates [] y = []
getDuplicates (x:xs) y
        | elem x y = x : getDuplicates xs y
        | otherwise = getDuplicates xs y 
