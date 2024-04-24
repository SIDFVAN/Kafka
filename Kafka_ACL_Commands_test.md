# Test Kafka

## Test ACLs voor Kafka --> rechten

### Scenario's

User:admin mag read/write alles

admin maakt aan
ACL voor usera met enkel alle rechten op usera prefix
ACL voor userb met enkel alle rechten op userb prefix
Maakt topic admin aan 

Usera: 
Mag enkel op usera* topics iets doen
Mag enkel oplijsten in usera topic
Mag enkel publishen in usera topic
Suscribe ?

Maak topic test aan --> FAIL
Maak topic useratest aan --> success
maak publisher aan op topic useratest --> success
maak publisher aan op topic admin --> fail

Userb: Mag enkel op userb topics iets doe
Mag enkel op userb* topics iets doen
Mag enkel oplijsten in userb topic
Mag enkel publishen in userb topic

Maak topic test aan --> FAIL
Maak topic useratest aan --> fail
maak publisher aan op topic useratest --> fail
Maak topic useratest aan --> success
maak publisher aan op topic useratest --> success
maak publisher aan op topic admin --> fail

### commando's

## Test ACLs voor Kafka --> Quota

### Scenario's

Beperkingen voor usera op messagesize
Beperkingen voor userb op messagesize

testpublishing en check throttling


### commando's
