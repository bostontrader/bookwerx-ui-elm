module Report.Msg exposing (Msg(..))

import RemoteData exposing (WebData)
import Report.Model exposing (FModel, ReportSection)


type Msg
    = FormChanged FModel
      -- When the response to GetDistributions is received, fire one of these messages.
    | DistributionsReceivedA ReportSection (WebData String)
    | DistributionsReceivedB (WebData String)
    | StockForm String String
    | FlowForm String String String
    | BSForm String String String String String String
    | PNLForm String String String String
    | ToggleOmitZeros
    | UpdateDecimalPlaces Int
