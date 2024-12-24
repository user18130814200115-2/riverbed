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
offset = 0


function update_variables()
	dofile(os.getenv("HOME") .. '/.config/river-luatile/riverbed-autogen.lua')
end

function toggle_maximize()
	maximize = not maximize
end

function enter_overview()
	overview = true
end
function leave_overview()
	overview = false
end

function set_layout(input)
	if input ~= nil then
		layout = input
	end
end

function increase_offset()
	offset = offset + 1
end


function decrease_offset()
	offset = offset - 1
end

function set_offset(number)
	offset = number
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

		local side_w = args.width / 4 - gaps * 2
		local y = (args.height - side_w) / 2

		if (offset - 1) * -1 == args.count then
			offset = 1
		end
		if offset > 1 then
			offset = args.count * -1 + 2
		end

		for i = 0, (args.count - 1) do
			table.insert(retval, {
				(2 * gaps + side_w) * (i + offset) + gaps + side_w / 2,
				y,
				side_w,
				side_w,
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
	elseif layout == 'writing' then
		local main_w = (args.width - gaps * 3) * main_ratio
		local side_w = (args.width - gaps * 3) - main_w
		local main_h = args.height + bar_height - gaps * 2
		local side_h = (args.height - gaps * 2 - 100) / (args.count - 2) - gaps
		table.insert(retval, {
			gaps,
			gaps - bar_height,
			main_w,
			main_h,
		})
		if args.count > 1 then
			for i = 0, (args.count - 3) do
				table.insert(retval, {
					main_w + gaps * 2,
					gaps + i * (side_h + gaps),
					side_w,
					side_h,
				})
			end
			table.insert(retval, {
				main_w + gaps * 2,
				main_h - 100 - bar_height + gaps,
				side_w,
				100,
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
		local side_w = args.width / math.min(args.count, columns)
		local rows = math.ceil(args.count / columns)
		local remainder = args.count % rows
		local side_h = args.height / rows

		for i = 0, (args.count - 1) do
			if i >= (args.count - remainder) then
				side_h = args.height / remainder
			end

			table.insert(retval, {
				(side_w) * math.floor(i / rows) + gaps,
				(side_h) * (i % rows) + gaps,
				side_w - 2 * gaps,
				side_h - 2 * gaps,
			})
		end
	end
	return retval
end

function handle_metadata(args)
	return { name = "runoff" }
end
