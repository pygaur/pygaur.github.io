/** SEO helpers — uses current origin so it works on GitHub Pages or custom domain. */

function getSiteOrigin() {
  return window.location.origin;
}

function setMeta(name, content, attr) {
  if (!content) return;
  attr = attr || "name";
  let el = document.querySelector(`meta[${attr}="${name}"]`);
  if (!el) {
    el = document.createElement("meta");
    el.setAttribute(attr, name);
    document.head.appendChild(el);
  }
  el.setAttribute("content", content);
}

function setCanonical(url) {
  let link = document.querySelector('link[rel="canonical"]');
  if (!link) {
    link = document.createElement("link");
    link.rel = "canonical";
    document.head.appendChild(link);
  }
  link.href = url;
}

function setPageMeta(opts) {
  const title = opts.title;
  const description = opts.description;
  const url = opts.url;
  const image = opts.image;
  const type = opts.type || "website";

  document.title = title;
  setMeta("description", description);
  setMeta("robots", "index, follow");
  setMeta("og:title", title, "property");
  setMeta("og:description", description, "property");
  setMeta("og:type", type, "property");
  setMeta("og:url", url, "property");
  setMeta("og:site_name", "FizzBuzzCircle", "property");
  setMeta("og:locale", "en_IN", "property");
  if (image) setMeta("og:image", image, "property");
  setMeta("twitter:card", image ? "summary_large_image" : "summary");
  setMeta("twitter:title", title);
  setMeta("twitter:description", description);
  if (image) setMeta("twitter:image", image);
  setCanonical(url);
}

function injectJsonLd(id, data) {
  let script = document.getElementById(id);
  if (!script) {
    script = document.createElement("script");
    script.type = "application/ld+json";
    script.id = id;
    document.head.appendChild(script);
  }
  script.textContent = JSON.stringify(data);
}

function workshopPageUrl(id) {
  return getSiteOrigin() + "/workshop.html?id=" + id;
}

function toIsoDateTime(dateStr, timeStr) {
  if (!dateStr) return undefined;
  const d = new Date(dateStr);
  if (isNaN(d.getTime())) return undefined;
  if (timeStr) {
    const parts = timeStr.split(":");
    d.setHours(parseInt(parts[0], 10) || 0, parseInt(parts[1], 10) || 0, 0, 0);
  }
  return d.toISOString();
}

function buildEventJsonLd(workshop) {
  const pageUrl = workshopPageUrl(workshop.id);
  const event = {
    "@context": "https://schema.org",
    "@type": "Event",
    name: workshop.title,
    description: workshop.description || undefined,
    startDate: toIsoDateTime(workshop.workshop_date, workshop.start_time),
    endDate: toIsoDateTime(workshop.workshop_date, workshop.end_time),
    eventAttendanceMode: "https://schema.org/OfflineEventAttendanceMode",
    eventStatus: "https://schema.org/EventScheduled",
    image: workshop.image_url || undefined,
    url: pageUrl,
    location: {
      "@type": "Place",
      name: workshop.address || workshop.location || "Workshop venue",
      address: workshop.address || workshop.location || undefined
    },
    offers: {
      "@type": "Offer",
      price: workshop.price,
      priceCurrency: "INR",
      availability: "https://schema.org/InStock",
      url: pageUrl
    },
    organizer: {
      "@type": "Organization",
      name: "FizzBuzzCircle",
      url: getSiteOrigin() + "/"
    }
  };
  if (workshop.artist && workshop.artist.name) {
    event.performer = {
      "@type": "Person",
      name: workshop.artist.name
    };
  }
  return event;
}

function buildWorkshopListJsonLd(workshops) {
  return {
    "@context": "https://schema.org",
    "@type": "ItemList",
    name: "Upcoming art workshops by FizzBuzzCircle",
    itemListElement: workshops.map((w, i) => ({
      "@type": "ListItem",
      position: i + 1,
      url: workshopPageUrl(w.id),
      name: w.title
    }))
  };
}

window.setPageMeta = setPageMeta;
window.injectJsonLd = injectJsonLd;
window.buildEventJsonLd = buildEventJsonLd;
window.buildWorkshopListJsonLd = buildWorkshopListJsonLd;
window.workshopPageUrl = workshopPageUrl;
window.getSiteOrigin = getSiteOrigin;
