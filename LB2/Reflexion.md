# Reflexion der LB2

## Lerneffekt
Dieses Modul ist ein sehr spannendes Modul. Automatisierung und scripten war schon immer etwas was mir gefallen hat. Ich konnte so einiges lernen in der LB2. Github wollte ich schon immer verstehen und durch dieses Modul begreife ich es. Es ist eine sehr gute Seite für Entwickler meiner Meinung nach. Auch konnte ich meine Kenntnisse im scripten wieder auffrischen und ich habe Vagrant kennengelernt. Vagrant ist noch recht logisch, denn jeder Befehl sagt was er macht. ```db.vm.network "private_network", ip: "10.0.0.11"``` sagt, dass bei der VM mit dem Namen "DB" etwas am Netzwerk verändert werden soll. In diesem Fall soll ein "Private Network" erstellt werden mit der fixen IP "10.0.0.11".

## Was hat gut funktioniert?
Ich konnte sehr schnell eine Idee finden für die LB und diese zum grössten Teil auch verwirklichen. Für zukünftige Zwecke kann ich meine LB2 behalten falls ich jemals eine Seite per WordPress erstellen muss.

## Was hat nicht so gut funktioniert?
Am Anfang war es mühsam, da ich alles in einem Vagrant File erstellt hatte. Also musste ich dann relativ viel Zeit in Anspruch nehmen, um es in mehrere Files zu splitten. Auch hat die Idee mit dem DHCP-Server leider nicht geklappt, da ich es nicht geschafft habe, dass der Client per DHCP die IP vom DHCP-Server kriegt. Er hat immer versucht die vom Host-Only Netzwerk von Virtualbox zu nehmen.

## Zusammengefasst
Die LB2 hat mir viel Spass bereitet und ich würde diese zukünftig nochmal machen. Ich habe zwar relativ viel Zeit in Anspruch genommen (+20 Stunden), dafür ist mein Endprodukt aber etwas worauf ich stolz sein kann. Mir ist bewusst, dass ich mehr gemacht habe als verlangt, aber da es mir so viel Spass bereitet hat, war die investierte Zeit definitv wert.