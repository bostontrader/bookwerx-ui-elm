module Category.Update exposing ( categoryUpdate )

import RemoteData exposing ( WebData )

import Misc exposing
    ( findCategoryById
    , insertFlashElement
    )

import Model exposing ( Model )
import Msg exposing ( Msg )
import Route
import TypesB exposing ( FlashMsg, FlashSeverity (..)  )

import Category.API.Delete exposing ( deleteCategoryCommand )
import Category.API.GetMany exposing ( getManyCategoriesCommand )
import Category.API.GetOne exposing ( getOneCategoryCommand )
import Category.API.Patch exposing ( patchCategoryCommand )
import Category.API.Post exposing ( postCategoryCommand )
import Category.Model exposing ( Model )

import Category.Plumbing exposing 
    ( CategoryGetOneHttpResponse(..)
    , CategoryPostHttpResponse(..)
    )

import Category.Category exposing ( Category )
import Category.CategoryMsgB exposing ( CategoryMsgB (..) )


categoryUpdate : Msg -> Model.Model -> CategoryMsgB -> ( Model.Model, Cmd Msg )
categoryUpdate msg model categoryMsgB =

    case categoryMsgB of

        -- delete
        DeleteCategory categoryId ->
            case findCategoryById categoryId model.categories.categories of
                Just wdCategory ->
                    ( model, deleteCategoryCommand wdCategory )

                Nothing ->
                    ( model, Cmd.none )

        CategoryDeleted response ->
            ( model, getManyCategoriesCommand )

        -- getMany
        CategoriesReceived newCategoriesB ->
            ( newCategoriesB
                |> asCategoriesBIn model.categories
                |> asCategoriesAIn model
            , Cmd.none
            )

        -- getOne
        CategoryReceived response ->

            case response of

                RemoteData.NotAsked ->
                    ( response
                        |> asWdCategoryIn model.categories
                        |> asCategoriesAIn model
                    , Cmd.none
                    )

                RemoteData.Loading ->
                    ( response
                        |> asWdCategoryIn model.categories
                        |> asCategoriesAIn model
                    , Cmd.none
                    )

                RemoteData.Failure e ->
                    ( response
                        |> asWdCategoryIn model.categories
                        |> asCategoriesAIn model
                    , Cmd.none
                    )

                RemoteData.Success value ->
                    case value of
                        CategoryGetOneErrorsResponse e ->
                            ( response
                                |> asWdCategoryIn model.categories
                                |> asCategoriesAIn model
                            , Cmd.none
                            )

                        CategoryGetOneDataResponse category ->
                            ( model.categories
                                |> setWdCategory response
                                |> setEditCategory category
                                |> asCategoriesAIn model
                            , Cmd.none
                            )

        -- patch
        PatchCategory ->
            ( model, patchCategoryCommand model.categories.editCategory )

        CategoryPatched response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "category patch error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                RemoteData.Success successResult ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "category patch success" FlashSuccess 0 (model.currentTime + 5000.0)) ) }, Cmd.none )


        -- post
        PostCategory ->
            (model, postCategoryCommand model.categories.editCategory)

        CategoryPosted response ->
            case response of
                RemoteData.NotAsked ->
                    ( model, Cmd.none )
                RemoteData.Loading ->
                    ( model, Cmd.none )

                RemoteData.Failure e ->
                    ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "category post error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                RemoteData.Success successResult ->

                    case successResult of
                        CategoryPostErrorsResponse e ->
                            ( { model | flashMessages = ( insertFlashElement model.flashMessages (FlashMsg "category post error" FlashError 0 (model.currentTime + 5000.0)) ) }, Cmd.none )

                        CategoryPostDataResponse response ->
                            ( { model
                                | flashMessages =
                                    ( insertFlashElement model.flashMessages (FlashMsg "category post success" FlashSuccess 0 (model.currentTime + 5000.0)) )
                                , currentRoute = Route.CategoriesEdit response.insertedId
                              }
                              , getOneCategoryCommand response.insertedId
                            )


        -- edit
        UpdateCategoryTitle newTitle ->
            ( newTitle
                |> asTitleIn model.categories.editCategory
                |> asEditCategoryIn model.categories
                |> asCategoriesAIn model
            , Cmd.none
            )


-- These functions enable us to update fields in nested records of the models using compact and readable code.
-- The Application model has a field named Categories.
setCategoriesA: Category.Model.Model -> Model.Model -> Model.Model
setCategoriesA newCategories model =
    { model | categories = newCategories }

-- The Categories model has a field named Categories.
setCategoriesB: WebData ( List Category ) -> Category.Model.Model -> Category.Model.Model
setCategoriesB newCategories model =
    { model | categories = newCategories }

-- The Categories model has a field named wdCategory.
setWdCategory: WebData CategoryGetOneHttpResponse -> Category.Model.Model -> Category.Model.Model
setWdCategory newWdCategory model =
    { model | wdCategory = newWdCategory }

-- The Categories model has a field named editCategory.
setEditCategory: Category -> Category.Model.Model -> Category.Model.Model
setEditCategory newEditCategory model =
    { model | editCategory = newEditCategory }

asCategoriesAIn: Model.Model -> Category.Model.Model -> Model.Model
asCategoriesAIn =
    flip setCategoriesA

asCategoriesBIn: Category.Model.Model -> WebData ( List Category ) -> Category.Model.Model
asCategoriesBIn =
    flip setCategoriesB

asWdCategoryIn: Category.Model.Model -> WebData CategoryGetOneHttpResponse -> Category.Model.Model
asWdCategoryIn =
    flip setWdCategory

asEditCategoryIn: Category.Model.Model -> Category -> Category.Model.Model
asEditCategoryIn newEditCategory model =
    flip setEditCategory newEditCategory model

setTitle: String -> Category -> Category
setTitle newTitle model =
    { model | title = newTitle }

asTitleIn: Category -> String -> Category
asTitleIn =
    flip setTitle
