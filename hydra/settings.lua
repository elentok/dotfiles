-- auto reload when updating ~/.hydra directory
pathwatcher.new(os.getenv("HOME") .. "/.hydra/", hydra.reload):start()

-- launch hydra on startup
autolaunch.set(true)

--
ext.grid.MARGINX = 0
ext.grid.MARGINY = 0
