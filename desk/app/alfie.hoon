::
::  A local feed ingestion engine
::
::  Ingests local groups events, sanitizes them, and submits them to %minaera graph
::
::
::  +on-agent arm listens for reacts to posts
::
/-  *minaera, chat
/+  verb, dbug, default-agent
|%
::
++  event-version  0
::
+$  versioned-state  $%(state-0)
::
+$  state-0  %0
::
++  chat-subscribe-card
  |=  =ship
  [%pass /chat/updates %agent [ship %chat] %watch /ui]
::
::
++  minaera-init-card
|=  =ship
[%pass /minaera/action %agent [ship %minaera] %poke %aera-action !>([%init-table %groups %alfie])]
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
  ~>  %bout.[0 '%alfie +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%alfie +on-leave']
  on-leave:def
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%alfie +on-init']
  :_  this
  ~[(chat-subscribe-card our.bowl) (minaera-init-card our.bowl)]
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%alfie +on-save']
  !>(state)
::
++  on-load
  |=  old=vase
  ~>  %bout.[0 '%alfie +on-load']
  ^-  (quip card _this)
  =.  state  !<  state-0  old
  `this
::
++  on-poke
  |=  =cage
  ~>  %bout.[0 '%alfie +on-poke']
  ^-  (quip card _this)
  `this
::
++  on-peek
  |=  =path
  ~>  %bout.[0 '%alfie +on-peek']
  ^-  (unit (unit cage))
  ~
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ~>  %bout.[0 '%alfie +on-agent']
  ^-  (quip card _this)
  ?+  wire  (on-agent:def wire sign)
      [%chat %updates ~]
    ?+    -.sign  (on-agent:def wire sign)
      %watch-ack  `this
        %kick
      :_  this
      ~[(chat-subscribe-card our.bowl)]
    ::
        %fact
      ?+    p.cage.sign  `this
          %chat-action-0
        =/  =action:chat  !<(action:chat q.cage.sign)
        ?>  ?=([%writs *] q.q.action)
        =/  target=[to=@p post=@da]  p.p.q.q.action
        =/  =delta:writs:chat  q.p.q.q.action
        ~&  >  target
        ~&  >  delta
        ?:  =(our.bowl to.target)
          `this
        ::
        ::  If we aren't the one sending the react, ignore.
        ?+    delta  !!
            [%add-feel *]
          :_  this
          ?:  !=(our.bowl p.delta)
            ~
          =-  :~  :*  %pass  /minaera/action  %agent
                      [our.bowl %minaera]  %poke
                      %aera-action  !>([%add-edge %groups dap.bowl ar])
              ==  ==
          ^=  ar
          ^-  aera-row
          :*  id=`@`post.target 
              timestamp=p.q.action
              from=our.bowl
              to=to.target 
              what=q.delta 
              tag=%react
              description='Emoji react from %talk'
              app-tag=%chat-action-0
              event-version=%0
              ~
          ==
          ::
            [%del-feel *]
          :_  this
          ?:  !=(our.bowl p.delta)
            ~
          :~  :*  %pass  /minaera/action
                  %agent  [our.bowl %minaera]
                  %poke  %aera-action  !>(`aera-action`[%del-edge %groups dap.bowl post.target])
          ==  ==
        ==
      ==
    ==
  ==
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%alfie +on-watch']
  ^-  (quip card _this)
  `this
--