module Distribution.API.JSON exposing
    ( distributionDecoder
    , distributionJoinedsDecoder
    , distributionReportsDecoder
    )

import Distribution.Distribution
    exposing
        ( DistributionJoined
        , DistributionRaw
        , DistributionReport
        )
import Json.Decode exposing (Decoder, int, string)
import Json.Decode.Pipeline exposing (required)


distributionDecoder : Decoder DistributionRaw
distributionDecoder =
    Json.Decode.succeed DistributionRaw
        |> required "id" int
        |> required "apikey" string
        |> required "account_id" int
        |> required "amount" int
        |> required "amountbt" string
        |> required "amount_exp" int
        |> required "transaction_id" int


distributionJoinedsDecoder : Decoder (List DistributionJoined)
distributionJoinedsDecoder =
    Json.Decode.list distributionJoinedDecoder


distributionJoinedDecoder : Decoder DistributionJoined
distributionJoinedDecoder =
    Json.Decode.succeed DistributionJoined
        |> required "account_title" string
        |> required "aid" int
        |> required "amount" int
        |> required "amountbt" string
        |> required "amount_exp" int
        |> required "apikey" string
        |> required "id" int
        |> required "tid" int
        |> required "tx_notes" string
        |> required "tx_time" string


distributionReportsDecoder : Decoder (List DistributionReport)
distributionReportsDecoder =
    Json.Decode.list distributionReportDecoder


distributionReportDecoder : Decoder DistributionReport
distributionReportDecoder =
    Json.Decode.succeed DistributionReport
        |> required "account_id" int
        |> required "amount" int
        |> required "amountbt" string
        |> required "amount_exp" int
        |> required "time" string
