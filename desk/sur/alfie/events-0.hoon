|%
::
++  event-version  %0
::
+$  negative-react-0
    $:  time=@da
        from=@p
        to=@p
        what=@tas
        tag=%negative-react
        description=%'Negative react: thumbs down.'
        app-tag=%chat-action-0
        event-version=%0
    == 
::
+$  positive-react-0
    $:  time=@da
        from=@p
        to=@p
        what=@tas
        tag=%positive-react
        description=%'Positive react: thumbs up or 100.'
        app-tag=%chat-action-0
        event-version=%0
    ==
--