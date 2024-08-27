local main_ratio = 0.60
local gaps = 10
local bar_height = 48
local maximize = false

local offset = bar_height + 2 * gaps

function handle_layout(args)
	local retval = {}

	if maximize then
		table.insert(retval, { gaps, gaps - offset, (args.width - gaps * 2), args.height - gaps * 2 + offset })
		if args.count > 1 then
			for i = 0, (args.count - 2) do
				table.insert(retval, {
					0,
					0,
					0,
					0,
				})
			end
		end
	else
		if args.count == 1 then
			table.insert(retval, { gaps, gaps - offset, (args.width - gaps * 3) * main_ratio, args.height - gaps * 2 + offset })
		elseif args.count > 1 then
			local main_w = (args.width - gaps * 3) * main_ratio
			local side_w = (args.width - gaps * 3) - main_w
			local main_h = args.height - gaps * 2 + offset
			local side_h = (args.height - gaps) / (args.count - 1)
			table.insert(retval, {
				gaps,
				gaps - offset,
				main_w,
				main_h,
			})
			for i = 0, (args.count - 2) do
				table.insert(retval, {
					main_w + gaps * 2,
					i * (side_h),
					side_w,
					side_h,
				})
			end
		end
	end
	return retval
end

function handle_metadata(args)
	return { name = "runoff" }
end

function toggle_maximize()
	maximize = not maximize
end
