local maximize = false
local overview = false

-- defaults
gaps = 5
main_ratio = 0.55
display_height = 1080
bar_height = 48
layout = 'runoff'
columns = 3
dynamic_columns = true


function update_variables()
	dofile('/home/user/.config/river-luatile/riverbed-autogen.lua')
end

function toggle_maximize()
	maximize = not maximize
end

function toggle_overview()
	overview = not overview
end

function set_layout(input)
	if input ~= nil then
		layout = input
	end
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
			gaps,
			(args.width - gaps * 2),
			args.height - gaps * 2
		})
		for i = 0, (args.count - 2) do
			table.insert(retval, {0,display_height,0,0})
		end
		return retval
	end
	if overview then
		local columns = math.ceil(math.sqrt(args.count))
		local gaps = gaps * 5
		local side_w = args.width / math.min(args.count, columns) - gaps * 2

		for i = 0, (args.count - 1) do
			local side_h = args.height / math.floor((args.count + columns - 1 - i % columns) / columns) - gaps * 2

			table.insert(retval, {
				(2 * gaps + side_w) * (i % columns) + gaps,
				(2 * gaps + side_h) * math.floor(i / columns) + gaps,
				side_w,
				side_h,
			})
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
	elseif layout == 'grid' then
		if dynamic_columns then
			columns = math.ceil(math.sqrt(args.count))
		end
		local side_w = args.width / math.min(args.count, columns) - gaps * 2

		for i = 0, (args.count - 1) do
			local side_h = args.height / math.floor((args.count + columns - 1 - i % columns) / columns) - gaps * 2

			table.insert(retval, {
				(side_w + gaps + gaps * 2 / columns) * (i % columns) + gaps,
				(2 * gaps + side_h) * math.floor(i / columns) + gaps,
				side_w + 2 * gaps / columns,
				side_h + gaps *2 / 3,
			})
		end
	end
	return retval
end

function handle_metadata(args)
	return { name = "runoff" }
end
