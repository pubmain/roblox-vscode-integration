local HttpService = game:GetService("HttpService")
local SERVER_PORT = 25822
local HOST_NAME = "localhost"
local PATH_PREFIX = "@vscode/"

local ReadFile = readfile
getgenv().readfile = newcclosure(function(path: string)
	assert(typeof(path) == "string", "path must be a string")
	if path:sub(1, #PATH_PREFIX) ~= PATH_PREFIX then
		return ReadFile(path)
	end
	path = path:sub(#PATH_PREFIX, -1)

	local Response = request({
		Url = `http://{HOST_NAME}:{SERVER_PORT}/readfile`,
		Method = "POST",
		Body = path,
	})

	if not Response.Success then
		error(Response.Body)
	end

	return Response.Body
end)

local WriteFile = writefile
getgenv().writefile = newcclosure(function(path: string, contents: string)
	assert(typeof(path) == "string", "path must be a string")
	assert(typeof(contents) == "string", "contents must be a string")
	if path:sub(1, #PATH_PREFIX) ~= PATH_PREFIX then
		return WriteFile(path, contents)
	end
	path = path:sub(#PATH_PREFIX, -1)

	local Response = request({
		Url = `http://{HOST_NAME}:{SERVER_PORT}/writefile`,
		Method = "POST",
		Body = HttpService:JSONEncode({
			path = path,
			contents = contents,
		}),
	})

	if not Response.Success then
	end

	return Response.Body
end)

local IsFile = isfile
getgenv().isfile = newcclosure(function(path: string)
	assert(typeof(path) == "string", "path must be a string")
	if path:sub(1, #PATH_PREFIX) ~= PATH_PREFIX then
		return IsFile(path)
	end
	path = path:sub(#PATH_PREFIX, -1)

	local Response = request({
		Url = `http://{HOST_NAME}:{SERVER_PORT}/isfile`,
		Method = "POST",
		Body = path,
	})

	if not Response.Success then
		error(Response.Body)
	end

	return Response.Body == "true"
end)

local IsFolder = isfolder
getgenv().isfolder = newcclosure(function(path: string)
	assert(typeof(path) == "string", "path must be a string")
	if path:sub(1, #PATH_PREFIX) ~= PATH_PREFIX then
		return IsFolder(path)
	end
	path = path:sub(#PATH_PREFIX, -1)

	local Response = request({
		Url = `http://{HOST_NAME}:{SERVER_PORT}/isfolder`,
		Method = "POST",
		Body = path,
	})

	if not Response.Success then
		error(Response.Body)
	end

	return Response.Body == "true"
end)

local ListFiles = listfiles
-- FIX: doing "PREFIX" doesnt work idk why :sob:
getgenv().listfiles = newcclosure(function(path: string)
	assert(typeof(path) == "string", "path must be a string")
	if path:sub(1, #PATH_PREFIX) ~= PATH_PREFIX then
		return ListFiles(path)
	end
	path = path:sub(#PATH_PREFIX, -1)

	local Response = request({
		Url = `http://{HOST_NAME}:{SERVER_PORT}/listfiles`,
		Method = "POST",
		Body = path,
	})

	if not Response.Success then
		error(Response.Body)
	end

	return HttpService:JSONDecode(Response.Body)
end)
