{-# LANGUAGE OverloadedStrings #-}

module Data.Flexible.Instances (
) where

import Control.Applicative
import Control.Monad.Error
import Data.Aeson
import Data.Typeable
import Data.Default (Default(..))
import Data.Flexible
import Data.Text (Text)
import Data.ByteString.Char8 (unpack)
import Database.Persist.Class
import Database.Persist.Sql
import Database.Persist.Types (PersistValue(..))
import Database.PostgreSQL.Simple.FromField

import qualified Data.Text as T

instance (ToJSON a, ToJSON b) => ToJSON (Flexible b a) where
  toJSON (Some x) = toJSON x
  toJSON (Raw  x) = toJSON x
  toJSON NotThere = Null

instance (FromJSON a, FromJSON b) => FromJSON (Flexible b a) where
  parseJSON Null = return NotThere
  parseJSON v = (Some <$> parseJSON v) <|>
                (Raw  <$> parseJSON v)

instance (Typeable b, Typeable a, FromField b, FromField a) => FromField (Flexible b a) where
  fromField _ Nothing   = return NotThere
  fromField f bs =
    (Some <$> fromField f bs) <|>
    (Raw <$> fromField f bs) <|>
    (returnError ConversionFailed f
       ("no parse on Some or Raw in Flexible: " ++ maybe "null" unpack bs))


-- not sure if this should be here but we need it for the PersistField instance
instance Error Text where
  noMsg  = T.empty
  strMsg = T.pack

instance (PersistField a, PersistField b) => PersistFieldSql (Flexible a b) where
  sqlType _ = SqlString

instance (PersistField a, PersistField b) => PersistField (Flexible b a) where
  toPersistValue (Some a) = toPersistValue a
  toPersistValue (Raw a)  = toPersistValue a
  toPersistValue NotThere = PersistNull
  fromPersistValue PersistNull = Right NotThere
  fromPersistValue v = (Some <$> fromPersistValue v) <|>
                       (Raw  <$> fromPersistValue v) <|>
                       Left "no parse on Some or Raw in Flexible"

instance Default (Flexible b a) where
  def = NotThere
