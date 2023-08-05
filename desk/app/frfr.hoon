::
::  %bussin %frfr
::
::  
::  Reputation SERVICE: Derives reputation score from %beer and %alfie data
::  
::  Description of Score:
:: 
::  The score is: confidence(%beer)*(sum_me(feels)+0.5*sum_peers(feels))
::  
::  The confidence comes from %beer while the sum of feels consists of:
::  the positive reacts minus the number of negative reacts collected 
::  by %alfie. 
::
::  If there is a first hand opinion of the person, if it is %1, then
::  the confidence is 1. Likewise if it is %0, then the confidence
::  is 0.
::
::  If I don't have a first hand opinion, then I will poll my trusted 
::  peers and take the max of their score. 
::
::  If none of my peers has a first hand opinion of the ship, the confidence 
::  will be 3/4 to represent uncertainty.
::
::  If none of my peers attests that the ship is real (%1) and at least one of 
::  my peers attests that the ship is definitely fake (%0) the confidence goes to 0. 
::
::  .^((set @p) %gx /(scot %p our)/pals/(scot %da now)/mutuals/noun)
::
/-  *minaera, feed, service
/+  verb, dbug, default-agent, *sss, n=nectar, *mip
|%
::
+$  versioned-state  $%(state-0)
::
+$  score
  $:  score=@rs 
      beer=[from=(unit @p) weight=@rs]
      alfie=(map @p [pos=@ud neg=@ud])
  ==
::
+$  state-0
  $:  %0
      neighbors=(set @p)
      scores=(mip @p @ score)
  ==
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
The score is: confidence(%beer)*(sum_me(feels)+0.5*sum_peers(feels))

The confidence comes from %beer while the sum of feels consists of:
the positive reacts minus the number of negative reacts collected 
by %alfie. 

If there is a first hand opinion of the person, if it is %1, then
the confidence is 1. Likewise if it is %0, then the confidence
is 0.

If I don't have a first hand opinion, then I will poll my trusted 
peers and take the max of their score. 

If none of my peers has a first hand opinion of the ship, the confidence 
will be 3/4 to represent uncertainty.

If none of my peers attests that the ship is real (%1) and at least one of 
my peers attests that the ship is definitely fake (%0) the confidence goes to 0.
'''
:*  desc=desc
    type=%continuous
    aura=%rs
    min=%ninf
    max=%inf
==
::
++  pass-surf
  |=  [me=@p ship=@p]
  ^-  (list card)
  :~  :*  %pass  /service/beer
          %agent  [me %frfr]
          %poke  %surf-service  !>([ship [%service %beer ~]])
      ==
  ::
      :*  %pass  /feed/minaera/groups/alfie
          %agent  [me %frfr]
          %poke  %surf-feed  !>([ship [%feed %minaera %groups %alfie ~]])
      ==
  ==
::
++  quit-surf
  |=  [me=@p ship=@p]
  ^-  (list card)
  :~  :*  %pass  /service/beer
          %agent  [me %frfr]
          %poke  %quit-service  !>([ship [%service %beer ~]])
      ==
  ::
      :*  %pass  /feed/minaera/groups/alfie
          %agent  [me %frfr]
          %poke  %quit-feed  !>([ship [%feed %minaera %groups %alfie ~]])
      ==
  ==
::
++  unique-time
  |=  [=time =ship m=(mip @p @ score)]
  ^-  @
  =/  unix-ms=@
    (unm:chrono:userlib time)
  |-
  ?.  (~(has bi m) ship unix-ms)
    unix-ms
  $(time (add unix-ms 1))
::
++  hash-score
  |=  [=score]
  ^-  @uv
  %-  shax
  %+  add
    ;:  (cury cat 3)
        ?~(from.beer.score ~ (need from.beer.score))
        weight.beer.score
    ==
  %+  roll
    %+  turn
      ~(tap by alfie.score)
    |=  [b=@p c=@ud d=@ud]
    ;:((cury cat 3) b c d)
  add
--
::
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
  =.  neighbors.state  ?.  .^(? %gu /=pals=/$)
                         *(set @p)
                       .^((set @p) %gx /=pals=/mutuals/noun)
  :_  this
  ^-  (list card)
  %-  zing
  %+  turn
    (snoc ~(tap in neighbors.state) our.bowl)
  |=  a=@p
  (pass-surf our.bowl a)
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
      =/  confidence=(unit [from=@p weight=@rs])
        (compute-weight:hc ship.act neighbors.state)
      =/  sum  (get-sum-neighbors:hc ship.act neighbors.state)
      ?~  sum
        ~|('%frfr: No information on {<ship.act>} available in your graph' `this)
      =/  con=[from=(unit @p) weight=@rs]
        ?~  confidence 
          [~ .0.75]
        [`from weight]:(need confidence) 
      :-  ~
      %=    this
          scores.state
        %^    ~(put bi scores.state)
            ship.act 
          (unique-time now.bowl ship.act scores.state)  
        :+  (mul:rs weight.con (calc-sum:hc (need sum)))
          con
        (need sum)
      ==
    ::
        %add-edge
      :-  (pass-surf our.bowl ship.act)
      this(neighbors.state (~(put in neighbors.state) ship.act))
    ::
        %del-edge
      :-  (quit-surf our.bowl ship.act)
      this(neighbors.state (~(del in neighbors.state) ship.act))
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
      %quit-feed
    =.  sub-feed
      (quit:da-feed !<(@p (slot 2 vase)) %minaera !<([%feed %minaera @ @ ~] (slot 3 vase)))
    `this
  ::
      %quit-service
    =.  sub-service
      (quit:da-service !<(@p (slot 2 vase)) %beer !<([%service %beer ~] (slot 3 vase)))
    `this
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
    ``[%noun !>((get-latest ship scores.state))]
  ::
      [%x %scores @ ~]
    =/  =ship  (slav %p -.+.+.path)
    ?.  (~(has by scores.state) ship)
      ``[%noun !>(~)]
    ``[%noun !>(~(tap by (~(got by scores.state) ship)))]
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
  ^-  (unit [from=@p weight=@rs])
  ::  Try grabbing local weight first
  ::
  =/  local-weight  (get-weights our.bowl ship)
  ::  If local-weight is empty, ask your peers
  ::
  ?^  local-weight
    local-weight
  =/  b=(list [@p @rs])
    %+  sort
      ^-  (list [@p @rs])
      %-  neede
      %+  turn
        ~(tap in neighbors)
      |=  e=@p
      (get-weights e ship)
    |=  [a=[* weight=@rs] b=[* weight=@rs]]
    (gth weight.a weight.b)
  ?~(b ~ `i.b)
::
++  neede
  |*  a=(list (unit))
  |-
  ?~  a  ~
  ?:(!=(~ i.a) [(need i.a) $(a t.a)] $(a t.a))
::
++  get-weights
  |=  [host=ship target=ship]
  ^-  (unit [@p @rs])
  =+  (grab-scores-beer host)
  ?~  -
    ~
  =/  scores  (need -) 
  ?.  (~(has by scores) target)
    ~
  ?:  =(%0 (~(got by scores) target))
    `[host .0]
  `[host .1]
::
++  grab-scores-beer
  |=  =ship
  ^-  (unit (map @p @rs))
  =/  local-map  (~(get by +.sub-service) [ship %beer [%service %beer ~]]) 
  ?~  local-map
    ~|('%frfr: subscription to %beer has not been initialized yet' ~) 
  =/  flow=(unit [aeon=@ stale=_| fail=_| =rock:service])  (need local-map)
  ?~  flow
    ~
  `rock:(need flow) 
::
++  get-sum-neighbors
  |=  [target=ship neighbors=(set @p)]
  ^-  (unit map=(map @p [pozz=@ud negs=@ud]))
  =/  tables=(list [@p table:n])
    %-  neede
    %+  turn
      (snoc ~(tap in neighbors) our.bowl)
    |=  a=@p
    =+  (grab-table-alfie a)
    ?~  -
      ~
    `[a (need -)]
  =/  counts=(map @p [pozz=@ud negs=@ud])
  =<  +
  %^    spin
      tables
    *(map @p [pozz=@ud negs=@ud])
  |=  [a=[ship=@p =table:n] counts=(map @p [pozz=@ud negs=@ud])]
  =/  pozz  
    %-  lent
    (~(get-rows tab:n (~(select tab:n table.a) ~ (pos-cond target))) ~)
  =/  negs
    %-  lent
    (~(get-rows tab:n (~(select tab:n table.a) ~ (neg-cond target))) ~)
  [a (~(put by counts) ship.a [pozz=pozz negs=negs])]
 ::
  ?~  counts
    ~
  `counts
::
++  grab-table-alfie
  |=  =ship
  ^-  (unit table:n)
  =/  local-map  
    %-  ~(get by +.sub-feed)
    [ship %minaera [%feed %minaera %groups %alfie ~]]
  ?~  local-map
    ~|('%frfr: %alfie has not been initialized yet' ~) 
  =/  flow=(unit [aeon=@ stale=_| fail=_| =rock:feed])  (need local-map)
  ?~  flow
    ~
  `rock:(need flow)
::
++  calc-sum
  |=  counts=(map @p [@ud @ud])
  ^-  @rs
  %+  roll
    %+  turn
      ~(tap by counts)
    |=  [=ship [pos=@ud neg=@ud]]
    %+  mul:rs
      ?:(=(our.bowl ship) .1 .0.5)
    %+  add:rs 
      (mul:rs .-1.0 (sun:rs neg))
    (sun:rs pos)
  add:rs
::
++  pos-reacts  (silt `(list knot)`~[':+1:' ':heart:' ':heart_eyes:' ':clap:' ':100:' ':tada:'])
::
++  neg-reacts  (silt `(list knot)`~[':-1:'])
::
++  neg-cond
|=  target=ship
^-  condition:n
:*  %and
    [%s %tag [%& %eq %react]]
    :+  %and
      [%s %to [%& %eq target]] 
    :*  %s 
        %what 
        :-  %|
        |=  a=value:n 
        ?<  |(?=((unit @) a) ?=(^ a))
        (~(has in neg-reacts) a)
    ==
==
::
++  pos-cond
|=  target=ship
^-  condition:n
:*  %and
    [%s %tag [%& %eq %react]]
    :+  %and
      [%s %to [%& %eq target]] 
    :*  %s 
        %what 
        :-  %|
        |=  a=value:n 
        ?<  |(?=((unit @) a) ?=(^ a))
        (~(has in pos-reacts) a)
    ==
==
::
++  get-latest
|=  [ship=@p m=(mip @p @ score)]
^-  (unit score)
?.  (~(has by m) ship)
  ~
=;  latest=score
  `latest
=<  +.-
  %+  sort
    ~(tap by (~(got by scores.state) ship))
  |=  [a=[@ score] b=[@ score]]
  (lth -.a -.b)
--