-- Fix Monika Sharma artist profile (workshop image was stored by mistake)
-- Replace PROFILE_PHOTO_URL with a permanent URL (see note below)

UPDATE fizzbuzzart_artists
SET
  image_url = 'PROFILE_PHOTO_URL',
  bio = 'Russian Sculpture Painting Artist · Noida'
WHERE name = 'Monika Sharma';

-- Recommended: upload her profile photo to Supabase Storage → Public bucket
-- then paste that public URL above instead of an Instagram link (Instagram URLs expire).
