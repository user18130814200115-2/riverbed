local main_ratio = 0.60
local gaps = 10
local offset = 60

function handle_layout(args)
	local retval = {}
	if args.count == 1 then
		table.insert(retval, { gaps, gaps, (args.width - gaps * 3) * main_ratio, args.height - gaps * 2 })
	elseif args.count > 1 then
		local main_w = (args.width - gaps * 3) * main_ratio
		local side_w = (args.width - gaps * 3) - main_w
		local main_h = args.height - gaps * 2
		local side_h = (args.height - gaps - offset) / (args.count - 1) - gaps
		table.insert(retval, {
			gaps,
			gaps,
			main_w,
			main_h,
		})
		for i = 0, (args.count - 2) do
			table.insert(retval, {
				main_w + gaps * 2,
				offset + gaps + i * (side_h + gaps),
				side_w,
				side_h,
			})
		end
	end
	return retval
end

function handle_metadata(args)
	return { name = "runoff" }
end
