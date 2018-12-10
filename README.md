GCPD Tracker System 
===
This is the completed version of Phase 5 of the Gotham City Police Department Tracker System.  This project was assigned in the fall of 2018 as a 67-272 project at Carnegie Mellon University, Information Systems department.  More information about the project can be found at [67272.cmuis.net](https://67272.cmuis.net).

Populating the dev database
---
You can populate the development database with a decent number of fictitious records with the command `rake db:populate`.  There are over 50 investigations generated, but only one is initially closed.

There is also a large set of criminals generated this time around, including many from Batman's famous 'Rogues Gallery'. Great reading and worth formatting appropriately.

Notes on tests
---
There is 100% test coverage for existing models and helpers.  However, if there are significant changes to some of the existing models, then tests should be updated so that coverage remains at 100%.

The one exception to the above rule is the Ability model, where you have a complete set of tests, but no model so all tests will fail.  (Of course, you will rectify this situation during this phase.)

Login Credentials
---
Commish:
username: jgordon , password: secret

Chief:
username: msawyer, password: secret

Officer:
username: jblake, password: secret

Known Issues...
---
Make sure you refresh the page after pressing "X" for removing a crime from a investigation,(the crime does get removed, but the page doesn't rerender automatically) there is a bug with Vue at the moment.


