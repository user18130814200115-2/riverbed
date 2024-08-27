local main_ratio = 0.60
local gaps = 10
local bar_height = 68
local maximize = false

function handle_layout(args)
	local retval = {}
		if args.count == 1 then
			table.insert(retval, {
				gaps,
				gaps - bar_height,
				(args.width - gaps * 3) * main_ratio,
				args.height + bar_height - gaps * 2
			})
		elseif args.count > 1 then
			local main_w = (args.width - gaps * 3) * main_ratio
			local side_w = (args.width - gaps * 3) - main_w
			local main_h = args.height + bar_height - gaps * 2
			local side_h = (args.height - gaps) / (args.count - 1) - gaps
			table.insert(retval, {
				gaps,
				gaps - bar_height,
				main_w,
				main_h,
			})
			for i = 0, (args.count - 2) do
				table.insert(retval, {
					main_w + gaps * 2,
					gaps + i * (side_h + gaps),
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

function set_bar_height(height)
	bar_height = height
	if height > 0 then
		bar_height = bar_height + gaps
	end
end
