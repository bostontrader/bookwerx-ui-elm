module Category.Update exposing (categoriesUpdate)

import Browser.Navigation as Nav
import Category.API.Delete exposing (deleteCategoryCommand)
import Category.API.GetMany exposing (getManyCategoriesCommand)
import Category.API.GetOne exposing (getOneCategoryCommand)
import Category.API.JSON exposing (categoriesDecoder, categoryDecoder)
import Category.API.Post exposing (postCategoryCommand)
import Category.API.Put exposing (putCategoryCommand)
import Category.Category exposing (Category)
import Category.Model exposing (Model)
import Category.MsgB exposing (MsgB(..))
import Constants exposing (flashMessageDuration)
import Flash exposing (FlashMsg, FlashSeverity(..), expires)
import IntField exposing (IntField(..))
import Json.Decode exposing (decodeString)
import Msg exposing (Msg(..))
import RemoteData
import Route
import Routing exposing (extractUrl)
import Time
import Translate exposing (Language(..))
import Util exposing (getRemoteDataStatusMessage)


categoriesUpdate : MsgB -> Nav.Key -> Language -> Time.Posix -> Category.Model.Model -> { categories : Model, cmd : Cmd Msg, flashMessages : List FlashMsg }
categoriesUpdate categoryMsgB key language currentTime model =
    case categoryMsgB of
        -- delete
        DeleteCategory url ->
            { categories = model
            , cmd = deleteCategoryCommand url
            , flashMessages = []
            }

        CategoryDeleted response ->
            { categories = model
            , cmd = Nav.pushUrl key (extractUrl Route.CategoriesIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- This does nothing. Can we get rid of it?
        UpdateCategoryAccount _ ->
            { categories = model
            , cmd = Cmd.none
            , flashMessages = []
            }

        UpdateSymbol newSymbol ->
            { categories = { model | editBuffer = updateSymbol model.editBuffer newSymbol }
            , cmd = Cmd.none
            , flashMessages = []
            }

        UpdateTitle newTitle ->
            { categories = { model | editBuffer = updateTitle model.editBuffer newTitle }
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- getMany
        GetManyCategories url ->
            { categories = { model | wdCategories = RemoteData.Loading }
            , cmd = getManyCategoriesCommand url
            , flashMessages = []
            }

        CategoriesReceived newCategoriesB ->
            { categories =
                { model
                    | wdCategories = newCategoriesB
                    , categories =
                        case decodeString categoriesDecoder (getRemoteDataStatusMessage newCategoriesB language) of
                            Ok value ->
                                value

                            Err _ ->
                                -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                                []
                }
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- getOne
        GetOneCategory url ->
            { categories = { model | wdCategory = RemoteData.Loading }
            , cmd = getOneCategoryCommand url
            , flashMessages = []
            }

        CategoryReceived response ->
            { categories =
                case decodeString categoryDecoder (getRemoteDataStatusMessage response language) of
                    Ok value ->
                        { model | editBuffer = value }

                    Err _ ->
                        -- Here we ignore whatever error message comes from the decoder because we should never get any such error and it's otherwise too much trouble to deal with it.
                        model
            , cmd = Cmd.none
            , flashMessages = []
            }

        -- post
        PostCategory url contentType body ->
            --( model, postCategoryCommand model model.categories.editCategory )
            { categories = model
            , cmd = postCategoryCommand url contentType body
            , flashMessages = []
            }

        CategoryPosted response ->
            { categories = model
            , cmd = Nav.pushUrl key (extractUrl Route.CategoriesIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }

        -- put
        PutCategory url contentType body ->
            { categories = model
            , cmd = putCategoryCommand url contentType body
            , flashMessages = []
            }

        CategoryPutted response ->
            { categories = model
            , cmd = Nav.pushUrl key (extractUrl Route.CategoriesIndex)
            , flashMessages = [ FlashMsg (getRemoteDataStatusMessage response language) FlashSuccess (expires currentTime flashMessageDuration) ]
            }


updateSymbol : Category -> String -> Category
updateSymbol c newSymbol =
    { c | symbol = newSymbol }


updateTitle : Category -> String -> Category
updateTitle c newTitle =
    { c | title = newTitle }
