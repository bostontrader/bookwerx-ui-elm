-- Support for a controlled input for an integer


module IntField exposing (IntField(..), intFieldToInt, intFieldToString, intValidationClass)


type IntField
    = IntField (Maybe Int) String


intFieldToInt : IntField -> Int
intFieldToInt intField =
    case intField of
        IntField Nothing int ->
            0

        IntField (Just int) _ ->
            int


intFieldToString : IntField -> String
intFieldToString intField =
    case intField of
        IntField Nothing int ->
            int

        -- the unparseable string value
        IntField (Just int) _ ->
            String.fromInt int


intValidationClass : IntField -> String
intValidationClass intField =
    case intField of
        IntField Nothing int ->
            if int == "" then
                ""

            else if int == "-" then
                -- the beginning negative sign is not an integer but it's also not an error.
                ""

            else
                "has-background-danger"

        IntField (Just int) _ ->
            ""
