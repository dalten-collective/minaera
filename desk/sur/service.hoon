/-  m=minaera
|%
++  name  %service
+$  rock  (map @p @)
+$  wave  
  $%  [%add =ship val=@]
      [%del =ship]
  ==
++  wash
  |=  [=rock =wave]
  ?-    -.wave 
      %add
    (~(put by rock) ship.wave val.wave)
  ::
      %del
    (~(del by rock) ship.wave)
  ==
--