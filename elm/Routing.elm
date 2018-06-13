module Routing exposing (extractRoute)

import Navigation exposing (Location)
import UrlParser exposing (..)

import Types exposing (Route(..))


extractRoute : Location -> Route
extractRoute location =
    case (parsePath matchRoute location ) of
        Just route ->
            route

        Nothing ->
            NotFound

-- This is a private function.  Don't directly test this.
matchRoute : Parser (Route -> a) a
matchRoute =
    oneOf
        [ map CurrenciesAdd (s "currencies" </> s "add")
        , map CurrenciesEdit (s "currencies" </> int)
        , map CurrenciesIndex (s "currencies")
        ]