hydra.alert("Hydra init started", 1.5)

local function load(module)
  dofile(os.getenv("HOME") .. "/.hydra/" .. module .. ".lua")
end

load "grid"
load "settings"
load "functions"
load "check_for_updates"
load "menu"
load "keys"

hydra.alert("Hydra init complete")
