module Constants exposing
    ( bwuiVersion
    , flashMessageDuration
    , flashMessagePollInterval
    , initialBserver
    , initialDRCRFormat
    , initialDecimalPlaces
    , initialLanguage
    , initialRarityFilter
    )

import Translate exposing (Language(..))
import Types exposing (DRCRFormat(..))


bwuiVersion : String
bwuiVersion =
    "1.0.2"



-- sync with package.json


flashMessageDuration : Int
flashMessageDuration =
    15000



-- milliseconds


flashMessagePollInterval : Float
flashMessagePollInterval =
    5000



-- milliseconds


initialBserver : String
initialBserver =
    "http://23.253.160.60:3003"


initialDecimalPlaces : Int
initialDecimalPlaces =
    2


initialDRCRFormat : DRCRFormat
initialDRCRFormat =
    DRCR


initialLanguage : Language
initialLanguage =
    English


initialRarityFilter : Int
initialRarityFilter =
    10
