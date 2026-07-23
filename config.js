const SUPABASE_URL = "https://vswaudchnxlttzjfgeij.supabase.co";
const SUPABASE_ANON_KEY =
  "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InZzd2F1ZGNobnhsdHR6amZnZWlqIiwicm9sZSI6ImFub24iLCJpYXQiOjE3ODQ2ODY1OTYsImV4cCI6MjEwMDI2MjU5Nn0.ghLpA97sKdqCwcBSyL5pLY1QceLIGSc4ZSAjqu6GaSg";

function getSupabaseClient() {
  return supabase.createClient(SUPABASE_URL, SUPABASE_ANON_KEY);
}

/** Parse workshop_date from Supabase (date or timestamptz string). */
function parseWorkshopDate(dateStr) {
  const d = new Date(dateStr);
  d.setHours(0, 0, 0, 0);
  return d;
}

function isWorkshopPast(dateStr) {
  const today = new Date();
  today.setHours(0, 0, 0, 0);
  return parseWorkshopDate(dateStr) < today;
}

function formatWorkshopDate(dateStr, options) {
  return new Date(dateStr).toLocaleDateString("en-IN", options);
}

/** Format PostgreSQL time "12:00:00" → "12:00 PM" */
function formatWorkshopTime(timeStr) {
  if (!timeStr) return "";
  const parts = timeStr.split(":");
  const hour = parseInt(parts[0], 10);
  const minute = parts[1] || "00";
  const ampm = hour >= 12 ? "PM" : "AM";
  const h12 = hour % 12 || 12;
  return `${h12}:${minute} ${ampm}`;
}

function formatWorkshopTimeRange(start, end) {
  if (!start && !end) return "";
  if (!end) return formatWorkshopTime(start);
  return `${formatWorkshopTime(start)} – ${formatWorkshopTime(end)}`;
}

window.getSupabaseClient = getSupabaseClient;
window.parseWorkshopDate = parseWorkshopDate;
window.isWorkshopPast = isWorkshopPast;
window.formatWorkshopDate = formatWorkshopDate;
window.formatWorkshopTime = formatWorkshopTime;
window.formatWorkshopTimeRange = formatWorkshopTimeRange;
