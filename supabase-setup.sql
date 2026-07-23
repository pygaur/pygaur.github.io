-- =============================================================================
-- FizzBuzzCircle — Supabase schema & RLS reference
-- =============================================================================
-- Run sections in Supabase SQL Editor as needed.
-- Safe to re-run: uses IF NOT EXISTS / DROP POLICY IF EXISTS where applicable.
--
-- WEBSITE ↔ TABLE MAP
--   index.html, workshop.html  →  fizzbuzzart_workshops      (SELECT)
--   workshop.html registration →  fizzbuzzart_workshop_registrations (INSERT + SELECT id)
--   index.html artist gallery    →  fizzbuzzart_artists       (SELECT)
-- =============================================================================


-- -----------------------------------------------------------------------------
-- TABLE: fizzbuzzart_workshops
-- -----------------------------------------------------------------------------
-- Columns used by the website: id, title, description, workshop_date,
--   start_time, end_time, address, price, food_coupon_value, max_seats, image_url
-- Columns in DB but not yet shown on site: location, food_coupon, organizer_mobile
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS fizzbuzzart_workshops (
  id                  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  title               text,
  description         text,
  workshop_date       timestamptz,
  location            text,
  price               numeric,
  max_seats           int4,
  created_at          timestamptz DEFAULT now(),
  food_coupon         bool,
  start_time          time,
  end_time            time,
  food_coupon_value   numeric,
  address             text,
  organizer_mobile    text,
  image_url           text
);


-- -----------------------------------------------------------------------------
-- TABLE: fizzbuzzart_workshop_registrations
-- -----------------------------------------------------------------------------
-- Form fields submitted by workshop.html:
--   name, city, payment_mode, amount_paid  (+ workshop_id from URL)
-- Legacy column: mobile (kept for old rows; form no longer sends it)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS fizzbuzzart_workshop_registrations (
  id            bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  created_at    timestamptz DEFAULT now(),
  name          text,
  city          text,
  mobile        text,
  workshop_id   bigint REFERENCES fizzbuzzart_workshops(id),
  payment_mode  text,
  amount_paid   numeric
);

-- Add payment columns if table was created before the form update
ALTER TABLE fizzbuzzart_workshop_registrations
  ADD COLUMN IF NOT EXISTS payment_mode text,
  ADD COLUMN IF NOT EXISTS amount_paid numeric;


-- -----------------------------------------------------------------------------
-- TABLE: fizzbuzzart_artists
-- -----------------------------------------------------------------------------
-- Gallery cards show: name, specialty, image_url, bio,
--   instagram_handle, facebook_page_url, mobile_no
-- (loaded from database only — no static fallback on the site)
-- -----------------------------------------------------------------------------

CREATE TABLE IF NOT EXISTS fizzbuzzart_artists (
  id                  bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name                text NOT NULL,
  specialty           text NOT NULL,
  image_url           text,
  bio                 text,
  instagram_handle    text,
  facebook_page_url   text,
  mobile_no           text,
  created_at          timestamptz DEFAULT now()
);

ALTER TABLE fizzbuzzart_artists
  ADD COLUMN IF NOT EXISTS instagram_handle text,
  ADD COLUMN IF NOT EXISTS facebook_page_url text,
  ADD COLUMN IF NOT EXISTS mobile_no text;


-- =============================================================================
-- ROW LEVEL SECURITY (RLS)
-- =============================================================================
-- Current live policies (names must match exactly):
--
--   fizzbuzzart_workshops
--     • "Allow public workshop listing"     → SELECT  → anon
--
--   fizzbuzzart_workshop_registrations
--     • "Allow anonymous inserts"           → INSERT  → anon
--     • "Allow returning inserted id"       → SELECT  → anon
--       (required for .insert().select("id") on the registration form)
--
--   fizzbuzzart_artists
--     • "Allow public read on artists"      → SELECT  → anon, authenticated
-- =============================================================================

ALTER TABLE fizzbuzzart_workshops ENABLE ROW LEVEL SECURITY;
ALTER TABLE fizzbuzzart_workshop_registrations ENABLE ROW LEVEL SECURITY;
ALTER TABLE fizzbuzzart_artists ENABLE ROW LEVEL SECURITY;

-- Workshops: public read
DROP POLICY IF EXISTS "Allow public workshop listing" ON fizzbuzzart_workshops;
CREATE POLICY "Allow public workshop listing"
  ON fizzbuzzart_workshops FOR SELECT
  TO anon
  USING (true);

-- Registrations: public insert + read back inserted id
DROP POLICY IF EXISTS "Allow anonymous inserts" ON fizzbuzzart_workshop_registrations;
CREATE POLICY "Allow anonymous inserts"
  ON fizzbuzzart_workshop_registrations FOR INSERT
  TO anon
  WITH CHECK (true);

DROP POLICY IF EXISTS "Allow returning inserted id" ON fizzbuzzart_workshop_registrations;
CREATE POLICY "Allow returning inserted id"
  ON fizzbuzzart_workshop_registrations FOR SELECT
  TO anon
  USING (true);

-- Artists: public read
DROP POLICY IF EXISTS "Allow public read on artists" ON fizzbuzzart_artists;
CREATE POLICY "Allow public read on artists"
  ON fizzbuzzart_artists FOR SELECT
  TO anon, authenticated
  USING (true);


-- =============================================================================
-- VERIFY (optional — run manually to inspect live state)
-- =============================================================================
--
-- SELECT column_name, data_type, is_nullable
-- FROM information_schema.columns
-- WHERE table_schema = 'public'
--   AND table_name IN (
--     'fizzbuzzart_workshops',
--     'fizzbuzzart_workshop_registrations',
--     'fizzbuzzart_artists'
--   )
-- ORDER BY table_name, ordinal_position;
--
-- SELECT tablename, policyname, cmd, roles
-- FROM pg_policies
-- WHERE schemaname = 'public'
--   AND tablename LIKE 'fizzbuzzart%'
-- ORDER BY tablename, policyname;
-- =============================================================================
