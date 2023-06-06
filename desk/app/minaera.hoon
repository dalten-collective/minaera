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
+$  state-0  [%0 graph=(map @tas [count=@ud =database:n])]
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
      ?<  (~(has by graph.state) app.act)
      =.  graph.state
        %+  ~(put by graph.state)
          app.act
        :-  count=0
        =-  +.- 
        %+  ~(q db:n *database:n)
            app.act
          :+  %add-table
            dap.bowl
          :*  schema=(make-schema:n aera-schema)
              primary-key=~[%id]
              indices=(make-indices:n [~[%id] primary=& autoincrement=`1 unique=& clustered=|]~)
              records=~
          ==
      `this
      ::
        %add-edge
      =/  eq  edge-query.act
      ?.  (~(has by graph.state) app.act)
        ~|("%minaera: initialize database for {<app.act>} first!" !!)
      =+  [count database]=(~(got by graph.state) app.act)
      :-  ~
      %=    this
          graph.state
        %+  ~(put by graph.state)
          app.act
        :-  +(count)
        =<  +
        %+  ~(q db:n database)
          app.act
        =/  row=aera-row
        :~  count
            time.eq
            from.eq
            our.bowl
            what.eq
            tag.eq
            description.eq
            app-tag.eq
            event-version.eq
        ==
        [%insert dap.bowl ~[row]]
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