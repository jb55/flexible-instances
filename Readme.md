
# Data.Flexible.Instances

Provides PersistField, toJSON and fromJSON instances for converting data types
to and from databases or json with a bit more flexibility. If it fails to parse
the concrete form of the data type it will try and use a more flexible form such
as Text, or whatever else you choose.

## Example

```haskell

type FlexibleCountry = Flexible Text Country

parseCountry :: Text -> FlexibleCountry
parseCountry "US" = Some UnitedStates
parseCountry "CA" = Some Canada
parseCountry "JP" = Some Japan
parseCountry x
  | T.null x  = NotThere
  | otherwise = Raw x

instance PersistField Country where
  -- ...

entities = mkPersist persistBackend
entities [myCasing|
  Address json
    street      Text Maybe
    company     Text Maybe
    city        Text Maybe
    state       Text Maybe
    country     FlexibleCountry
    deriving Show Eq Ord
|]
```


