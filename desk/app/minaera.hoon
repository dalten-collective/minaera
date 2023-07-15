/-  *minaera, feed
/+  n=nectar, verb, dbug, default-agent, *sss
::
::  minAera
::
::  holds database of tables,
::  holds sss publications over each table,
::  handles permissions over each table.
::  
|%
::
+$  versioned-state  $%(state-0)
::
::
::  `graph` is a map keyed by [app feed]. 
::     - `app` is the source of information getting submitted.
::     - `feed` is the name of the agent submitting to the graph
::
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
=/  sub-feed  (mk-subs feed ,[%feed %minaera @ @ ~])
=/  pub-feed  (mk-pubs feed ,[%feed %minaera @ @ ~]) 
::
^-  agent:gall
::
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
    da-feed  =/  da  (da feed ,[%feed %minaera @ @ ~])
                   (da sub-feed bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    du-feed  =/  du  (du feed ,[%feed %minaera @ @ ~])
                  (du pub-feed bowl -:!>(*result:du))
++  on-fail
  ~>  %bout.[0 '%minaera +on-fail']
  on-fail:def
::
++  on-leave  on-leave:def
::
++  on-arvo  on-arvo:def
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
      =^  cards  pub-feed  (give:du-feed [%feed %minaera app.act feed.act ~] [%init new-table])
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
      =^  cards  pub-feed  (give:du-feed [%feed %minaera app.act feed.act ~] [%add ~[aera-row.act]])
      [cards this]
    ::
      %del-edge
      ?.  (~(has by graph.state) [app.act feed.act])
        ~|("%minaera: initialize table for {<app.act>}, {<feed.act>} first!" !!)
      =.  graph.state
        =<  +
        %+  ~(q db:n graph.state)
          app.act
        [%delete feed.act [%s %id [%.y [%eq id.act]]]]
      =^  cards  pub-feed  (give:du-feed [%feed %minaera app.act feed.act ~] [%del id.act])
      [cards this]
    ==
    ::
      %surf-feed
    =^  cards  sub-feed
      (surf:da-feed !<(@p (slot 2 vase)) %minaera !<([%feed %minaera @ @ ~] (slot 3 vase)))
    [cards this]
    ::
      %sss-on-rock
    `this
    ::
      %sss-fake-on-rock
    :_  this
    ?-  msg=!<(from:da-feed (fled vase))
      [[%feed *] *]  (handle-fake-on-rock:da-feed msg)
    ==
    ::
      %sss-to-pub
    ?-    msg=!<(into:du-feed (fled vase))
        [[%feed %minaera *] *]
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
  ~>  %bout.[0 '%minaera +on-peek']
  on-peek:def 
::
++  on-agent
  |=  [=wire sign=sign:agent:gall]
  ^-  (quip card _this)
  ?+    -.sign  `this
      %poke-ack
    ?~  p.sign  `this
    %-  (slog u.p.sign)
    ?+    wire  `this
        [~ %sss %on-rock @ @ @ %feed %minaera @ @ ~]
      =.  sub-feed  (chit:da-feed |3:wire sign)
      ~&  >  "sub-feed is: {<read:da-feed>}"
      `this
    ::
        [~ %sss %scry-request @ @ @ %feed %minaera @ @ ~]
      =^  cards  sub-feed  (tell:da-feed |3:wire sign)
      [cards this]
    ::
        [~ %sss %scry-response @ @ @ %feed %minaera @ @ ~]
      =^  cards  pub-feed  (tell:du-feed |3:wire sign)
      ~&  >  "pub-feed is: {<read:du-feed>}"
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