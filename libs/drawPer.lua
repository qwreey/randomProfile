local module = {};

local utf8 = require "utf8"
local rep = string.rep;
local floor = math.floor;
local tconcat = table.concat;
local ulen = utf8.len;
local max = math.max;

function module.drawPerbar(per,size)
	local barsize = (size-8)*per;
	local barsizePoint = barsize%1;
	local cut = floor(per*10000)/100;
	local cutPoint = #tostring(cut%1);
	local perText = tostring(cut) .. (cutPoint == 1 and ".00" or cutPoint == 3 and "0" or "");
	return tconcat{
		rep(" ",6 - #perText),perText,"% ",
		rep("█",floor(barsize)),
		(barsizePoint == 0 and "") or
		(barsizePoint > (7/8) and "▉") or
		(barsizePoint > (3/4) and "▊") or
		(barsizePoint > (5/8) and "▋") or
		(barsizePoint > (1/2) and "▌") or
		(barsizePoint > (3/8) and "▍") or
		(barsizePoint > (1/4) and "▎") or
		(barsizePoint > (1/8) and "▏") or " ",
		barsize == size and "" or (rep(" ",floor(size-barsize-8)))
	};
end
function module.drawPerbarWithBackground(per,size)
	local barsize = (size-7)*per;
	local barsizePoint = barsize%1;
	local cut = floor(per*10000)/100;
	local cutPoint = #tostring(cut%1);
	local perText = tostring(cut) .. (cutPoint == 1 and ".00" or cutPoint == 3 and "0" or "");
	return tconcat{
		rep(" ",6 - #perText),perText,"% ",
		rep("█",floor(barsize)),
		rep("░",floor(size-barsize-6.5))
	};
end
function module.drawPerbarWithFrame(title,per,size)
	size = max(size,8);
	local titlebarSize = (size-2)/2-(ulen(title)/2);
	return tconcat{
		"\n┌",rep("─",floor(titlebarSize+0.5)),
		title,rep("─",floor(titlebarSize)),"┐\n│",
		module.drawPerbar(per,size-2),
		"│\n└",rep("─",size-2),"┘"
    };
end
function module.drawPerbarWithFrameAndBackground(title,per,size)
	size = max(size,8);
	local titlebarSize = (size-2)/2-(ulen(title)/2);
	return tconcat{
		"\n┌",rep("─",floor(titlebarSize+0.5)),
		title,rep("─",floor(titlebarSize)),"┐\n│",
		module.drawPerbarWithBackground(per,size-2),
		"│\n└",rep("─",size-2),"┘"
    };
end
local clear = "\27[2K\r";
function module.clear()
    return clear;
end

return module;
