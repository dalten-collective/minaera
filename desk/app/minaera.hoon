/-  *minaera, feed
/+  n=nectar, verb, dbug, default-agent, *sss
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
::
::  `graph` is a mip keyed by [ship [app feed]]. 
::     - `feed` is the name of the agent submitting to the graph
::     - `app` is the source of information getting submitted.
::
::  `graph` can all be considered a (map @p database) since a database is just a (map [app feed] table)
::  we bounce between these two abstractions depending on how convenient it is.
::
+$  state-0  [%0 graph=database:n]
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
=/  sub-feed  (mk-subs feed ,[%minaera %feed @ @ ~])
=/  pub-feed  (mk-pubs feed ,[%minaera %feed @ @ ~]) 
::
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
    da-feed  =/  da  (da feed ,[%minaera %feed @ @ ~])
                   (da sub-feed bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    du-feed  =/  du  (du feed ,[%minaera %feed @ @ ~])
                  (du pub-feed bowl -:!>(*result:du))
++  on-fail
  ~>  %bout.[0 '%minaera +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%minaera +on-leave']
  on-leave:def
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
    ?+    wire  `this
    [~ %sss %behn @ @ @ %minaera %feed @ @ ~]  [(behn:da-feed |3:wire) this]
  ==
::
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%minaera +on-init']
  `this
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%minaera +on-save']
  !>([state pub-feed sub-feed])
::
++  on-load
  |=  =vase
  ~>  %bout.[0 '%minaera +on-load']
  ^-  (quip card _this)
  =/  old  !<  [state-0 =_pub-feed =_sub-feed]  vase
  :-  ~
  %=    this
    state     -.old
    pub-feed  pub-feed.old
    sub-feed  sub-feed.old
  ==
::
++  on-poke
  |=  [=mark =vase]
  ~>  %bout.[0 '%minaera +on-poke']
  ^-  (quip card _this)
  ?+    mark  !!
      %aera-action
    ~&  >  vase
    =/  act  !<(aera-action vase)
    ~&  >  act
    ?+    -.act  !!
        %init-table
      =/  new-table=table:n
          :*  schema=(make-schema:n aera-schema)
              primary-key=~[%id]
              indices=(make-indices:n [~[%id] primary=& autoincrement=~ unique=& clustered=|]~)
              records=~
          ==
      =?  graph.state  !(~(has by graph.state) app.act^feed.act) 
        =<  +
        %+  ~(q db:n graph.state)
          app.act
        [%add-table feed.act new-table]
      =^  cards  pub-feed  (give:du-feed [%minaera %feed app.act feed.act ~] [%init new-table])
      [cards this]
      ::
        %add-edge
      ~&  >  'adding edge'
      ?.  (~(has by graph.state) [app.act feed.act])
        ~|("%minaera: initialize table for {<app.act>}, {<feed.act>} first!" !!)
      =.  graph.state
        =<  +
        %+  ~(q db:n graph.state)
          app.act
        [%insert feed.act ~[aera-row.act]]
      =^  cards  pub-feed  (give:du-feed [%minaera %feed app.act feed.act ~] [%add ~[aera-row.act]])
      [cards this]
    ==
    ::
      %surf-feed
    =^  cards  sub-feed
      (surf:da-feed !<(@p (slot 2 vase)) %minaera !<([%minaera %feed @ @ ~] (slot 3 vase)))
    [cards this]
    ::
      %sss-on-rock
    `this
    ::
      %sss-to-pub
    ?-    msg=!<(into:du-feed (fled vase))
        [[%minaera *] *]
      =^  cards  pub-feed  (apply:du-feed msg)
      [cards this]
    ==
    ::
      %sss-feed
    =/  res  !<(into:da-feed (fled vase))
    =^  cards  sub-feed  (apply:da-feed res)
    [cards this]
  ==
::
++  on-peek
  |=  =path
  ~>  %bout.[0 '%minaera +on-peek']
  ^-  (unit (unit cage))
  ~
::
++  on-agent
  |=  [=wire sign=sign:agent:gall]
  ^-  (quip card _this)
  ?+    -.sign  `this
      %poke-ack
    ?~  p.sign  `this
    %-  (slog u.p.sign)
    ?+    wire  `this
        [~ %sss %on-rock @ @ @ %minaera %feed @ @ ~]
      `this
    ::
        [~ %sss %scry-request @ @ @ %minaera %feed @ @ ~]
      =^  cards  sub-feed  (tell:da-feed |3:wire sign)
      [cards this]
    ==
  ==
::
++  on-watch
  |=  path=path
  ~>  %bout.[0 '%minaera +on-watch']
  ^-  (quip card _this)
  `this
--