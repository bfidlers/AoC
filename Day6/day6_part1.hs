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
    | x == "" = [""] ++ (concatBlocks xs)
    | otherwise = (\ (y:ys) -> (nub(x++y)):ys) (concatBlocks xs)
