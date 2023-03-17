{-# OPTIONS_GHC -Wall #-}

import           Text.ParserCombinators.Parsec

data JsonValue
  = String String
  | Number Int
  | Array [JsonValue]
  | Bool Bool
  | Null
  | Object [(String, JsonValue)]
  deriving (Show, Eq)

parseJson :: String -> Maybe JsonValue
parseJson str =
  case parse json "" str of
    Left _  -> Nothing
    Right v -> Just v

json :: Parser JsonValue
json = do
  whiteSpace
  value <- jsonValue
  eof
  return value

jsonValue :: Parser JsonValue
jsonValue = do
  whiteSpace
  value <-
    try (string "null" >> return Null)
      <|> try (string "true" >> return (Bool True))
      <|> try (string "false" >> return (Bool False))
      <|> try jsonString
      <|> try jsonNumber
      <|> try jsonArray
      <|> try jsonObject
  whiteSpace
  return value

jsonString :: Parser JsonValue
jsonString = do
  _ <- char '"'
  str <- many (noneOf "\"")
  _ <- char '"'
  return $ String str

jsonNumber :: Parser JsonValue
jsonNumber = do
  str <- many1 digit
  return $ Number (read str)

jsonArray :: Parser JsonValue
jsonArray = do
  _ <- char '['
  whiteSpace
  values <- sepBy jsonValue (char ',')
  whiteSpace
  _ <- char ']'
  return $ Array values

jsonObject :: Parser JsonValue
jsonObject = do
  _ <- char '{'
  whiteSpace
  pairs <- sepBy jsonPair (char ',')
  whiteSpace
  _ <- char '}'
  return $ Object pairs

jsonPair :: Parser (String, JsonValue)
jsonPair = do
  whiteSpace
  key <- jsonString
  whiteSpace
  _ <- char ':'
  whiteSpace
  value <- jsonValue
  whiteSpace
  return (getString key, value)

getString :: JsonValue -> String
getString (String str) = str
getString _            = error "not a string"

whiteSpace :: Parser ()
whiteSpace = skipMany (oneOf " \t\n")
