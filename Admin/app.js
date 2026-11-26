const API = localStorage.getItem("lunexufaApi") || "http://127.0.0.1:8080";
document.getElementById("apiBase").textContent = API;

const logEl = document.getElementById("log");
function log(msg) {
  const line = `[${new Date().toLocaleTimeString()}] ${msg}`;
  logEl.textContent = line + "\n" + logEl.textContent;
}

async function api(path, opts = {}) {
  const res = await fetch(API + path, {
    headers: { "Content-Type": "application/json", ...(opts.headers || {}) },
    ...opts,
  });
  const data = await res.json();
  if (!res.ok) throw new Error(data.error || res.statusText);
  return data;
}

function fillWorldSelects(worlds) {
  for (const id of ["botWorld", "chatWorld"]) {
    const sel = document.getElementById(id);
    const cur = sel.value;
    sel.innerHTML = "";
    worlds.forEach((w) => {
      const o = document.createElement("option");
      o.value = w.id;
      o.textContent = `${w.name} (${w.id})`;
      sel.appendChild(o);
    });
    if (cur) sel.value = cur;
  }
}

async function refreshWorlds() {
  const data = await api("/worlds");
  const ul = document.getElementById("worldList");
  ul.innerHTML = "";
  data.worlds.forEach((w) => {
    const li = document.createElement("li");
    li.textContent = `${w.name} — id=${w.id}, map=${w.mapId}, bots=${w.botsEnabled}`;
    ul.appendChild(li);
  });
  fillWorldSelects(data.worlds);
  log(`Миров: ${data.worlds.length}`);
}

async function refreshShop() {
  const shop = await api("/shop/items");
  const sel = document.getElementById("shopItem");
  const cur = sel.value;
  sel.innerHTML = "";
  shop.items.forEach((it) => {
    const o = document.createElement("option");
    o.value = it.id;
    o.textContent = `${it.name} — ${it.price}`;
    o.dataset.price = it.price;
    sel.appendChild(o);
  });
  if (cur) sel.value = cur;
  const opt = sel.selectedOptions[0];
  document.getElementById("shopPrice").value = opt ? opt.dataset.price : "";
  document.getElementById("shopOut").textContent = JSON.stringify(shop, null, 2);
}

document.getElementById("shopItem").addEventListener("change", (e) => {
  const opt = e.target.selectedOptions[0];
  document.getElementById("shopPrice").value = opt ? opt.dataset.price : "";
});

document.getElementById("btnRefreshWorlds").onclick = () =>
  refreshWorlds().catch((e) => log(e.message));
document.getElementById("btnCreateWorld").onclick = async () => {
  try {
    const name = document.getElementById("worldName").value || "Хайтен-2";
    const data = await api("/worlds", {
      method: "POST",
      body: JSON.stringify({ name, template: "haitan", mapId: 110200011 }),
    });
    log(`Создан мир ${data.world.id}`);
    await refreshWorlds();
  } catch (e) {
    log(e.message);
  }
};

document.getElementById("btnSavePrice").onclick = async () => {
  try {
    const id = document.getElementById("shopItem").value;
    const price = Number(document.getElementById("shopPrice").value);
    const data = await api("/shop/items", {
      method: "PUT",
      body: JSON.stringify({ id, price }),
    });
    log(`Цена ${id} = ${price}, version=${data.shop.version}`);
    await refreshShop();
  } catch (e) {
    log(e.message);
  }
};

document.getElementById("btnStartBot").onclick = async () => {
  try {
    const worldId = document.getElementById("botWorld").value;
    const chatLine = document.getElementById("botLine").value;
    const data = await api("/bots/start", {
      method: "POST",
      body: JSON.stringify({ worldId, chatLine }),
    });
    document.getElementById("botOut").textContent = JSON.stringify(data, null, 2);
    log(`Бот ${data.bot.id} запущен в ${worldId}`);
  } catch (e) {
    log(e.message);
  }
};

document.getElementById("btnStopBots").onclick = async () => {
  try {
    const worldId = document.getElementById("botWorld").value;
    await api("/bots/stop-all", { method: "POST", body: JSON.stringify({ worldId }) });
    log(`Боты отключены в ${worldId}`);
  } catch (e) {
    log(e.message);
  }
};

document.getElementById("btnRefreshChat").onclick = async () => {
  try {
    const worldId = document.getElementById("chatWorld").value;
    const data = await api("/chat?worldId=" + encodeURIComponent(worldId));
    document.getElementById("chatOut").textContent = data.messages
      .map((m) => `${m.isBot ? "[бот] " : ""}${m.from}: ${m.text}`)
      .join("\n");
  } catch (e) {
    log(e.message);
  }
};

Promise.all([refreshWorlds(), refreshShop()]).catch((e) => log(e.message));
