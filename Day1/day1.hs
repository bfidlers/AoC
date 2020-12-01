parseInputSum2 :: IO ()
parseInputSum2 = do input <- readFile "input.txt"
                    print . findValue2 . (map (\ x -> read x :: Int)) . words $ input
                   
parseInputSum3 :: IO ()
parseInputSum3 = do input <- readFile "input.txt"
                    print . findValue3 . (map (\ x -> read x :: Int)) . words $ input
                   
findValue2 :: [Int] -> [Int]
findValue2 list = [ a * b | a <- list, b <- list, a + b == 2020]

findValue3 :: [Int] -> [Int]
findValue3 list = [ a * b * c| a <- list, b <- list, c <- list , a + b + c == 2020]
