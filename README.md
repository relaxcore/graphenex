## Project Setup

### Install Elixir, Phoenix, PostgreSQL
  * [Pro guides](https://lmgtfy.com/?q=install+elixir%2Fphoenix%2Fpostgres+%25here+is+my+OS%25)
### Clone the repository
```shell
git clone git@github.com:relaxcore/graphenex.git
cd graphenex
```
### Update ENV variables
```shell
cp apps/reporting/config/example.exs apps/reporting/config/dev.exs
vim apps/reporting/config/dev.exs
# set your psql username and password
```
### Install dependencies and setup database
```shell
mix deps.get
mix setup
```
### Start using app through interactive Elixir console
```shell
iex -S mix
```
