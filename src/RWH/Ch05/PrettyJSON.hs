{-#LANGUAGE UnicodeSyntax#-}
module PrettyJSON where

import SimpleJSON (JValue(..))
import Prettify (Doc, (<>), char, series, string, double, fsep, hcat, punctuate, text, compact, pretty)

renderJValue ∷  JValue → Doc
renderJValue (JBool True)  = text "true"
renderJValue (JBool False) = text "false"
renderJValue JNull         = text "null"
renderJValue (JNumber num) = double num
renderJValue (JString str) = string str
renderJValue (JArray ary)  = series '[' ']' renderJValue ary
renderJValue (JObject obj) = series '{' '}' field obj
    where field (name,val) = string name
                          <> text ": "
                          <> renderJValue val

