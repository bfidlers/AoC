gcdext :: Int -> Int -> (Int, Int)
gcdext n m = gcdexthelper n m 1 0 0 1 where
  gcdexthelper n m x1 y1 xq2 y2 
   | m == 0 = (x1, y1)
   | otherwise = gcdexthelper m r x2 y2 x2p y2p where
     q = div n m
     r = mod n m
     x2p = x1 - q * x2
     y2p = y1 - q * y2
