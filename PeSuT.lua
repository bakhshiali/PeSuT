-- PeSuT.lua -- VLC extension --
--[[
-- 
INSTALLATION:
	Paste the file (PeSuT.lua) in the VLC sub-direction /lua/extensions
	Default roots in defferent OS:
	* Windows (all users): %ProgramFiles%\VideoLAN\VLC\lua\extensions\
	* Windows (current user): %APPDATA%\VLC\lua\extensions\
	* Linux (all users): /usr/share/vlc/lua/extensions/
	* Linux (current user): ~/.local/share/vlc/lua/extensions/
	* Mac OS X (all users): /Applications/VLC.app/Contents/MacOS/share/lua/extensions/
	
	note: create directories if it don't exist! & Restart the VLC!
	Run: Open VLC-->View--> مترجم زیرنویس فارسی and select it.
	Enable extension to translate current english subtitle.
	Subtitle file name should be the same as movie name.srt.
	note: to avoid any crashing, run extension & close the vlc; the background vlc will translate the subtitle and
	the *-fa.srt will get larger in size; after a while the translation is done and the file size won't change anymore;
	there run the vlc and watch the movie with the translated subtitle in the same folder!
	
--]]
--
SOURCE_LANG = "en"  -- source langauge
TARGET_LANG = "fa"  -- target language
translator = "google" -- google
osd_duration = 15   -- messages duration
osd_position = "top-left"
-------------------------------------------------
TAG = "TRANS" -- for debugging purposes
-- storage for parsed subtitles
megatable = {}
-- descripttion
function descriptor()
    return {
        title = "PeSuT";
        version = "1.0";
        author = "Ali Bakhshi";
        shortdesc = "مترجم زیرنویس فارسی";
        capabilities = {"input-listener"}
    }
end

function activate()
	--find video name
    film= vlc.input.item():uri()
    film= vlc.strings.decode_uri( film )
	--find english subtitle with the same name +.srt
    fileName = string.gsub( string.gsub( string.gsub(film, "^(.+)%.%w+$", "%1") ,"%%20"," "),"file://","")..".srt"
	--in windows: remove "/" as a first char
	fileName = fileName:sub(2)
	--_log(fileName)
	--load subtitle and extract the data
    megatable = load_srt( fileName )
	--log the subtitle table size 
	_log("Subtitle frames: ".. #megatable)
	--create and clear target file
	name = string.gsub( string.gsub( string.gsub(film, "^(.+)%.%w+$", "%1") ,"%%20"," "),"file://",""):sub(2)
	--print(name)
	local f = io.open(name.."-"..TARGET_LANG..".srt", "w")
    f:write("")
    f:close()
	--load every text and time from tables; tranlate the texts and save
	for i,v in ipairs(megatable) do
		for j,b in ipairs(v) do
			if j%2==1 then
				savefile(i,name)
				savefile(b,name)
				print(b)
			else
				savefile(translate(b).."\n",name)
			end
		end
	end
	--show finished when completed; note: it's better to clode the vlc and wait until the size of the *-fa.srt is not changing anymore!
	vlc.osd.message("finished", channel1, osd_position, osd_duration*1000*1000)
end

function savefile(pass,name)
	--write data in append mode
	local f = io.open(name.."-"..TARGET_LANG..".srt", "a")
    if f == nil then
        _log("Could not load : "..subfile )
        return false
    end
	
    local con = f:write(pass.."\n")
    f:close()
end

function load_srt(subfile)
--load srt file
    _log(subfile)
    local f = io.open(subfile, "r")
    if f == nil then
        _log("Could not load : "..subfile )
        return false
    end
	--read all lines
    local contents = f:read("*all")
    f:close()
	--inform the google length limits and subtitile texts
	_log("Google translator length limit: 5000 char")
	length = string.len(contents)
    _log("Subtitle length: ".. length)
	--try to parse the subtitle text
	local line = nil
    local k=0
    local table={}
    local a
    local hasTime
    local sourceSubtitle

    local p1 = 1
    local p2
    while 1 do
        --_log("k="..k)
        p2 = string.find(contents,'\n',p1)
        --_log(p2)
        if p2 == nil then
            --_log("break")
            break
        end

        line = string.sub(contents,p1,p2-1)
        p1 = p2+1
        if line ~= nil then
            -- --> subtitle appear time
            a=string.find(line, "%-%-%>")
        end
        -- body of subtitle
        if a == nil then 
            if tonumber(line)~=nil then 
            elseif line == nil or string.len(line) <= 1 then
                if hasTime == 1  then
                    if sourceSubtitle ~= nil then
                        storeSubtitle = sourceSubtitle
                    end
                    -- push subtitle to the table
                    if storeSubtitle ~= nil then
                        table[k] = {times, storeSubtitle}
                    end
                    sourceSubtitle = nil
                    hasTime = 0
                end
            else 
                if sourceSubtitle == nil then
                    sourceSubtitle = string.lower(line)
                else
                    sourceSubtitle = sourceSubtitle.." "..string.lower(line)
                end
            end
        -- parse subtitle start/end time
        else
            times=line
            k = k + 1
            hasTime = 1
        end
    end
    --push last subtitle to table
    if sourceSubtitle ~= nil then
        storeSubtitle = sourceSubtitle
    end
    if storeSubtitle ~= nil then
        table[k] = {times, storeSubtitle}
    end
    return table
end

function translate(pass)
--translate srt content using google translate
	if (translator == "google") then
        url = "https://translate.google.com/m?sl="..SOURCE_LANG.."&tl="..TARGET_LANG.."&q="..vlc.strings.encode_uri_component(pass).."&op=translate"
	end
	--get and parse the url html data
	data=parse_json(url)
    -- find results (translated sentences)
    if ( translator == "google" ) then
        out = string.match( data, 'result%-container">.-</div>' )
		out = string.match( out, '>.-<' ):sub(2,-2)
		--we can show translated subtitle at the same time but the VLC would crash!
		--vlc.osd.message(out, channel1, osd_position, osd_duration*1000*1000)
	else
        out = data
    end
	return out
end

function parse_json(url)
--use dkjson from vlc
	local json   = require("dkjson")
	local stream = vlc.stream(url)
	local str = ""
	local line   = ""
	if not stream then
		return nil, nil, "Failed creating VLC stream"
	end
	while true do
		line = stream:readline()

		if not line then
			break
		end

		str = str .. line
	end
	return str
end

function _log(m)
--log events, different from print
    vlc.msg.info( "[".. TAG .."] ".. m )
end

function deactivate()
--deactivate the extension
    _log("========= deactivated")
end

function close()
	--close event: run deactivate function
    vlc.deactivate()
end
