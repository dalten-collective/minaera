::  QL: Quorum Listener
/-  *minaera, feed, service, boards
/+  verb, dbug, default-agent, *sss, n=nectar, q=quorum
|%
::
+$  versioned-state  $%(state-0)
::
+$  edge  [from=@p to=@p dir=@ta]
+$  state-0  [%0 seen=(map @uw edge)]
::
+$  card  card:agent:gall
::
::
::  boilerplate
::
--
=/  pub-feed  (mk-pubs feed ,[%feed %minaera @ @ ~])
=/  sub-boards  (mk-subs boards ,[%quorum %updates @ @ ~])
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
    du-feed  =/  du  (du feed ,[%feed %minaera @ @ ~])
                   (du pub-feed bowl -:!>(*result:du))
    da-boards  =/  da  (da boards ,[%quorum %updates @ @ ~])
                   (da sub-boards bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
++  on-fail
  ~>  %bout.[0 '%ql +on-fail']
  on-fail:def
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-leave
  ~>  %bout.[0 '%ql +on-leave']
  |=  =path
  `this
::
++  on-init
  ~>  %bout.[0 '%ql +on-init']
  on-init:def
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%ql +on-save']
  !>([state pub-feed sub-boards])
::
++  on-load
  |=  =vase
  ~>  %bout.[0 '%ql +on-load']
  ^-  (quip card _this)
  =/  old  !<([state-0 =_pub-feed =_sub-boards] vase)
  :-  ~
  %=    this
    state     -.old
    pub-feed  pub-feed.old
    sub-boards  sub-boards.old
  ==
::
++  on-poke
  |=  [=mark =vase]
  ~>  %bout.[0 '%ql +on-poke']
  ^-  (quip card _this)
  ?+    mark  !!
      %surf-boards
    =^  cards  sub-boards
      (surf:da-boards !<(@p (slot 2 vase)) %quorum !<([%quorum %updates @ @ ~] (slot 3 vase)))
    [cards this]
    ::
      %sss-boards
    =/  res  !<(into:da-boards (fled vase))
    =^  cards  sub-boards  (apply:da-boards res)
    ~&  >  res
    ?+    what.res  [cards this]
         %wave
      =/  wav=wave:boards  wave.res
      =/  act  q.act.wav
      =/  pat=[@p term]  p.act.wav
      =/  bo=bowl:gall  bowl.wav  
      ~&  >  act
      ?+    -.act  [cards this]
          %vote
        =/  hash=@uw  (shax (cat 3 (cat 3 (cat 3 +.pat -.pat) post-id.act) src.bo))
        =/  edge=(unit edge)  (~(get by seen.state) hash)
        ~&  >  act
        =/  m  (~(get by +.sub-boards) [src.bo %quorum [%quorum %updates -.pat +.pat ~]])
        =/  flow=(unit [aeon=@ stale=_| fail=_| =rock:boards])  (need m)
        ?~  flow  [cards this]
        =/  to=@p  
          =/  board=rock:boards  rock:(need flow)
          =+  =<  -
          (~(q db database.board) %quorum [%select %posts [%s %post-id [%& %eq post-id.act]]])
          %-  author:poast:q
          ^-  post:q
          %+  snag  0
          `(list post:q)`(turn - |=(i=* !<(post:q [-:!>(*post:q) i]))) 
        ?~  edge
          [cards this(seen.state (~(put by seen.state) hash [src.bo to dir.act]))]
        ?:  =(dir:(need edge) dir.act)
          [cards this(seen.state (~(del by seen.state) hash))]
        [cards this(seen.state (~(put by seen.state) hash [src.bo to dir:(need edge)]))]
      ==
    ==
  ::
      %sss-to-pub
    ?-    msg=!<(into:du-feed (fled vase))
        [[%feed %minaera *] *]
      =^  cards  pub-feed  (apply:du-feed msg)
      [cards this]
    == 
  ::
      %sss-on-rock
    ?-  msg=!<(from:da-boards (fled vase))
        [[%quorum %updates *] *]  `this
    ==
  ::
      %sss-fake-on-rock
    :_  this
    ?-  msg=!<(from:da-boards (fled vase))
      [[%quorum %updates *] *]  (handle-fake-on-rock:da-boards msg)
    ==
  ==
::
++  on-peek
  ~>  %bout.[0 '%ql +on-peek']
  on-peek:def
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ~>  %bout.[0 '%ql +on-agent']
  ^-  (quip card _this)
  ?.  =(%poke-ack -.sign)
    ~&  >  beer+'bad poke'  `this
  ?+    wire  `this
  ::
      [~ %sss %on-rock @ @ @ %quorum %updates @ @ ~]
    =.  sub-boards  (chit:da-boards |3:wire sign)
    :: ~&  >  "sub-boards is: {<read:da-boards>}"
    `this
  ::
      [~ %sss %scry-request @ @ @ %quorum %updates @ @ ~]
    =^  cards  sub-boards  (tell:da-boards |3:wire sign)
    ~&  >  "sub-boards is: {<read:da-boards>}"
    [cards this]
  ::
      [~ %sss %scry-response @ @ @ %feed %minaera @ @ ~]
    =^  cards  pub-feed  (tell:du-feed |3:wire sign)
    ::  ~&  >  "pub-feed is: {<read:du-feed>}"
    [cards this]
  ::
  ==
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%ql +on-watch']
  ^-  (quip card _this)
  `this
--