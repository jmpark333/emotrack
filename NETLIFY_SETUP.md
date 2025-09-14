# Netlify 환경 변수 설정 가이드

## 설정 방법

### 1. Netlify Dashboard 접속
1. [Netlify](https://app.netlify.com/) 로그인
2. 해당 사이트 선택
3. "Site settings" 클릭

### 2. Environment Variables 설정
1. "Build & deploy" 탭 → "Environment" 섹션
2. "Edit variables" 클릭
3. 다음 변수 추가:

#### **필수 변수**
- **Key**: `SUPABASE_URL`
- **Value**: `https://hpejebnqhgojfxttfbal.supabase.co`

- **Key**: `SUPABASE_ANON_KEY`
- **Value**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhwZWplYm5xaGdvamZ4dHRmYmFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3NTA4MTIsImV4cCI6MjA3MzMyNjgxMn0.AibxZdVe1INo5e3voeA6lVkdI9nY46_MuWJWFl2_JAg`

### 3. 배포 설정 변경
1. "Build settings" → "Build command" 확인
2. 환경 변수가 적용되도록 **Redeploy** 실행

### 4. 확인 방법
- 배포 후 브라우저 개발자 도구에서 네트워크 요청 확인
- API 키가 더 이상 코드에 노출되지 않아야 함

## 보안 주의사항

✅ **완료**: API 키가 코드에서 완전히 제거되었습니다.
- 이제 환경 변수 없이는 앱이 작동하지 않습니다
- 개발 환경에서도 Netlify 환경 변수가 필요합니다
- .env.local 파일을 사용하지 않습니다

## CLI를 통한 설정 (선택사항)

```bash
# Netlify CLI 설치
npm install -g netlify-cli

# 로그인
netlify login

# 환경 변수 설정
netlify env:set SUPABASE_URL "https://hpejebnqhgojfxttfbal.supabase.co"
netlify env:set SUPABASE_ANON_KEY "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhwZWplYm5xaGdvamZ4dHRmYmFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3NTA4MTIsImV4cCI6MjA3MzMyNjgxMn0.AibxZdVe1INo5e3voeA6lVkdI9nY46_MuWJWFl2_JAg"

# 배포
netlify deploy --prod
```