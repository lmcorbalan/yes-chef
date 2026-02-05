-- Create sellers table
create table sellers (
  id uuid primary key default gen_random_uuid(),
  wallet_address text unique not null,
  telegram_handle text not null,
  created_at timestamptz default now()
);

-- Create products table
create table products (
  id uuid primary key default gen_random_uuid(),
  seller_id uuid references sellers(id) on delete cascade not null,
  title text not null,
  description text,
  price_usdc decimal(10,2) not null,
  images text[] default '{}',
  specs jsonb default '{}',
  shipping_info text,
  status text default 'active' check (status in ('active', 'delisted', 'sold_out')),
  stock int default 1,
  created_at timestamptz default now()
);

-- Create orders table
create table orders (
  id uuid primary key default gen_random_uuid(),
  product_id uuid references products(id) on delete restrict not null,
  buyer_email text not null,
  buyer_address text not null,
  amount_usdc decimal(10,2) not null,
  seller_wallet text not null,
  tx_hash text,
  status text default 'pending' check (status in ('pending', 'paid', 'shipped', 'cancelled')),
  created_at timestamptz default now()
);

-- Enable Row Level Security
alter table sellers enable row level security;
alter table products enable row level security;
alter table orders enable row level security;

-- Products: anyone can read active products
create policy "Anyone can view active products" on products
  for select using (status = 'active');

-- Sellers: no public access (will add auth policies later)
-- Orders: no public access (will add auth policies later)

-- Create indexes for common queries
create index idx_products_seller_id on products(seller_id);
create index idx_products_status on products(status);
create index idx_orders_product_id on orders(product_id);
create index idx_sellers_wallet on sellers(wallet_address);
