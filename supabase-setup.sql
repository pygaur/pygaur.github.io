-- Run this in Supabase SQL Editor to align your database with the website.

-- Registration table: add payment fields (remove mobile if no longer needed)
ALTER TABLE fizzbuzzart_workshop_registrations
  ADD COLUMN IF NOT EXISTS payment_mode text,
  ADD COLUMN IF NOT EXISTS amount_paid numeric;

-- Optional: artists gallery table (site falls back to sample data if empty)
CREATE TABLE IF NOT EXISTS fizzbuzzart_artists (
  id bigint GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
  name text NOT NULL,
  specialty text NOT NULL,
  image_url text,
  bio text,
  created_at timestamptz DEFAULT now()
);

-- Allow public read on artists; adjust RLS policies as needed
ALTER TABLE fizzbuzzart_artists ENABLE ROW LEVEL SECURITY;

CREATE POLICY "Allow public read on artists"
  ON fizzbuzzart_artists FOR SELECT
  TO anon, authenticated
  USING (true);

-- Ensure registrations can be inserted by anon users
CREATE POLICY "Allow public insert on registrations"
  ON fizzbuzzart_workshop_registrations FOR INSERT
  TO anon, authenticated
  WITH CHECK (true);
