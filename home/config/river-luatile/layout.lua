local maximize = false

function update_variables()
	dofile('/home/user/.config/river-luatile/riverbed-autogen.lua')
end

function toggle_maximize()
	maximize = not maximize
end

update_variables()


function handle_layout(args)
	local retval = {}
	if args.height < display_height then
		bar_height = display_height - args.height
	else
		bar_height = 0
	end

	if maximize then
		table.insert(retval, {
			gaps,
			gaps - bar_height,
			(args.width - gaps * 2),
			args.height + bar_height - gaps * 2
		})
		for i = 0, (args.count - 2) do
			table.insert(retval, {0,display_height,0,0})
		end
		return retval
	end

	if layout == 'runoff' then
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
	elseif layout == 'dual' then
		local main_w = (args.width - gaps * 3) * main_ratio
		local side_w = ( (args.width - gaps * 3) - main_w ) / 2
		local main_h = args.height - gaps * 2
		table.insert(retval, {
			gaps + side_w,
			gaps,
			main_w,
			main_h,
		})
		for i = 0, (args.count - 2) do
			if i % 2 == 0 then
				local side_h = (args.height - gaps + bar_height) / (math.floor(args.count / 2)) - gaps
				table.insert(retval, {
					main_w + side_w + gaps * 2,
					gaps + math.floor(i/2) * (side_h + gaps) - bar_height,
					side_w,
					side_h,
				})
			else
				local side_h = (args.height - gaps + bar_height) / (math.floor((args.count - 1 )/ 2)) - gaps
				table.insert(retval, {
					gaps,
					gaps + math.floor(i/2) * (side_h + gaps) - bar_height,
					side_w - gaps,
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
