
# Rais / NodeJS / Asterisk VoIP-PBX Callcenter Webapp


## Overview
Rails / NodeJS webapp integrated with Asterisk VoIP-PBX for callcenter order taking. It interfaces with a thirdpart POS for ordering tasks.

It uses NodeJS/Express, Backbone and Socket.IO for async comminications for the front-end with the backend VoIP and POS systems.



 #TODO

- the test for clearing the form if the phone number are the same and the ext are different is not passing

- Currently is not clearing the user data when I clear the ext only working for replace

- need to complete and test store selection

- add clear when address dependencies change

- update destination store when service method changes

- cart is missing items edit

- Implementar dicontinuado/borrado store, coupons and products/ have to add discontinued to products to allow reimporting

- request.js crashes when destination host is unreachable

- add resports section

- refactor add coupons

- add import section

- Only show completed carts in clients and user carts history

- Handle when Olo2 returns cero clients or there are connection errors

- protect last admin deletion and self deletion

- verify acceptance test for admin stores editing

- test all model methods

- restric alpha is missing special characters

- check that params are passed to detailed report button