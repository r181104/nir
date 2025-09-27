const timeElement = document.getElementById("time");
const dateElement = document.getElementById("date");
const weatherIconElement = document.getElementById("weather-icon");
const temperatureElement = document.getElementById("temperature");
const locationElement = document.getElementById("location");
const linksContainer = document.getElementById("links-container");
const settingsButton = document.getElementById("settings-button");
const settingsMenu = document.getElementById("settings-menu");
const linksList = document.getElementById("links-list");
const addLinkButton = document.getElementById("add-link-button");

let links = [
  { name: "Youtube", url: "https://www.youtube.com" },
  { name: "Perplexity", url: "https://www.perplexity.ai" },
  { name: "ChatGpt", url: "https://www.chatgpt.com" },
  { name: "Chess", url: "https://www.chess.com" },
  { name: "Anime", url: "https://all-wish.me/home" },
  { name: "GitHub", url: "https://github.com" },
  { name: "Gmail", url: "https://gmail.com" },
  { name: "Reddit", url: "https://reddit.com" },
  { name: "StackOverflow", url: "https://stackoverflow.com" },
];

function updateTime() {
  const now = new Date();
  const hours = String(now.getHours()).padStart(2, "0");
  const minutes = String(now.getMinutes()).padStart(2, "0");
  const seconds = String(now.getSeconds()).padStart(2, "0");
  timeElement.textContent = `${hours}:${minutes}:${seconds}`;
  dateElement.textContent = now.toDateString();
}

function renderLinks() {
  linksContainer.innerHTML = "";
  links.forEach((link) => {
    const linkElement = document.createElement("a");
    linkElement.classList.add("link");
    linkElement.href = link.url;
    linkElement.textContent = link.name;
    linksContainer.appendChild(linkElement);
  });
}

function renderLinksEditor() {
  linksList.innerHTML = "";
  links.forEach((link, index) => {
    const linkItem = document.createElement("div");
    linkItem.classList.add("link-item");

    const nameInput = document.createElement("input");
    nameInput.type = "text";
    nameInput.value = link.name;
    nameInput.addEventListener("change", (e) => {
      links[index].name = e.target.value;
      saveLinks();
      renderLinks();
    });

    const urlInput = document.createElement("input");
    urlInput.type = "text";
    urlInput.value = link.url;
    urlInput.addEventListener("change", (e) => {
      links[index].url = e.target.value;
      saveLinks();
      renderLinks();
    });

    const removeButton = document.createElement("button");
    removeButton.textContent = "Remove";
    removeButton.addEventListener("click", () => {
      links.splice(index, 1);
      saveLinks();
      renderLinks();
      renderLinksEditor();
    });

    linkItem.appendChild(nameInput);
    linkItem.appendChild(urlInput);
    linkItem.appendChild(removeButton);
    linksList.appendChild(linkItem);
  });
}

function saveLinks() {
  localStorage.setItem("links", JSON.stringify(links));
}

function loadLinks() {
  const savedLinks = localStorage.getItem("links");
  if (savedLinks) {
    links = JSON.parse(savedLinks);
  }
}

async function getWeather() {
  try {
    const response = await fetch("https://wttr.in/Saharanpur?format=j1");
    const data = await response.json();

    const weather = data.current_condition[0];
    const icon = getWeatherIcon(weather.weatherCode);
    const temperature = `${weather.temp_C}°C`;
    const location = data.nearest_area[0].areaName[0].value;

    weatherIconElement.innerHTML = icon;
    temperatureElement.textContent = temperature;
    locationElement.textContent = location;
  } catch (error) {
    console.error("Error fetching weather:", error);
    weatherIconElement.innerHTML = "?";
    temperatureElement.textContent = "N/A";
    locationElement.textContent = "Error";
  }
}

function getWeatherIcon(weatherCode) {
  const icons = {
    "113": "☀️", // Clear/Sunny
    "116": "🌤️", // Partly cloudy
    "119": "☁️", // Cloudy
    "122": "☁️", // Overcast
    "143": "🌫️", // Mist
    "176": "🌦️", // Patchy rain possible
    "179": "🌨️", // Patchy snow possible
    "182": "🌨️", // Patchy sleet possible
    "185": "🌨️", // Patchy freezing drizzle possible
    "200": "⛈️", // Thundery outbreaks possible
    "227": "❄️", // Blowing snow
    "230": " Blizzard",
    "248": "🌫️", // Fog
    "260": "🌫️", // Freezing fog
    "263": "🌦️", // Patchy light drizzle
    "266": "🌦️", // Light drizzle
    "281": "🌨️", // Freezing drizzle
    "284": "🌨️", // Heavy freezing drizzle
    "293": "🌦️", // Patchy light rain
    "296": "🌦️", // Light rain
    "299": "🌧️", // Moderate rain at times
    "302": "🌧️", // Moderate rain
    "305": "🌧️", // Heavy rain at times
    "308": "🌧️", // Heavy rain
    "311": "🌨️", // Light freezing rain
    "314": "🌨️", // Moderate or heavy freezing rain
    "317": "🌨️", // Light sleet
    "320": "🌨️", // Moderate or heavy sleet
    "323": "❄️", // Patchy light snow
    "326": "❄️", // Light snow
    "329": "❄️", // Patchy moderate snow
    "332": "❄️", // Moderate snow
    "335": "❄️", // Patchy heavy snow
    "338": "❄️", // Heavy snow
    "350": "🌨️", // Ice pellets
    "353": "🌦️", // Light rain shower
    "356": "🌦️", // Moderate or heavy rain shower
    "359": "🌧️", // Torrential rain shower
    "362": "🌨️", // Light sleet showers
    "365": "🌨️", // Moderate or heavy sleet showers
    "368": "❄️", // Light snow showers
    "371": "❄️", // Moderate or heavy snow showers
    "374": "🌨️", // Light showers of ice pellets
    "377": "🌨️", // Moderate or heavy showers of ice pellets
    "386": "⛈️", // Patchy light rain with thunder
    "389": "⛈️", // Moderate or heavy rain with thunder
    "392": "⛈️", // Patchy light snow with thunder
    "395": "⛈️", // Moderate or heavy snow with thunder
  };
  return icons[weatherCode] || "?";
}

addLinkButton.addEventListener("click", () => {
  links.push({ name: "New Link", url: "https://example.com" });
  saveLinks();
  renderLinks();
  renderLinksEditor();
});

settingsButton.addEventListener("click", () => {
  settingsMenu.classList.toggle("hidden");
  renderLinksEditor();
});

loadLinks();
renderLinks();
setInterval(updateTime, 1000);
updateTime();
getWeather();
