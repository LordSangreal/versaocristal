-- VersaoCristal: Pokemon Crystal em portugues brasileiro.
--
-- Nome de POKeMON, de personagem e de cidade ficam no original em ingles, de
-- proposito -- so a palavra generica de lugar traduz ("CIDADE DE VIOLET").
-- Golpe, item, tipo e classe de treinador SE traduzem desde a 0.48.0, com a
-- terminologia das cartas de TCG pt-BR; por isso existem lang/move_names.lua
-- e lang/item_names.lua. Nao ha lang/species_names.lua e nao deve haver.

return function(mod)
  -- ---- idioma de GOLPE, ITEM, NPCS e POKEDEX ------------------------------
  local idioma = {
    falas = "pt",
    menus = "pt",
    golpes = "pt",
    desc_golpes = "pt",
    itens = "pt",
    desc_itens = "pt",
    npcs = "pt",
    tipos = "pt",
    status = "pt",
    mapa = "pt",
    pokedex = "pt",
    medidas = "METRICO",
    radios = "pt",
  }
  -- Chaves de lang/strings.lua que sao NOMES de estacao do POKeGEAR, e nao
  -- falas. Com NOME DAS RADIOS em ENGLISH elas ficam no original.
  local ESTACOES = {
    ["Lucky Channel"] = true, ["POKéDEX Show"] = true,
    ["POKéMON Music"] = true, ["POKÉMON Music"] = true,
    ["POKéMON Channel"] = true, ["Places & People"] = true,
    ["Places and People"] = true, ["Let's All Sing!"] = true,
    ["OAK's <PK><MN> Talk"] = true, ["OAK's PKMN Talk"] = true,
    ["POKé FLUTE"] = true, ["POKÉ FLUTE"] = true,
    ["Rocket Radio"] = true, ["Unown Radio"] = true,
    ["BUENA'S PASSWORD"] = true,
  }
  -- Chaves de status em lang/strings.lua controladas pela opcao `status`.
  local STATUS_CHAVES = {
    SLP = true, PSN = true, BRN = true, FRZ = true, PAR = true, FNT = true,
  }
  local temOpcoes = pcall(function()
    mod.options:define({
      {
        key = "golpes",
        type = "choice",
        label = "NOME DOS GOLPES",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "desc_golpes",
        type = "choice",
        label = "DESCRIÇÕES DOS GOLPES",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "itens",
        type = "choice",
        label = "NOME DOS ITENS",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "desc_itens",
        type = "choice",
        label = "DESCRIÇÕES DOS ITENS",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "npcs",
        type = "choice",
        label = "NOME DOS NPCS",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "tipos",
        type = "choice",
        label = "NOMES DOS TIPOS",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "status",
        type = "choice",
        label = "RÓTULOS DE STATUS",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "mapa",
        type = "choice",
        label = "NOMES DO MAPA",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "pokedex",
        type = "choice",
        label = "POKEDEX",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "medidas",
        type = "choice",
        label = "MEDIDAS DA #DEX",
        choices = { { "METRICO", "METRICO" }, { "IMPERIAL", "IMPERIAL" } },
        default = "METRICO",
        requires_restart = true,
      },
      {
        key = "falas",
        type = "choice",
        label = "FALAS",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "menus",
        type = "choice",
        label = "MENUS E BATALHA",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
      {
        key = "radios",
        type = "choice",
        label = "NOME DAS RADIOS",
        choices = { { "PORTUGUES", "pt" }, { "ENGLISH", "en" } },
        default = "pt",
        requires_restart = true,
      },
    })
  end)
  if temOpcoes then
    for chave in pairs(idioma) do
      local ok, valor = pcall(function() return mod.options:get(chave) end)
      if ok and type(valor) == "string" and valor ~= "" then
        idioma[chave] = valor
      end
    end
  end

  local function catalog(name)
    local rel = "lang/" .. name .. ".lua"
    local body = mod:read(rel)
    if not body then return {} end
    local loader = loadstring or load
    local chunk, err = loader(body, rel)
    if not chunk then
      mod.log:warn("%s tem erro de sintaxe: %s", rel, tostring(err))
      return {}
    end
    local ok, t = pcall(chunk)
    if not ok or type(t) ~= "table" then
      mod.log:warn("%s nao devolveu uma tabela", rel)
      return {}
    end
    return t
  end

  local function each(name, apply)
    local n = 0
    for k, v in pairs(catalog(name)) do
      if type(v) == "string" and v ~= "" then
        apply(k, v)
        n = n + 1
      end
    end
    return n
  end

  -- ---- glifos -------------------------------------------------------
  for id, page in pairs(catalog("font")) do
    if type(page) == "table" and type(page.image) == "string"
        and mod:read(page.image) then
      page.image = mod.assets:path(page.image)
    end
    mod.content.font:register(id, page)
  end
  for seq, code in pairs(catalog("charmap")) do
    mod.content.font:register("charmap:" .. seq, { seq = seq, code = code })
  end

  -- ---- aplicacao -----------------------------------------------------
  local n = 0
  if idioma.falas == "pt" then
    n = n + each("dialogue", function(k, v)
      mod.content.text:override(k, v)
      if k:sub(1, 6) == "TEXT_S" then
        local bank, addr = k:sub(7):match("^(%w+)_(%w+)$")
        if bank and addr then
          mod.content.text:override(bank:lower() .. ":" .. addr:lower(), v)
        end
      elseif k:find("^%x%x:%x%x%x%x$") then
        local bank, addr = k:match("^(%x%x):(%x%x%x%x)$")
        if bank and addr then
          mod.content.text:override("TEXT_S" .. bank:upper() .. "_" .. addr:upper(), v)
        end
      end
    end)
  end

  if idioma.menus == "pt" then
    local catalog_strings = catalog("strings")
    n = n + each("strings", function(src, value)
      -- Nome de estacao em ENGLISH: nao sobrescreve, o motor mostra o original.
      if idioma.radios == "en" and ESTACOES[src] then return end
      -- Rotulo de status em ENGLISH: nao sobrescreve SLP/PSN/BRN/FRZ/PAR/FNT.
      if idioma.status == "en" and STATUS_CHAVES[src] then return end
      mod.content.strings:override(src, value)
    end)

    -- Hook do Pokegear / Radio para garantir traducao das falas e estacoes
    pcall(function()
      local Screens = require("src.ui.Screens")
      local Pokegear = Screens.get(mod.game, "Gen2Pokegear")
      local Strings = require("src.core.Strings")
      if not Pokegear then return end

      local function translateRadioText(s)
        if type(s) ~= "string" or s == "" then return s end
        -- Estacao em ENGLISH: o hook tambem nao traduz o nome do canal.
        if idioma.radios == "en" and ESTACOES[s] then return s end

        local oak_mon = s:match("^OAK: (.+)$")
        if oak_mon then
          local tpl = catalog_strings["OAK: %s"] or "OAK: %s"
          return string.format(tpl, oak_mon)
        end

        local mary_mon = s:match("^MARY: (.+)'s$")
        if mary_mon then
          local tpl = catalog_strings["MARY: %s's"] or "MARY: O %s é"
          return string.format(tpl, mary_mon)
        end

        local num = s:match("^Number is (%d+)!$")
        if num then
          local tpl = catalog_strings["Number is %05d!"] or "é o %05d!"
          return string.format(tpl, tonumber(num))
        end

        local day = s:match("^Today's ([A-Z]+),$")
        if day then
          local full_match = catalog_strings[s]
          if full_match then return full_match end
          local day_trans = catalog_strings[day] or day
          local tpl = catalog_strings["Today's %s,"] or "Hoje é %s,"
          return string.format(tpl, day_trans)
        end

        if catalog_strings[s] then
          return catalog_strings[s]
        end

        if Strings then
          return Strings(s)
        end

        return s
      end

      if Pokegear.text then
        local orig_text = Pokegear.text
        Pokegear.text = function(self, str, tx, ty)
          return orig_text(self, translateRadioText(str), tx, ty)
        end
      end

      if Pokegear.Radio and Pokegear.Radio.printLine then
        local orig_print = Pokegear.Radio.printLine
        Pokegear.Radio.printLine = function(self, text, nextLine)
          return orig_print(self, translateRadioText(text), nextLine)
        end
        Pokegear.Radio.nextLine = Pokegear.Radio.printLine
      end

      if Pokegear.STATION_NAMES then
        for k, name in pairs(Pokegear.STATION_NAMES) do
          Pokegear.STATION_NAMES[k] = translateRadioText(name)
        end
      end

      if idioma.mapa == "pt" then
        local catalog_landmarks = catalog("landmarks")
        if Pokegear.mapLandmark then
          local orig_map = Pokegear.mapLandmark
          Pokegear.mapLandmark = function(self)
            local entry = orig_map(self)
            if entry and entry.id and catalog_landmarks[entry.id] then
              entry.name = catalog_landmarks[entry.id]
            end
            return entry
          end
        end

        if Pokegear.playerLandmark then
          local orig_player = Pokegear.playerLandmark
          Pokegear.playerLandmark = function(self)
            local entry = orig_player(self)
            if entry and entry.id and catalog_landmarks[entry.id] then
              entry.name = catalog_landmarks[entry.id]
            end
            return entry
          end
        end
      end
    end)

    -- Relogio do Pokegear: o motor monta o dia como
    -- RomText("PrintDayOfWeek.Days#N") .. RomText("PrintDayOfWeek.Day").
    -- Na ROM BR o segundo trecho e "DIA", e o resultado na tela e "TUESDIA".
    -- Devolve o nome traduzido direto, antes dessa concatenacao.
    pcall(function()
      local Clock = require("src.core.gen2.Clock")
      if not Clock or type(Clock.weekdayName) ~= "function" then return end
      local DIAS_PT = {
        "DOMINGO", "SEGUNDA", "TERÇA", "QUARTA", "QUINTA", "SEXTA", "SÁBADO",
      }
      local orig_weekday = Clock.weekdayName
      Clock.weekdayName = function(day, data)
        local nome = type(day) == "number" and DIAS_PT[day] or nil
        if nome then return nome end
        return orig_weekday(day, data)
      end
    end)
-- Hook do StartMenu para garantir traducao das descricoes dos itens do menu
    pcall(function()
      local StartMenu = require("src.ui.gen2.StartMenu")
      if not StartMenu then return end

      if StartMenu.new then
        local orig_start_new = StartMenu.new
        StartMenu.new = function(game, opts)
          local menu = orig_start_new(game, opts)
          if menu and menu.items then
            for _, item in ipairs(menu.items) do
              local raw = type(item.desc) == "table" and table.concat(item.desc, "\n") or (type(item.desc) == "string" and item.desc or nil)
              if raw then
                local t = catalog_strings[raw] or catalog_strings[raw:gsub("\n", " ")]
                if not t and type(item.desc) == "table" and #item.desc == 2 then
                  t = catalog_strings[item.desc[1] .. " " .. item.desc[2]]
                end
                if t then
                  item.desc = {}
                  for l in (t .. "\n"):gmatch("(.-)\n") do
                    item.desc[#item.desc + 1] = l
                  end
                end
              end
              if item.label and catalog_strings[item.label] then
                item.label = catalog_strings[item.label]
              end
            end
          end
          return menu
        end
      end
    end)

    -- Hook do Menu de Batalha (BattleState): expande caixa e usa POKéMON sem abreviação
    pcall(function()
      local BattleState = require("src.ui.gen2.BattleState")
      local Chrome = require("src.ui.gen2.Chrome")
      if not BattleState then return end

      BattleState.MENU_BOX_X = 2
      BattleState.MENU_COL_SPACING = 8
      if BattleState.MENU_ACTION then
        BattleState.MENU_ACTION["POKéMON"] = "party"
        BattleState.MENU_ACTION["POKEMON"] = "party"
      end

      local orig_menuLabels = BattleState.menuLabels
      if orig_menuLabels then
        BattleState.menuLabels = function(self)
          local labels = orig_menuLabels(self)
          if labels and (labels[2] == "<PK><MN>" or labels[2] == "PKMN") then
            labels[2] = "POKéMON"
          end
          return labels
        end
      end

      local orig_drawBottom = BattleState.drawBottom
      if orig_drawBottom then
        BattleState.drawBottom = function(self, ox)
          if self.phase == "menu" and not self.contest then
            ox = ox or 0
            if not self:bottomUIVisible() then
              love.graphics.setColor(1, 1, 1, 1)
              return
            end
            Chrome.box(0, 12, 20 + ox, 6)
            self:printMessage(ox)
            local boxX = 2 + ox
            local spacing = 8
            Chrome.box(boxX, 12, 20 + ox - boxX, 6)
            local labels = self:menuLabels()
            for i, label in ipairs(labels) do
              local col = ((i - 1) % 2) * spacing
              local row = math.floor((i - 1) / 2) * 2
              local tx, ty = boxX + 2 + col, 14 + row
              if i == self.menuIndex then
                Chrome.cursorThrough(tx - 1, ty, Chrome.DEFAULT_BOX_PALETTE)
              end
              Chrome.printThrough(label, tx, ty, Chrome.DEFAULT_BOX_PALETTE)
            end
            return
          end
          return orig_drawBottom(self, ox)
        end
      end
    end)
  end

  if idioma.itens == "pt" then
    n = n + each("item_names", function(id, value)
      mod.content.items:patch(id, { name = value })
    end)
  end
  if idioma.desc_itens == "pt" then
    each("item_descriptions", function(id, value)
      pcall(function() mod.content.items:patch(id, { description = value }) end)
    end)
  end

  if idioma.golpes == "pt" then
    each("move_names", function(id, value)
      pcall(function() mod.content.moves:patch(id, { name = value }) end)
    end)
  end
  if idioma.desc_golpes == "pt" then
    each("move_descriptions", function(id, value)
      pcall(function() mod.content.moves:patch(id, { description = value }) end)
    end)
  end

  if idioma.mapa == "pt" then
    n = n + each("landmarks", function(id, value)
      mod.content.landmarks:patch(id, { name = value })
    end)
  end

  if idioma.npcs == "pt" then
    each("trainer_classes", function(id, value)
      pcall(function() mod.content.trainers:patch(id, { name = value }) end)
    end)
  end

  if idioma.status == "pt" then
    each("status_labels", function(id, value)
      pcall(function() mod.content.statuses:patch(id, { label = value, hudLabel = value }) end)
    end)
  end

  if idioma.tipos == "pt" then
    each("type_names", function(id, value)
      pcall(function() mod.content.type_chart:patch(id, { name = value }) end)
    end)
  end

  -- POKéDEX
  local dex
  if idioma.pokedex == "pt" then
    dex = catalog("pokedex")
    if mod.content.pokedex then
      for id, entrada in pairs(dex) do
        if type(entrada) == "table" then
          pcall(function() mod.content.pokedex:patch(id, entrada) end)
        end
      end
    end
  end
  if idioma.medidas == "METRICO" and mod.content.pokemon then
    dex = dex or catalog("pokedex")
    for id, entrada in pairs(dex) do
      if type(entrada) == "table" and entrada.height and entrada.weight then
        pcall(function()
          local hM = (math.floor(entrada.height / 100) * 12 + (entrada.height % 100)) * 0.0254
          local wKg = entrada.weight / 10 * 0.45359237
          mod.content.pokemon:patch(id, {
            dexEntry = {
              heightM = hM,
              weightKg = wKg,
              heightFt = math.floor(entrada.height / 100),
              heightIn = entrada.height % 100,
              weight = entrada.weight,
            },
          })
        end)
      end
    end
  end

  mod.events:on("game.ready", function()
    mod.log:info("VersaoCristal: mod pronto e carregado")
  end)
end
