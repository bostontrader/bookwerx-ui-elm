{- We want to be able to manage a "tutorial level."  That is, progressively reveal new features and remove training wheels as usage of the program demonstrates expertise.  However, it's not obvious how we can specify this level.

The first obvious approach is to simply record an integer level.  An obvious problem with this approach is the confusion about which features are on or off at a particular level.  Another problem comes from inserting a new level, perhaps requiring lots of renumbering elsewhere.  Nevertheless, these woes are mere nuisances and this system is workable enough.

It's tempting to consider using a union type.  But... what short and pithy symbols can we use to describe each level?  And how do we determine that level KNARFLE > GARKOG ?  Assuming these issues could be solved, this method would eliminate the insertion-of-a-new-level problem.  But that's not enough payoff to bother with so I'd rather not slay that dragon now.

Therefore method the first, integer level numbers, is what we'll use.

-}
module Tutorial exposing ( updateTutorialLevel)

import Model
import RemoteData


isTutorialLevel01 : Model.Model -> Bool
isTutorialLevel01 model =
    case model.bservers.wdBserver of
        RemoteData.Success _ ->
            True

        _ ->
            False


isTutorialLevel02 : Model.Model -> Bool
isTutorialLevel02 model =
    String.length model.apikeys.apikey > 0


isTutorialLevel03 : Model.Model -> Bool
isTutorialLevel03 model =
    case model.currencies.wdCurrencies of
        RemoteData.NotAsked ->
            False

        RemoteData.Loading ->
            False

        RemoteData.Success _ ->
            List.length model.currencies.currencies > 0

        RemoteData.Failure _ ->
            False


isTutorialLevel04 : Model.Model -> Bool
isTutorialLevel04 model =
    case model.accounts.wdAccounts of
        RemoteData.NotAsked ->
            False

        RemoteData.Loading ->
            False

        RemoteData.Success _ ->
            List.length model.accounts.accounts > 0

        RemoteData.Failure _ ->
            False


isTutorialLevel05 : Model.Model -> Bool
isTutorialLevel05 model =
    case model.categories.wdCategories of
        RemoteData.NotAsked ->
            False

        RemoteData.Loading ->
            False

        RemoteData.Success _ ->
            List.length model.categories.categories > 0

        RemoteData.Failure _ ->
            False


isTutorialLevel06 : Model.Model -> Bool
isTutorialLevel06 model =
    case model.transactions.wdTransactions of
        RemoteData.NotAsked ->
            False

        RemoteData.Loading ->
            False

        RemoteData.Success _ ->
            List.length model.transactions.transactions > 0

        RemoteData.Failure _ ->
            False


updateTutorialLevel : Model.Model -> Model.Model
updateTutorialLevel model =
    if not model.tutorialActive then
        { model | tutorialLevel = 99 }

    else if isTutorialLevel06 model then
        { model | tutorialLevel = 6 }

    else if isTutorialLevel05 model then
        { model | tutorialLevel = 5 }

    else if isTutorialLevel04 model then
        { model | tutorialLevel = 4 }

    else if isTutorialLevel03 model then
        { model | tutorialLevel = 3 }

    else if isTutorialLevel02 model then
        { model | tutorialLevel = 2 }

    else if isTutorialLevel01 model then
        { model | tutorialLevel = 1 }

    else
        { model | tutorialLevel = 0 }














