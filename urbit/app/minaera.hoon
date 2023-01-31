/-  *minaera
/+  verb, dbug, default-agent
::
|%
::
+$  versioned-state  $%(state-0)
::
+$  state-0  [%0 =graph]
::
::
::  boilerplate
::
+$  card  card:agent:gall
--
::
%+  verb  &
%-  agent:dbug
=|  state-0
=*  state  -
::
^-  agent:gall
::
=<
  |_  =bowl:gall
  +*  this  .
      def  ~(. (default-agent this %|) bowl)
      eng   ~(. +> [bowl ~])
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
    ~>  %bout.[0 '%minaera +on-arvo']
    ^-  (quip card _this)
    `this
  ::
  ++  on-init
    ^-  (quip card _this)
    ~>  %bout.[0 '%minaera +on-init']
    =^  cards  state  abet:init:eng
    [cards this]
  ::
  ++  on-save
    ^-  vase
    ~>  %bout.[0 '%minaera +on-save']
    !>(state)
  ::
  ++  on-load
    |=  ole=vase
    ~>  %bout.[0 '%minaera +on-load']
    ^-  (quip card _this)
    =^  cards  state  abet:(load:eng ole)
    [cards this]
  ::
  ++  on-poke
    |=  cag=cage
    ~>  %bout.[0 '%minaera +on-poke']
    ^-  (quip card _this)
    =^  cards  state  abet:(poke:eng cag)
    [cards this]
  ::
  ++  on-peek
    |=  pat=path
    ~>  %bout.[0 '%minaera +on-peek']
    ^-  (unit (unit cage))
    (peek:eng pat)
  ::
  ++  on-agent
    |=  [wir=wire sig=sign:agent:gall]
    ~>  %bout.[0 '%minaera +on-agent']
    ^-  (quip card _this)
    =^  cards  state  abet:(dude:eng wir sig)
    [cards this]
  ::
  ++  on-watch
    |=  pat=path
    ~>  %bout.[0 '%minaera +on-watch']
    ^-  (quip card _this)
    =^  cards  state  abet:(peer:eng pat)
    [cards this]
  --
|_  [bol=bowl:gall dek=(list card)]
+*  dat  .
++  emit  |=(=card dat(dek [card dek]))
++  emil  |=(lac=(list card) dat(dek (welp lac dek)))
++  show  |=(c=cage (emit %give %fact [/web-ui]~ c))
++  send  |=(t=thumb (emit %give %fact [/take]~ thumb+!>(t)))
++  abet
  ^-  (quip card _state)
  [(flop dek) state]
::
++  init
  ^+  dat
  dat
::
++  load
  |=  vaz=vase
  ^+  dat
  ?>  ?=([%0 *] q.vaz)
  dat(state !<(state-0 vaz))
::
++  take
  |=  p=@p
  ^+  dat
  =+  wir=/take/(scot %p p)
  (emit %pass wir %agent [p %minaera] %watch /take)
::
++  drop
  |=  p=@p
  ^+  dat
  =+  wir=/take/(scot %p p)
  (emit %pass wir %agent [p %minaera] %leave ~)
::
++  peek
  |=  pol=(pole knot)
  ^-  (unit (unit cage))
  ?+  pol  !!
    [%x %graph ~]  ``minaera-state+!>(graph)
  ==
::
++  peer
  |=  pol=(pole knot)
  ^+  dat
  ?+    pol  ~|(minaera-panic-bad-watch/pol !!)
      [%web-ui ~]
    ?>  =(our.bol src.bol)
    (show minaera-state+!>(graph))
      [%take ~]
    =+  ours=`(map @p ?(%1 %0))`(~(got by graph) our.bol)
    %-  emil
    %-  ~(rep by ours)
    |=  [[k=@p v=?(%1 %0)] o=(list card)]
    ?-    v
      %0  [[%give %fact ~ thumb+!>(drop+k)] o]
      %1  [[%give %fact ~ thumb+!>(prop+k)] o]
    ==
  ==
::
++  poke
  |=  [mar=mark vaz=vase]
  ^+  dat
  ?+    mar  ~|(minaera-panic-bad-mark/mar !!)
      %thumb
    =+  tub=!<(thumb vaz)
    ?-    -.tub
        %prop
      =.  graph  (~(put bi graph) our.bol p.tub %1)
      (send:(take:(show mar vaz) p.tub) tub)
        %drop
      =.  graph  (~(put bi graph) our.bol p.tub %0)
      (send:(drop:(show mar vaz) p.tub) tub)
    ==
  ==
::
++  dude
  |=  [pol=(pole knot) sig=sign:agent:gall]
  ^+  dat
  ?+    pol  ~|(minaera-panic-strange-dude/[pol sig] !!)
      [%take who=@ ~]
    ?>  =(src.bol (slav %p who.pol))
    ?+    -.sig  ~|(minaera-panic-bad-sign/[pol sig] !!)
        %watch-ack
      %.(dat ?~(p.sig same (slog 'sad-aera' u.p.sig)))
        %kick
      (take src.bol)
        %fact
      ::  TODO: subscribe if under n-nodes of positive flow distance
      ?>  ?=(%thumb p.cage.sig)
      =+  tub=!<(thumb q.cage.sig)
      ?-    -.tub
          %prop
        %.  [%thumb-remote !>([src.bol tub])]
        show(graph (~(put bi graph) src.bol p.tub %1))
          %drop
        %.  [%thumb-remote !>([src.bol tub])]
        show(graph (~(put bi graph) src.bol p.tub %0))
      ==
    ==
  ==
--