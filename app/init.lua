local http = require "coro-http" ---@module "deps.coro-http"
local random = require "libs.cRandom"
local url = require "libs.urlCode"
local json = require "json"
local fs = require "fs"
local prettyPrint = require "pretty-print"
local stdout = prettyPrint.stdout

local clientData = json.decode(fs.readFileSync "clientData.json")

local function req()
    local _,body = http.request("GET",
        ("https://openapi.naver.com/v1/search/image?query=%s&display=100&start=%d"):format(
            url.urlEncode "프사추천",
            random(1,200)
        ),{
            {"X-Naver-Client-Id",clientData.naverClientId};
            {"X-Naver-Client-Secret",clientData.naverClientSecret};
        }
    )

    body = json.decode(body)
    if not body then
        error "Errored on decoding json from naver"
    end

    local items = body.items
    local pick = items[random(1,#items)]

    return pick
end

for i=1,20 do
    stdout:write{("[%d] '"):format(i),req().link,"'\n"}
end
