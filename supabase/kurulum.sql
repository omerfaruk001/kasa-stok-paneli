-- ============================================================
-- Tostça Kurtalan · Gelir & Gider Paneli — Supabase kurulumu
-- Supabase panelinde: SQL Editor > New query > bu dosyanın
-- tamamını yapıştırın > Run. Tekrar çalıştırmak güvenlidir.
--
-- Her kayıt, onu giren kullanıcıya (owner) aittir. RLS sayesinde
-- giriş yapmamış biri ya da başka bir kullanıcı hiçbir kaydı
-- göremez, değiştiremez.
-- ============================================================

-- Gider kalemleri (Sucuk, Kira, Elektrik...)
create table if not exists public.kalemler (
  id         text primary key,
  owner      uuid not null default auth.uid() references auth.users(id) on delete cascade,
  name       text not null check (length(name) between 1 and 60),
  type       text not null check (type in ('stok', 'sabit', 'diger')),  -- stok = Malzeme
  created_at timestamptz not null default now()
);

-- Gelirler (nakit / POS / havale)
create table if not exists public.gelirler (
  id         text primary key,
  owner      uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date       date not null,
  method     text not null check (method in ('nakit', 'pos', 'havale')),
  amount     numeric(14,2) not null check (amount > 0),
  note       text not null default '' check (length(note) <= 200),
  ts         bigint not null default (extract(epoch from now()) * 1000)::bigint,
  created_at timestamptz not null default now()
);

-- Giderler
create table if not exists public.giderler (
  id         text primary key,
  owner      uuid not null default auth.uid() references auth.users(id) on delete cascade,
  date       date not null,
  cat_id     text not null references public.kalemler(id) on delete restrict,
  amount     numeric(14,2) not null check (amount > 0),
  method     text not null check (method in ('nakit', 'kart', 'havale')),
  note       text not null default '' check (length(note) <= 200),
  ts         bigint not null default (extract(epoch from now()) * 1000)::bigint,
  created_at timestamptz not null default now()
);

-- İşletme ayarları (kullanıcı başına tek satır)
create table if not exists public.ayarlar (
  owner    uuid primary key default auth.uid() references auth.users(id) on delete cascade,
  name     text not null default 'Tostça Kurtalan',
  pos_rate numeric(6,3) not null default 0 check (pos_rate >= 0 and pos_rate < 100)
);

create index if not exists gelirler_owner_date_idx on public.gelirler (owner, date);
create index if not exists giderler_owner_date_idx on public.giderler (owner, date);
create index if not exists giderler_cat_idx        on public.giderler (cat_id);
create index if not exists kalemler_owner_idx      on public.kalemler (owner);

-- ---------- Güvenlik (RLS) ----------
alter table public.kalemler enable row level security;
alter table public.gelirler enable row level security;
alter table public.giderler enable row level security;
alter table public.ayarlar  enable row level security;

drop policy if exists "sahip_erisimi" on public.kalemler;
drop policy if exists "sahip_erisimi" on public.gelirler;
drop policy if exists "sahip_erisimi" on public.giderler;
drop policy if exists "sahip_erisimi" on public.ayarlar;

create policy "sahip_erisimi" on public.kalemler for all to authenticated
  using (owner = (select auth.uid())) with check (owner = (select auth.uid()));
create policy "sahip_erisimi" on public.gelirler for all to authenticated
  using (owner = (select auth.uid())) with check (owner = (select auth.uid()));
create policy "sahip_erisimi" on public.giderler for all to authenticated
  using (owner = (select auth.uid())) with check (owner = (select auth.uid()));
create policy "sahip_erisimi" on public.ayarlar for all to authenticated
  using (owner = (select auth.uid())) with check (owner = (select auth.uid()));

-- Giriş yapmamış ziyaretçiye (anon) hiçbir yetki yok; sadece giriş yapan kullanıcı.
revoke all on public.kalemler, public.gelirler, public.giderler, public.ayarlar from anon;
grant select, insert, update, delete on public.kalemler, public.gelirler, public.giderler, public.ayarlar to authenticated;
