local http = require "coro-http" ---@module "deps.coro-http"
local random = require "libs.cRandom"
local url = require "libs.urlCode"
local json = require "json"
local fs = require "fs"
local prettyPrint = require "pretty-print"
local stdout = prettyPrint.stdout
local timer = require "timer"
local clock = os.clock
local drawPer = require "drawPer" ---@module "libs.drawper"

local clientData = json.decode(fs.readFileSync "clientData.json")
local header = {
    {"X-Naver-Client-Id",clientData.naverClientId};
    {"X-Naver-Client-Secret",clientData.naverClientSecret};
}
local maxRetry = 5
local maxItems = 15

local keywords = {
    "프사추천";
    "씹덕 프사 추천";
    "인스타 감성 프사 추천";
    "애니 프사 추천";
    "여캐 프사 추천";
    "남캐 프사 추천";
    "프사";
    "커플프사";
    "스누피 프사";
    "짱구 프사";
    "톰 프사";
    "제리 프사";
    "귀여운 프사 추천";
    "지브리 남주 프사";
    "연애프사";
    "지브리 여주 프사";
    "디즈니 공주 프사";
    "마이멜로디 프사";
    "프린세스 스타의 모험일기 프사";
    "마동석 프사";
    "캐릭터 프사";
    "인싸 프사";
    "웃긴 프사";
    "일코 프사";
    "훈이 프사";
    "짱아 프사";
    "훈이 프사";
    "잼민 프사";
    "크로니 프사";
    "중국 프사";
}
local lenKeywords = #keywords

local function req(retry)
    local keyword = keywords[random(1,lenKeywords)]
    local st = clock()
    local _,body = http.request("GET",
        ("https://openapi.naver.com/v1/search/image?query=%s&display=100&start=%d"):format(
            url.urlEncode(keyword),
            random(1,1000)
            -- url.urlEncode "김희걸",
        ),header
    )

    body = json.decode(body)
    if not body then
        error "Errored on decoding json from naver"
    end

    local items = body.items
    local pick = items[random(1,#items)]

    timer.sleep(110-(clock()-st));
    if (not pick) and ((not retry) or retry < maxRetry) then
        return req((retry or 0) + 1)
    end
    return pick,keyword
end

local items = {}
local drawPerbar = drawPer.drawPerbar
local clear = drawPer.clear()
for i=1,maxItems do
    stdout:write{clear,drawPerbar(i/maxItems,52)}
    items[i] = {req()}
end

stdout:write "\n--------------------- [ Private ] ---------------------\n"
for index,this in ipairs(items) do
    local item,keyword = this[1],this[2]
    if not item then
        stdout:write(("[%d] 검색 결과가 없음 . . . (키워드 : %s)\n"):format(index,keyword))
    else
        stdout:write(("[%d] `%s`||%s||\n"):format(index,item.link,keyword))
    end
end
stdout:write "\n--------------------- [ Public ] ----------------------\n"
local hider = "■"
local floor,insert,sub,gsub = math.floor,table.insert,string.sub,string.gsub
for index,this in ipairs(items) do
    local item,keyword = this[1],this[2]
    if not item then
        stdout:write(("[%d] 검색 결과가 없음 . . . (키워드 : %s)\n"):format(index,keyword))
    else
        local link = item.link
        local picked = {}
        local linkLen = #link
        for _ = 1,floor(linkLen/6) do
            local pick = random(2,linkLen-1,picked)
            insert(picked,pick)
            link = sub(link,1,pick-1) .. ":" .. sub(link,pick+1,-1)
        end
        stdout:write(("[%d] `%s`\n"):format(index,gsub(link,":",hider)))
    end
end
