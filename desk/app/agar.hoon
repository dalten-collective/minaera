::
::  A groups aggregator, rad!
::
::  Accepts requests for a user's local and peer graphs
::  Interprets stored events and translates them into a score over edges
::
/-  *minaera
/+  verb, dbug, default-agent
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0  %0
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
  ~>  %bout.[0 '%agar +on-fail']
  on-fail:def
::
++  on-leave
  ~>  %bout.[0 '%agar +on-leave']
  on-leave:def
::
++  on-arvo
  |=  [=wire sign=sign-arvo]
  ^-  (quip card _this)
  `this
::
++  on-init
  ^-  (quip card _this)
  ~>  %bout.[0 '%agar +on-init']
  `this
::
++  on-save
  ^-  vase
  ~>  %bout.[0 '%agar +on-save']
  !>(state)
::
++  on-load
  |=  old=vase
  ~>  %bout.[0 '%agar +on-load']
  ^-  (quip card _this)
  =.  state  !<  state-0  old
  `this
::
++  on-poke
  |=  =cage
  ~>  %bout.[0 '%agar +on-poke']
  ^-  (quip card _this)
  `this
::
++  on-peek
  |=  =path
  ~>  %bout.[0 '%agar +on-peek']
  ^-  (unit (unit cage))
  ~
::
++  on-agent
  |=  [=wire =sign:agent:gall]
  ~>  %bout.[0 '%agar +on-agent']
  ^-  (quip card _this)
  `this
::
++  on-watch
  |=  =path
  ~>  %bout.[0 '%agar +on-watch']
  ^-  (quip card _this)
  `this
--