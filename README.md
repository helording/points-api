# PointsApi

To start your Phoenix server:

  * Install dependencies with `mix deps.get`
  * Create and migrate your database with `mix ecto.setup`
  * Start Phoenix endpoint with `mix phx.server` or inside IEx with `iex -S mix phx.server`

Now you can visit [`localhost:4000`](http://localhost:4000) from your browser.

Ready to run in production? Please [check our deployment guides](https://hexdocs.pm/phoenix/deployment.html).

## Learn more

  * Official website: https://www.phoenixframework.org/
  * Guides: https://hexdocs.pm/phoenix/overview.html
  * Docs: https://hexdocs.pm/phoenix
  * Forum: https://elixirforum.com/c/phoenix-forum
  * Source: https://github.com/phoenixframework/phoenix

API Function calls

==============================================
Returns all customers
curl -X GET http://localhost:4000/api/customers -H "Content-Type: application/json" -d ""

==============================================
Creates a new customer with balance 0. If customer already exists return customer.
POST http://localhost:4000/api/customers -d {customer => {email: email, phone: phone}}}
example:
curl -X POST http://localhost:4000/api/customers -H "Content-Type: application/json" -d "{\"order\": {\"id\": \"104fd7e0-a188-4ffd-9af7-20d7876f70ab\", \"paid\": 10000, \"currency\": \"jpy\"}, \"customer\": {\"email\": null, \"phone\": \"0447683665\"}}"

==============================================
Get a single customer from an email or a phone number
GET http://localhost:4000/api/customer/__params__
example:
curl -X GET http://localhost:4000/api/customer/\?phone=0447683664 -H "Content-Type: application/json" -d ""
curl -X GET http://localhost:4000/api/customer/\?email=example@lunaris.com -H "Content-Type: application/json" -d ""
curl -X GET http://localhost:4000/api/customer/\?phone=0447683664&email=example@lunaris.com -H "Content-Type: application/json" -d ""

curl -X GET http://localhost:4000/api/customer/\?phone=null&email=null&balance=null -H "Content-Type: application/json" -d ""

==============================================
To process an order and add points to the account based on percentage. If an account doesn't exist, make an account
POST http://localhost:4000/api/orders/new -d {order => %{paid => amount}, customer => {email: email, phone: phone}}
example:
curl -X POST http://localhost:4000/api/orders/new -H "Content-Type: application/json" -d "{\"order\": {\"id\": \"104fd7e0-a188-4ffd-9af7-20d7876f70ab\", \"paid\": 10000, \"currency\": \"jpy\", \"percentage\": 50}, \"customer\": {\"email\": null, \"phone\": \"0447683665\"}}"

==============================================
To insert points into a customers account
PUT http://localhost:4000/api/customers {customer => {email: email, phone: phone}, amount => amount}
or
PUT http://localhost:4000/api/customers {customer => {email: email, phone: phone, balance: balance}}

examples:
curl -X PUT http://localhost:4000/api/customers -H "Content-Type: application/json" -d "{\"amount\": -2500, \"customer\": {\"email\": \"example@lunaris.com\", \"phone\": null}}"

curl -X PUT http://localhost:4000/api/customers -H "Content-Type: application/json" -d "{\"customer\": {\"email\": \"example@lunaris.com\", \"phone\": null, \"balance\": 5000}}"