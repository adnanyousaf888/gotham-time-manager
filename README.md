# Time Manager – Gotham City Hall

Time-tracking platform for Gotham City Hall employees.

## Structure
- `backend/` — Elixir/Phoenix + PostgreSQL JSON API (users, clocks, working times)
- `frontend/` — Vue 3 (Vite) interface

## Run locally

Backend:
    cd backend
    mix deps.get
    mix ecto.setup
    mix phx.server

Frontend:
    cd frontend
    npm install
    npm run dev