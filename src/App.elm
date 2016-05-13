import Html.App as Html
import Html exposing (..)
import Html.Attributes exposing (..)
import Html.Events exposing (onClick, onInput)
import Time exposing (Time, second)
import String


main =
  Html.program
    { init = init
    , view = view
    , update = update
    , subscriptions = subscriptions
    }


-- MODEL
type alias Person = Int
type alias PersonId = Int

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
    | RemovePerson PersonId
    | SetPersonCost PersonId String
    | StartMeeting
    | Tick Time
    | EndMeeting
    | Reset

update : Msg -> Model -> (Model, Cmd Msg)
update action model =
  case action of

    AddPerson ->
      let
        newPerson = 500
        newPeople = model.people ++ [ newPerson ]
      in
        ({model | people = newPeople}, Cmd.none)

    SetPersonCost index rateAsString ->
      let
        newRate = Result.withDefault 0 (String.toInt rateAsString)
        newPeopleList = updateInList index newRate model.people
      in
        ({model | people = newPeopleList}, Cmd.none)

    RemovePerson index ->
        ({model | people = removeFromList index model.people}, Cmd.none)

    StartMeeting ->
      ({model | meetingStarted = True}, Cmd.none)

    EndMeeting ->
      ({model | meetingStarted = False}, Cmd.none)

    Tick _ ->
      let
        newMeetingCost = model.meetingCost + (model.people |> List.map rateBySecond |> List.sum)
      in
        ({model | meetingCost = newMeetingCost}, Cmd.none)

    Reset ->
      ({model | meetingCost = 0}, Cmd.none)

removeFromList : Int -> List a -> List a
removeFromList index list =
  (List.take index list) ++ (List.drop (index+1) list)

updateInList : Int -> a -> List a -> List a
updateInList index value list =
  (List.take index list) ++ [value] ++ (List.drop (index+1) list)

rateBySecond : Int -> Float
rateBySecond rate =
  (toFloat rate) / 3600

{-| Round a `Float` to a given number of decimal places. -}
roundTo : Int -> Float -> Float
roundTo places =
  let
    factor = 10 ^ places
  in
    (*) factor >> round >> toFloat >> (\n -> n / factor)


-- SUBSCRIPTIONS
subscriptions : Model -> Sub Msg
subscriptions model =
  if model.meetingStarted then
    Time.every second Tick
  else
    Sub.none


-- VIEWs
view : Model -> Html Msg
view model =
    div []
      [ viewMeetingCost model.meetingCost
      , viewCommands model.meetingStarted
      , viewPeople model.people
      ]

viewCommands : Bool -> Html Msg
viewCommands meetingStarted =
  div []
    [ button [onClick AddPerson] [text "Add person"]
    , button [(disabled meetingStarted), (onClick StartMeeting)] [text "Start"]
    , button [(disabled (not meetingStarted)), (onClick EndMeeting)] [text "Stop"]
    , button [(onClick Reset)] [text "Reset"]
    ]

viewMeetingCost : Float -> Html Msg
viewMeetingCost meetingCost =
  let
    roundedCostString = meetingCost |> roundTo 2 |> toString
  in
    div [] [text roundedCostString]

viewPeople : List Person -> Html Msg
viewPeople people =
  ul [] (List.indexedMap (\index person -> li [] [viewPerson index person]) people)

viewPerson : PersonId -> Person -> Html Msg
viewPerson personId personRate =
  p []
    [ text "I cost"
    , input [(type' "number"), (value (toString personRate)), (onInput (SetPersonCost personId))] []
    , text "Per hour"
    , button [onClick (RemovePerson personId)] [text "x"]
    ]
