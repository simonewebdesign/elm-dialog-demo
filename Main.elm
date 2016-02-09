module Main where

import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (on, targetValue)
--exposing (Dialog, Dialog.Simple)
import Dialog exposing (Dialog)
import Dialog.Simple


import Effects exposing (Effects)

type alias Model =
  { dialog : Dialog
  , title : String
  }

initialModel : Model
initialModel =
  { dialog = Dialog.initial
  , title = ""
  }


init : (Model, Effects Action)
init =
  ( initialModel, Effects.none )


type Action
  = NoOp
  | SetTitle String
  | DialogAction Dialog.Action


update : Action -> Model -> ( Model, Effects Action )
update action model =
  case action of
    NoOp ->
      ( model, Effects.none )

    SetTitle newTitle ->
      ( { model
          | title = newTitle
        }
      , Effects.none
      )

    DialogAction a ->
      ( model, Effects.none )
      --Dialog.update a model


view : Signal.Address Action -> Model -> Html
view address model =
  div
    [ ]
    [ h1 [ ] [ text model.title ]
    , text "Hello world"
    , input
      [ type' "text"
      , value model.title
      , onInput ]
    , button
      [ Dialog.openOnClick (dialog address) ]
      [ text "Open dialog" ]
    , Dialog.Simple.view model.dialog -- just a shell, hidden by default
    ]


dialog : Signal.Address Action -> Dialog.Options -> List Html
dialog address options =
  [ Dialog.Simple.header options "Are you sure?"
  , Dialog.Simple.body
      [ p [] [ text "Please give it a second thought." ] ]
  , Dialog.Simple.footer
      [ a
          [ class "btn btn-default"
          , Dialog.closeOnClick
          ]
          [ text "You make me doubt" ]
      , a
          [ class "btn btn-primary"
          , Dialog.closeThenSendOnClick address (SetTitle "Dialog closed.")
          ]
          [ text "FFS, go on!" ]
      ]
  ]


main : Signal Html
main =
  Signal.map (view actions.address) model


actions : Signal.Mailbox Action
actions =
  Signal.mailbox NoOp


--dialogActions : Signal Action
--dialogActions =
--  Signal.map DialogAction Dialog.actions


--inputs =
--  Signal.mergeMany [ actions.signal, dialogActions ]


model : Signal Model
model =
  Signal.foldp update initialModel actions.signal


--port tasks : Signal (Task.Task Never ())
--port tasks =
--  app.tasks


onInput : Signal.Address a -> (String -> a) -> Attribute
onInput address contentToValue =
    on "input" targetValue (\str -> Signal.message address (contentToValue str))
