import Html exposing (..)
import Html.App as Html
import Time exposing (Time, second)



main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }



-- MODEL


type alias Person =
  { rate : Float }

type alias Model =
  { people : List Person
  , meetingStarted : Bool
  , meetingCost : Float
  }


init : (Model, Cmd Msg)
init =
  (Model [] False 0, Cmd.none)



-- UPDATE


type Msg
  = AddPerson
    | SetPersonCost Int Float
    | RemovePerson Int
    | StartMeeting
    | Tick Time
    | EndMeeting
    | Reset



update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of

    AddPerson ->
      let
        newPerson = Person 500
        newPeople = model.people ++ [ newPerson ]
      in
        ({model | people = newPeople}, Cmd.none)

    _ ->
      (model, Cmd.none)



-- SUBSCRIPTIONS


subscriptions : Model -> Sub Msg
subscriptions model =
  Time.every second Tick



-- VIEW


view : Model -> Html Msg
view model =
    div [] [text "Hello World !"]
