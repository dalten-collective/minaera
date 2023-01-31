/-  m=minaera
/+  *mip
|%
++  enjs
  =,  enjs:format
  |%
  ++  ship  (corl (lead %s) (cury scot %p))
  ++  pack
    |=  [typ=@t faz=@t pay=json]
    (pairs type+s/typ face+s/faz fact+pay ~)
  ++  graph
    |=  g=graph:m
    %^  pack  'FACT'
      'MINAERA-GRAPH-STATE'
    =-  (frond graph+a/-)
    %-  ~(rep by g)
    |=  [[k=@p v=(map @p ?(%1 %0))] o=(list json)]
    :_  o
    %-  pairs
    :~  host+(ship k)
      ::
        :+  %reputation  %a
        %-  ~(rep by v)
        |=  [[k=@p v=?(%1 %0)] o=(list json)]
        ?-  v
          %1  [(pairs ship+(ship k) thumb+s/'UP' ~) o]
          %0  [(pairs ship+(ship k) thumb+s/'DOWN' ~) o]
        ==
    ==
  ++  thumb
    |=  t=thumb:m
    ?-    -.t
        %prop
      %^  pack  'FACT'
        'THUMB-LOCAL'
      (pairs ship+(ship p.t) thumb+s/'UP' ~)
    ::
        %drop
      %^  pack  'FACT'
        'THUMB-LOCAL'
      (pairs ship+(ship p.t) thumb+s/'DOWN' ~)
    ==
  ++  thumb-remote
    |=  [p=@p t=thumb:m]
    ?-    -.t
        %prop
      %^  pack  'FACT'
        'THUMB-REMOTE'
      (pairs host+(ship p) ship+(ship p.t) thumb+s/'UP' ~)
    ::
        %drop
      %^  pack  'FACT'
        'THUMB-REMOTE'
      (pairs host+(ship p) ship+(ship p.t) thumb+s/'DOWN' ~)
    ==
  --
++  dejs
  =,  dejs:format
  |%
  ++  ship  ;~(pfix sig fed:ag)
  ++  thumb
    ^-  $-(json thumb:m)
    (of prop+(su ship) drop+(su ship) ~)
  --
--