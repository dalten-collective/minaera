::
::  %bussin %frfr
::
::  
::  Reputation SERVICE: Derives reputation score from %beer and %alfie data
::  
::  Description of Score:
:: 
::  The score will be: multiplier*sum(feels)
::  
::  The multiplier comes from %beer while the sum of feels comes from %alfie.
::
::  If your confidence that a person is real is greater than or equal to "second-hand",
::  the result is a multiplier of 1. 
::
::  If your confidence is less than "second-hand", then the multiplier is 1 if the sum of the feels derived by %alfie are 
::  positive, otherwise 1/2 if the sum is negative.
::
::  We will get confidence as follows:
:: 
::  If there is a first hand opinion of the person, then my personal %beer score will
::  be used as the confidence.
::
::  If I don't have a first hand opinion, then I will poll my trusted peers 
::  and optimistically take the max of their opinions as my confidence.
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
::
::  boilerplate
::
+$  card  card:agent:gall
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
|_  =bowl:gall
+*  this  .
    def  ~(. (default-agent this %|) bowl)
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
  ::  receive requests for scores (batches) - this is the protocolized version
  ~
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
    ~&  >  "sub-feed is: {<read:da-feed>}"
    `this
  ::
      [~ %sss %on-rock @ @ @ %service *]
    =.  sub-service  (chit:da-service |3:wire sign)
    ~&  >  "sub-feed is: {<read:da-feed>}"
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
    ~&  >  "pub-service is: {<read:du-service>}"
    [cards this]
  ==
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%frfr +on-watch']
  ^-  (quip card _this)
  `this
--