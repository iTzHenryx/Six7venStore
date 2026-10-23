-- Pega todo esto en Supabase > SQL Editor > New query > Run

create table if not exists orders (
  id          bigint generated always as identity primary key,
  user_id     uuid not null default auth.uid() references auth.users(id) on delete cascade,
  diamonds    int  not null,
  bonus       int  not null,
  price       int  not null,
  player_id   text not null,
  method      text not null,
  status      text not null default 'pendiente',
  created_at  timestamptz not null default now()
);

alter table orders enable row level security;

-- Cada cliente solo puede ver sus propios pedidos
create policy "ver mis pedidos"
  on orders for select
  using (auth.uid() = user_id);

-- Cada cliente solo puede crear pedidos a su nombre
create policy "crear mis pedidos"
  on orders for insert
  with check (auth.uid() = user_id);

-- Nota: el cliente no puede cambiar el status; tu lo actualizas desde el panel de Supabase.
