/-  alfie=alfie-events-0
/+  *mip, *nectar
|%
::
++  aera-schema
:~  [%id [0 | %ud]]
    [%timestamp [1 | %da]]
    [%from [2 | %p]]
    [%to [3 | %p]]
    [%what [4 | %t]]
    [%tag [5 | %t]]          ::  Sanitizer-defined tag
    [%description [6 | %t]]  ::  English language description of event, keep under 140 characres.
    [%app-tag [7 | %tas]]    :: The head tag of the action item in the app the event is from
    [%event-version [8 | %ud]]     :: The version number of this event
==
::
+$  aera-row
  $:  id=@ud
      timestamp=@da
      from=@p
      to=@p
      what=@t
      tag=@tas
      description=@tas
      app-tag=@tas
      event-version=@ud
      ~
  ==
::
+$  edge-query
  $:  time=@da 
      from=@p
      what=@t
      tag=@tas
      description=@tas
      app-tag=@tas
      event-version=@ud
  ==
::
+$  aera-action
  $%  [%init-graph app=term]
      [%add-edge app=term =edge-query]
      [%placeholder ~]
  ==
--