module Main where

import Data.Char (digitToInt)

main :: IO ()
main = getLine >>= (putStrLn . outputStmt . luhnCheckString)

luhnCheck :: [Int] -> Bool
luhnCheck xs =
  ( sum [x | (x, idx) <- enumerate sx, even idx]
      + sum [x `div` 10 + x `mod` 10 | (x, idx) <- enumerate ((* 2) <$> sx), odd idx]
  )
    `mod` 10
    == 0
 where
  sx = reverse xs
  enumerate arr = zip arr [0 ..]

luhnCheckString :: String -> Bool
luhnCheckString = luhnCheck . map digitToInt

outputStmt :: Bool -> String
outputStmt value
  | value = "Ok"
  | otherwise = "Failed"
