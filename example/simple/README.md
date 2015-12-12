simple log output

`./app --log=warn`

for split logging into different files by emitter

`./app --log=info --log-file=p1:pack1log.txt --log-file=p2.pack2log.txt --log-output=p1:pack1:trace --log-output=p2:pack2:debug --log-output-only-reg=p1:true --log-output-only-reg=p2:true`

read log settings from file

`./app --log-settings=settings`
