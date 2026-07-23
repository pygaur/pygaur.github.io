const SUPABASE_URL = "https://vswaudchnxlttzjfgeij.supabase.co";
const SUPABASE_ANON_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZzd2F1ZGNobnhsdHR6amZnZWlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ2ODY1OTYsImV4cCI6MjEwMDI2MjU5Nn0.ghLpA97sKdqCwcBSyL5pLY1QceLIGSc4ZSAjqu6GaSg";

function getSupabaseClient() {
  return supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}
