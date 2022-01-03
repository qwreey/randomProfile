# HOW TO USE?

우선 네이버 Developers 에 들어가서 새로운 애플리케이션을 만들어 주세요  
`https://developers.naver.com/apps/#/register`  
(사용 API 에는 무조건 검색을 포함해야 합니다)  

그런 다음 클라이언트 아이디, 토큰(시크릿)을 복사해서 저장해 둡니다  

그런 다음 이 저장소를 다운로드 합니다, 위에 초록색 ZIP 다운로드 해도 상관 없고, git clone 해도 상관 없어요  

이제 다운받은 폴더 안에 `clientData.json` 이라는 json 파일을 만들어 줍니다, 연 다음에 이렇게 입력합니다  

```json
{
    "naverClientId": "발급받은ID",
    "naverClientSecret": "발급받은토큰"
}
```

저장해서 설정을 마치고 대충 cmd 와 같은 명령창을 연 뒤 윈도우 64 비트의 경우  
`bin\luvit app`
을 입력합니다. 다른 플랫폼의 경우 직접 luvit 을 얻어야 해요  
luvit 을 얻으려면 `https://github.com/truemedian/luvit-bin/releases` 여기를 확인해주시면 됩니다  

안드로이드의 경우 termux 위에서 `luvit-bin-Linux-aarch64.tar.gz` 파일 받아서 돌릴 수도 있습니다  

