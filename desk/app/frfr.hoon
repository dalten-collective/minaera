::
::  %bussin %frfr
::
::  
::  Reputation SERVICE: Derives reputation score from %beer and %alfie data
::  
::  Description of Score:
:: 
::  The score is: confidence*sum(feels)
::  
::  The confidence comes from %beer while the sum of feels is the positive
::  reacts minus the number of negative reacts collected by %alfie.
::
::  The confidence is set to 1 if the %beer score is %1. It is 1/2 if 
::  the beer score is %0 or neither you nor your neighbors have a score 
::  for a given ship.
::
::  If there is a first hand opinion of the person, then my personal %beer score will
::  be used to calculate the confidence. If I don't have a first hand opinion, then I will 
::  poll my trusted peers and if at least one of them has a score of %1 for the target ship,
::  the confidence will be 1.
::
::  .^((set @p) %gx /(scot %p our)/pals/(scot %da now)/mutuals/noun)
::
/-  *minaera, feed, service
/+  verb, dbug, default-agent, *sss, n=nectar
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0  [%0 neighbors=(set @p) scores=(map @p @rs)]
::
+$  frfr-action
  $%  [%compute =ship]
      [%add-edge =ship]
      [%del-edge =ship]
      [%placeholder ~]
  ==
::
::
::  boilerplate
::
+$  card  card:agent:gall
++  info-card
=/  desc=@t
'''
The score is: confidence*sum(feels)

The confidence comes from %beer while the sum of feels is the positive
reacts minus the number of negative reacts collected by %alfie.

The confidence is set to 1 if the %beer score is %1. It is 1/2 if 
the beer score is %0 or neither you nor your neighbors have a score 
for a given ship.

If there is a first hand opinion of the person, then my personal %beer score will
be used to calculate the confidence. If I don't have a first hand opinion, then I will 
poll my trusted peers and if at least one of them has a score of %1 for the target ship,
the confidence will be 1.
'''
:*  desc=desc
    type=%continuous
    aura=%rs
    min=%ninf
    max=%inf
==
--
=/  sub-feed  (mk-subs feed ,[%feed %minaera @ @ ~])
=/  sub-service  (mk-subs service ,[%service *])
=/  pub-service  (mk-pubs service ,[%service *])
::
%+  verb  &
%-  agent:dbug
=|  state=state-0
::
^-  agent:gall
::
=<
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
    hc  ~(. +> bowl)
    da-feed  =/  da  (da feed ,[%feed %minaera @ @ ~])
                   (da sub-feed bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    da-service  =/  da  (da service ,[%service *])
                   (da sub-service bowl -:!>(*result:da) -:!>(*from:da) -:!>(*fail:da))
    du-service  =/  du  (du service ,[%service *])
                   (du pub-service bowl -:!>(*result:du))
++  on-fail
  ~>  %bout.[0 '%frfr +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%frfr +on-leave']
  on-leave:def
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%frfr +on-init']
  =.  neighbors.state  .^((set @p) %gx /(scot %p our.bowl)/pals/(scot %da now.bowl)/mutuals/noun)
  :_  this
  ^-  (list card)
  %-  zing
  %+  turn
    ~(tap in neighbors.state)
  |=  a=@p
  :~  :*  %pass  /service/beer
          %agent  [our.bowl %frfr]
          %poke  %surf-service  !>([our.bowl [%service %beer ~]])
      ==  
      :*  %pass  /feed/minaera/groups/alfie
          %agent  [our.bowl %frfr]
          %poke  %surf-feed  !>([our.bowl [%feed %minaera %groups %alfie ~]])
      ==
  ==
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%frfr +on-save']
  !>([state sub-feed sub-service pub-service])
::
++  on-load
  |=  =vase
  ~>  %bout.[0 '%frfr +on-load']
  ^-  (quip card _this)
  =/  old  !<([state-0 =_sub-feed =_sub-service =_pub-service] vase)
  :-  ~
  %=    this
    state     -.old
    sub-feed  sub-feed.old
    sub-service  sub-service.old
    pub-service  pub-service.old
  ==
::
++  on-poke
  |=  [=mark =vase]
  ~>  %bout.[0 '%frfr +on-poke']
  ^-  (quip card _this)
  ?+    mark  !!
    ::
      %frfr-action
    =/  act  !<(frfr-action vase)
    ?+    -.act  !!
        %compute
      =/  confidence  (compute-weight:hc ship.act neighbors.state)
      =/  sum=(unit @rs)  (get-sum our.bowl ship.act)
      ?~  sum
        `this
      `this(scores.state (~(put by scores.state) ship.act (mul:rs confidence (need sum))))
    ::
        %add-edge
      `this(neighbors.state (~(put in neighbors.state) ship.act))
    ::
        %del-edge
      `this(neighbors.state (~(del in neighbors.state) ship.act))
    ==
    ::
      %surf-feed
    =^  cards  sub-feed
      (surf:da-feed !<(@p (slot 2 vase)) %minaera !<([%feed %minaera @ @ ~] (slot 3 vase)))
    [cards this]
  ::
      %surf-service
    =^  cards  sub-service
      (surf:da-service !<(@p (slot 2 vase)) %beer !<([%service %beer ~] (slot 3 vase)))
    ~&  >  "sub-service is: {<read:da-service>}"
    [cards this]
  ::
      %sss-feed
    =/  res  !<(into:da-feed (fled vase))
    =^  cards  sub-feed  (apply:da-feed res)
    [cards this]
  ::
      %sss-service
    =/  res  !<(into:da-service (fled vase))
    ~&  >  sss-service+res
    =^  cards  sub-service  (apply:da-service res)
    [cards this]
  ::
      %sss-on-rock
    ?-  msg=!<($%(from:da-feed from:da-service) (fled vase))
        [[%feed %minaera *] *]  `this
        [[%service *] *]  `this
    ==
  ::
      %sss-fake-on-rock
    :_  this
    ?-  msg=!<($%(from:da-feed from:da-service) (fled vase))
      [[%feed %minaera *] *]  (handle-fake-on-rock:da-feed msg)
      [[%service *] *]  (handle-fake-on-rock:da-service msg)
    ==
  ==
::
++  on-peek
  |=  =path
  ~>  %bout.[0 '%frfr +on-peek']
  ^-  (unit (unit cage))
  ?+    path  `~
      [%x %score @ ~]
    =/  =ship  (slav %p -.+.+.path)
    `~
  ::
      [%x %card ~]
    ``[%noun !>(info-card)]
  ==
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ~>  %bout.[0 '%frfr +on-agent']
  ^-  (quip card _this)
  ?.  =(%poke-ack -.sign)
    ~&  >  beer+'bad poke'  `this
  ?+    wire  `this
      [~ %sss %on-rock @ @ @ %feed %minaera @ @ ~]
    =.  sub-feed  (chit:da-feed |3:wire sign)
    :: ~&  >  "sub-feed is: {<read:da-feed>}"
    `this
  ::
      [~ %sss %on-rock @ @ @ %service *]
    =.  sub-service  (chit:da-service |3:wire sign)
    :: ~&  >  "sub-feed is: {<read:da-feed>}"
    `this
  ::
      [~ %sss %scry-request @ @ @ %feed %minaera @ @ ~]
    =^  cards  sub-feed  (tell:da-feed |3:wire sign)
    [cards this]
  ::
      [~ %sss %scry-request @ @ @ %service *]
    =^  cards  sub-service  (tell:da-service |3:wire sign)
    [cards this]
::
      [~ %sss %scry-response @ @ @ %service *]
    =^  cards  pub-service  (tell:du-service |3:wire sign)
    ::  ~&  >  "pub-service is: {<read:du-service>}"
    [cards this]
  ==
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%frfr +on-watch']
  ^-  (quip card _this)
  `this
--
|_  =bowl:gall
++  compute-weight
  |=  [ship=@p neighbors=(set @p)]
  ^-  @rs
  ::  Try grabbing local weight first
  ::
  =/  local-weight  (get-weights our.bowl ship)
  ?^  local-weight
    (need local-weight)
  ::  If local-weight is ~, ask your peers
  ::
  =/  max
    =<  -
    %+  sort
      %+  turn
        ~(tap in neighbors)
      |=  e=@p
      =+  (get-weights e ship)
      ?~  -
        ~
      (need -)
    gth
  ?~(max .0.5 max)
::
++  get-weights
  |=  [host=ship target=ship]
  ^-  (unit @rs)
  =+  (grab-scores-beer host)
  ?~  -
    ~
  =/  scores  (need -) 
  ?.  (~(has by scores) target)
    ~
  ?:  =(%0 (~(got by scores) target))
    `.0.5
  `.1
::
++  grab-scores-beer
  |=  =ship
  ^-  (unit (map @p @))
  =/  local-map  (~(get by +.sub-service) [ship %beer [%service %beer ~]]) 
  ?~  local-map
    ~|('%frfr: subscription to %beer has not been initialized yet' ~) 
  =/  flow=(unit [aeon=@ stale=_| fail=_| =rock:service])  (need local-map)
  ?~  flow
    ~
  `rock:(need flow) 
::
++  grab-table-alfie
  |=  =ship
  =/  local-map  (~(get by +.sub-feed) [ship %minaera [%feed %minaera %groups %alfie ~]]) 
  ?~  local-map
    ~|('%frfr: %alfie has not been initialized yet' ~) 
  =/  flow=(unit [aeon=@ stale=_| fail=_| =rock:feed])  (need local-map)
  ?~  flow
    ~
  `rock:(need flow) 
::
++  get-sum
  |=  [host=ship target=ship]
  ^-  (unit @rs)
  =+  (grab-table-alfie host)
  ?~  -
    ~
  =/  =table:n  (need -) 
  =/  negs  (~(get-rows tab:n (~(select tab:n table) ~ [%s %tag [%.y [%eq %negative-react]]])) ~)
  =/  pozz  (~(get-rows tab:n (~(select tab:n table) ~ [%s %tag [%.y [%eq %positive-react]]])) ~)
  `(add:rs (mul:rs .-1.0 (sun:rs (lent negs))) (sun:rs (lent pozz)))
--