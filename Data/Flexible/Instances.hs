{-# LANGUAGE OverloadedStrings #-}

module Data.Flexible.Instances (
) where

import           Data.Flexible
import           Data.Text (Text)
import qualified Data.Text as T
import           Control.Applicative
import           Data.Default (Default(..))
import           Database.Persist.Class
import           Database.Persist.Sql
import           Database.Persist.Types (PersistValue(..))
import           Control.Monad.Error
import           Data.Aeson

instance (ToJSON a, ToJSON b) => ToJSON (Flexible b a) where
  toJSON (Some x) = toJSON x
  toJSON (Raw  x) = toJSON x
  toJSON NotThere = Null

instance (FromJSON a, FromJSON b) => FromJSON (Flexible b a) where
  parseJSON Null = return NotThere
  parseJSON v = (Some <$> parseJSON v) <|>
                (Raw  <$> parseJSON v)

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
