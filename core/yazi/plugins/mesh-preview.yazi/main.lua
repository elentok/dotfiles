local M = {}

function M:peek(job)
	local cache = ya.file_cache(job)
	if not cache then
		return
	end

	local ok, err = self:preload(job)
	if not ok or err then
		return ya.preview_widget(job, err)
	end

	local _, err = ya.image_show(cache, job.area)
	ya.preview_widget(job, err)
end

function M:seek() end

function M:preload(job)
	local cache = ya.file_cache(job)
	if not cache then
		return true
	end

	local cha = fs.cha(cache)
	if cha and cha.len > 0 then
		return true
	end

	local output, err = Command("mesh2png")
		:arg { tostring(job.file.url), tostring(cache) }
		:stdout(Command.PIPED)
		:stderr(Command.PIPED)
		:output()

	if not output then
		return false, Err("Failed to start `mesh2png`, error: %s", err)
	elseif not output.status.success then
		return false, Err("`mesh2png` failed, error: %s", output.stderr)
	end
	return true
end

return M
