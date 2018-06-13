module MiscTest exposing (..)

import Expect
import Test exposing (Test, test)

blankTest : Test
blankTest =
    test "blankTest" <|
        \_ -> Expect.equal 1 1
