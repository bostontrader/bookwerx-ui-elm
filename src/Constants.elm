module Constants exposing
    ( bwuiVersion
    , flashMessageDuration
    , flashMessagePollInterval
    , initialBserver
    , initialDRCRFormat
    , initialDecimalPlaces
    , initialLanguage
    )

import Translate exposing (Language(..))
import Types exposing (DRCRFormat(..))

-- sync with package.json
bwuiVersion : String
bwuiVersion =
    "1.11.0"


flashMessageDuration : Int
flashMessageDuration =
    5000 -- milliseconds


flashMessagePollInterval : Float
flashMessagePollInterval =
    5000 -- milliseconds


initialBserver : String
initialBserver =
    "http://94.74.116.6:3003"


initialDecimalPlaces : Int
initialDecimalPlaces =
    2


initialDRCRFormat : DRCRFormat
initialDRCRFormat =
    DRCR


initialLanguage : Language
initialLanguage =
    English
