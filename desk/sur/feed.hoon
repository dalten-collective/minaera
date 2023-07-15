/-  m=minaera
/+  n=nectar
=>
|%
+$  feed-action  
  $%  [%init =table:n] 
      [%add aera-rows=(list aera-row:m)]
      [%del id=@]
  ==
--
|%
++  name  %feed
+$  rock  table:n
+$  wave  feed-action
++  wash
  |=  [=rock =wave]
  ^-  table:n
  ?-    -.wave
      %init
     (~(create tab:n table.wave) ~)
  ::
      %add
    =/  r  `(list row:n)`(turn aera-rows.wave |=(i=* !<(row:n [-:!>(*row:n) i])))
    (~(insert tab:n rock) r update=%.n)
  ::
      %del
    =/  where=condition:n  [%s %id [%.y [%eq id.wave]]]
    (~(delete tab:n rock) primary-key.rock where)
  ==
--