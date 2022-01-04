local http = require "coro-http" ---@module "deps.coro-http"
local random = require "libs.cRandom"
local url = require "libs.urlCode"
local json = require "json"
local fs = require "fs"
local prettyPrint = require "pretty-print"
local stdout = prettyPrint.stdout
local timer = require "timer"
local clock = os.clock

local clientData = json.decode(fs.readFileSync "clientData.json")
local header = {
    {"X-Naver-Client-Id",clientData.naverClientId};
    {"X-Naver-Client-Secret",clientData.naverClientSecret};
}
local maxRetry = 5

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
    "와꾸 프사";
    "웃긴 프사";
    "괜찮은 프사";
    "일코 프사";
    "훈이 프사";
    "짱아 프사";
    "훈이 프사";
    "오토코노코 프사";
    "잼민 프사";
    "크로니 프사";
    "제로투 프사";
    "박진영 남친짤";
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

for i=1,20 do
    local item,keyword = req()
    if not item then
        stdout:write(("[%d] 검색 결과가 없음 . . . (키워드 : %s)\n"):format(i,keyword))
    else
        stdout:write(("[%d] %s\n"):format(i,item.link))
    end
end
