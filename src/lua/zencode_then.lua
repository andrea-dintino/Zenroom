-- This file is part of Zenroom (https://zenroom.dyne.org)
--
-- Copyright (C) 2018-2019 Dyne.org foundation
-- designed, written and maintained by Denis Roio <jaromil@dyne.org>
--
-- This program is free software: you can redistribute it and/or modify
-- it under the terms of the GNU Affero General Public License as
-- published by the Free Software Foundation, either version 3 of the
-- License, or (at your option) any later version.
--
-- This program is distributed in the hope that it will be useful,
-- but WITHOUT ANY WARRANTY; without even the implied warranty of
-- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
-- GNU Affero General Public License for more details.
--
-- You should have received a copy of the GNU Affero General Public License
-- along with this program.  If not, see <https://www.gnu.org/licenses/>.

--- THEN

--------------------------------------

Then("print ''", function(k)
		local fun
		local val = ACK[k]
		if val then
		   fun = guess_outcast( check_codec(k) )
		   if luatype(val) == 'table' then
			  OUT[k] = deepmap(fun, val)
		   else
			  OUT[k] = fun(val)
		   end
		else
		   if not OUT.output then OUT.output = { } end
		   table.insert(OUT.output,k) -- raw string value
		end
end)

Then("print '' as ''", function(v,s)
		local fun = guess_outcast(s)
		local val = ACK[v]
		if val then
			if luatype(val) == 'table' then
				OUT[v] = deepmap(fun, val)
			else
				OUT[v] = fun(val)
			end
		else
		   OUT.output = fun(v)
		end
end)


Then("print '' as '' in ''", function(v,s,k)
		local fun = guess_outcast(s)
		local val = ACK[v]
		if val then
		   if luatype(val) == 'table' then
			  OUT[k] = deepmap(fun, val)
		   else
			  OUT[k] = fun(val)
		   end
		else
		   OUT[k] = fun(v)
		end
end)

Then("print data", function()
		local fun
		for k,v in pairs(ACK) do
		   fun = guess_outcast( check_codec(k) )
		   if luatype(v) == 'table' then
			  OUT[k] = deepmap(fun, v)
		   else
			  OUT[k] = fun(v)
		   end
		end
end)

Then("print data as ''", function(e)
		local fun
		for k,v in pairs(ACK) do
		   fun = guess_outcast( e )
		   if luatype(v) == 'table' then
			  OUT[k] = deepmap(fun, v)
		   else
			  OUT[k] = fun(v)
		   end
		end
end)

Then("print my data", function()
		Iam() -- sanity checks
		local fun
		OUT[WHO] = { }
		for k,v in pairs(ACK) do
		   fun = guess_outcast( check_codec(k) )
		   if luatype(v) == 'table' then
			  OUT[WHO][k] = deepmap(fun, v)
		   else
			  OUT[WHO][k] = fun(v)
		   end
		end
end)

Then("print my data as ''", function(s)
		Iam() -- sanity checks
		local fun
		OUT[WHO] = { }
		for k,v in pairs(ACK) do
		   fun = guess_outcast( s )
		   if luatype(v) == 'table' then
			  OUT[WHO][k] = deepmap(fun, v)
		   else
			  OUT[WHO][k] = fun(v)
		   end
		end
end)

---------- checked until here

Then("print my ''", function(obj)
		Iam()
		ZEN.assert(ACK[obj], "Data object not found: "..obj)
		if not OUT[WHO] then OUT[WHO] = { } end
		local fun = guess_outcast( check_codec(obj) )
		OUT[WHO][obj] = ACK[obj]
		if luatype(OUT[WHO][obj]) == 'table' then
		   OUT[WHO][obj] = deepmap(fun, OUT[WHO][obj])
		else
		   OUT[WHO][obj] = fun(OUT[WHO][obj])
		end
end)

Then("print my '' from ''", function(obj, section)
		Iam()
		ZEN.assert(ACK[section], "Section not found: "..section)
		local got
		got = ACK[section][obj]
		ZEN.assert(got, "Data object not found: "..obj)
		local fun = guess_outcast( check_codec(obj) )
		if luatype(got) == 'table' then
		   got = deepmap(fun, got)
		else
		   got  = fun(got)
		end
		if not OUT[WHO] then OUT[WHO] = { } end
		OUT[WHO][obj] = got
end)

Then("print my '' as ''", function(obj,conv)
		Iam()
		ZEN.assert(ACK[obj], "My data object not found: "..obj)
		if not OUT[WHO] then OUT[WHO] = { } end
		local fun = guess_outcast(conv)
		OUT[WHO][obj] = ACK[obj]
		if luatype(OUT[WHO][obj]) == 'table' then
		   OUT[WHO][obj] = deepmap(fun, OUT[WHO][obj])
		else
		   OUT[WHO][obj] = fun(OUT[WHO][obj])
		end
end)

Then("print the ''", function(key)
		ZEN.assert(ACK[key], "Data object not found: "..key)
		if not OUT[key] then OUT[key] = { } end
		OUT[key] = ACK[key]
		local fun = guess_outcast( check_codec(key) )
		if luatype(OUT[key]) == 'table' then
		   OUT[key] = deepmap(fun, OUT[key])
		else
		   OUT[key] = fun(OUT[key])
		end
end)

Then("print the '' as ''", function(key, conv)
		ZEN.assert(ACK[key], "Data object not found: "..key)
		if not OUT[key] then OUT[key] = { } end
		OUT[key] = ACK[key]
		local fun = guess_outcast(conv)
		if luatype(OUT[key]) == 'table' then
		   OUT[key] = deepmap(fun, OUT[key])
		else
		   OUT[key] = fun(OUT[key])
		end
end)

Then("print the '' as '' in ''", function(key, conv, section)
		ZEN.assert(ACK[section][key], "Data object not found: "..key.." inside "..section)
		if not OUT[key] then OUT[key] = { } end
		OUT[key] = ACK[section][key]
		local fun = guess_outcast(conv)
		if luatype(OUT[key]) == 'table' then
		   OUT[key] = deepmap(fun, OUT[key])
		else
		   OUT[key] = fun(OUT[key])
		end
end)

Then("print the '' in ''", function(key, section)
		ZEN.assert(ACK[section][key], "Data object not found: "..key.." inside "..section)
		if not OUT[key] then OUT[key] = { } end
		OUT[key] = ACK[section][key]
		local fun = guess_outcast( check_codec(section) )
		if luatype(OUT[key]) == 'table' then
		   OUT[key] = deepmap(fun, OUT[key])
		else
		   OUT[key] = fun(OUT[key])
		end
end)

