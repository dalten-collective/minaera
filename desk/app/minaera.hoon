/-  *minaera
/+  n=nectar, verb, dbug, default-agent
::
::  minAera
::
::  holds map of databases keyed by app,
::  holds sss publications over each database,
::  handles permissions over each database.
::  
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0  [%0 graph=(map @tas database:n)]
::
::
::  boilerplate
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state=state-0
::
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
++  on-fail
  ~>  %bout.[0 '%minaera +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%minaera +on-leave']
  on-leave:def
::
++  on-arvo
  |=  [wir=wire sig=sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%minaera +on-init']
  `this
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%minaera +on-save']
  !>(state)
::
++  on-load
  |=  old=vase
  ~>  %bout.[0 '%minaera +on-load']
  ^-  (quip card _this)
  =.  state  !<  state-0  old
  `this
::
++  on-poke
  |=  [=mark =vase]
  ~>  %bout.[0 '%minaera +on-poke']
  ^-  (quip card _this)
  ?+    mark  !!
      %aera-action
    =/  act  !<(aera-action vase)
    ?+    -.act  !!
        %init-graph
      =?  graph.state  !(~(has by graph.state) app.act)
        %+  ~(put by graph.state)
          app.act
        *database:n
      =/  app-db=database:n  (~(got by graph.state) app.act)
      =.  graph.state
        %+  ~(put by graph.state)
          app.act
        =-  +.- 
        %+  ~(q db:n app-db)
            app.act
          :+  %add-table
            feed.act
          :*  schema=(make-schema:n aera-schema)
              primary-key=~[%id]
              indices=(make-indices:n [~[%id] primary=& autoincrement=`1 unique=& clustered=|]~)
              records=~
          ==
      `this
      ::
        %add-edge
      ?.  (~(has by graph.state) app.act)
        ~|("%minaera: initialize database for {<app.act>} first!" !!)
      =+  database=(~(got by graph.state) app.act)
      :-  ~
      %=    this
          graph.state
        %+  ~(put by graph.state)
          app.act
        =<  +
        %+  ~(q db:n database)
          app.act
        [%insert feed.act ~[aera-row.act]]
      ==
    ==
  ==
::
++  on-peek
  |=  pat=path
  ~>  %bout.[0 '%minaera +on-peek']
  ^-  (unit (unit cage))
  ~
::
++  on-agent
  |=  [wir=wire sig=sign:agent:gall]
  ~>  %bout.[0 '%minaera +on-agent']
  ^-  (quip card _this)
  `this
::
++  on-watch
  |=  pat=path
  ~>  %bout.[0 '%minaera +on-watch']
  ^-  (quip card _this)
  `this
--