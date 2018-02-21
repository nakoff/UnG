--Run Time
millisecs	= 0.0
secs		= 0
timer 	= 0

function Millisecs()
	millisecs = millisecs + 1
	if millisecs >=60 then
		secs = secs + 1
		millisecs = 0
		energy = energy+1
		setText(energyt,"ENERGY = "..energy)
	end
end