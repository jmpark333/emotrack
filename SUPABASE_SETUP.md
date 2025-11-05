# Supabase 설정 가이드

현재 Supabase 프로젝트가 삭제되었거나 접근할 수 없는 상태입니다. 다음 단계를 따라 새 프로젝트를 설정해주세요.

## 1단계: 새 Supabase 프로젝트 생성

1. [Supabase Dashboard](https://supabase.com/dashboard)에 로그인
2. **New Project** 버튼 클릭
3. 프로젝트 정보 입력:
   - **Organization**: 기존 조직 선택 또는 새로 생성
   - **Name**: `emotrack` (또는 원하는 이름)
   - **Database Password**: 안전한 비밀번호 생성 및 저장 (중요!)
   - **Region**: `Northeast Asia (Seoul)` 선택 (한국 사용자에게 최적)
   - **Pricing Plan**: Free tier로 시작
4. **Create new project** 클릭
5. 프로젝트 생성 대기 (약 2-3분 소요)

## 2단계: 데이터베이스 테이블 생성

1. 좌측 메뉴에서 **SQL Editor** 클릭
2. **New query** 클릭
3. `setup-database.sql` 파일의 내용을 복사하여 붙여넣기
4. **Run** 버튼 클릭하여 실행
5. 성공 메시지 확인

## 3단계: API 정보 확인

1. 좌측 메뉴에서 **Settings** → **API** 클릭
2. 다음 정보 복사:
   - **Project URL**: `https://xxxxxxxxxx.supabase.co`
   - **anon public** API key (긴 문자열)

## 4단계: 로컬 환경 변수 업데이트

프로젝트의 `.env` 파일을 다음과 같이 업데이트:

```env
SUPABASE_URL='https://xxxxxxxxxx.supabase.co'
SUPABASE_ANON_KEY='your-anon-key-here'
```

## 5단계: Netlify 환경 변수 설정

1. [Netlify Dashboard](https://app.netlify.com) 접속
2. `emotrack-app` 사이트 선택
3. **Site configuration** → **Environment variables** 클릭
4. 기존 환경 변수 수정 또는 새로 추가:

   **환경 변수 1:**
   - Key: `SUPABASE_URL`
   - Value: (3단계에서 복사한 Project URL)
   - Scopes: All scopes 선택

   **환경 변수 2:**
   - Key: `SUPABASE_ANON_KEY`
   - Value: (3단계에서 복사한 anon public key)
   - Scopes: All scopes 선택

5. **Save** 버튼 클릭

## 6단계: 사이트 재배포

### 방법 A: Netlify 대시보드에서

1. **Deploys** 탭으로 이동
2. **Trigger deploy** 버튼 클릭
3. **Clear cache and deploy site** 선택
4. 배포 완료 대기 (1-2분)

### 방법 B: Git으로 재배포

```bash
cd emotrack
git add .
git commit -m "Update Supabase configuration"
git push
```

Netlify가 자동으로 새 배포를 시작합니다.

## 7단계: Authentication 설정 (선택사항)

앱에서 회원가입을 허용하려면:

1. Supabase Dashboard에서 **Authentication** → **Providers** 클릭
2. **Email** provider가 활성화되어 있는지 확인
3. **Email Auth** 설정:
   - **Enable Email Confirmations**: OFF (개발 중에는 끄는 것을 권장)
   - 또는 SMTP 설정 구성

## 8단계: 테스트

1. 배포된 사이트 방문: https://emotrack-app.netlify.app
2. 브라우저 개발자 도구 열기 (F12)
3. Console 탭 확인
4. 회원가입 및 로그인 테스트

## 문제 해결

### 로그인이 여전히 실패하는 경우

1. 브라우저 캐시 완전 삭제:
   - Chrome/Edge: Ctrl + Shift + Delete → "Cached images and files" 선택
   - 또는 시크릿/프라이빗 모드로 테스트

2. Netlify 함수 로그 확인:
   - Netlify Dashboard → Functions → `get-supabase-config` 클릭
   - 최근 로그 확인

3. Supabase 프로젝트 상태 확인:
   - Supabase Dashboard에서 프로젝트가 "Active" 상태인지 확인
   - Database → Tables에서 테이블이 제대로 생성되었는지 확인

### "Failed to fetch" 에러가 계속 발생하는 경우

1. Supabase URL이 올바른지 확인:
   ```bash
   curl -I https://your-project-id.supabase.co
   ```
   → HTTP 200 또는 404 응답이 와야 함 (ERR_NAME_NOT_RESOLVED가 아님)

2. ANON KEY가 올바른지 확인 (공백이나 줄바꿈이 없어야 함)

3. Netlify 환경 변수가 실제로 적용되었는지 확인:
   - 브라우저에서 `https://emotrack-app.netlify.app/.netlify/functions/get-supabase-config` 방문
   - 환경 변수가 제대로 반환되는지 확인

## 참고 자료

- [Supabase Documentation](https://supabase.com/docs)
- [Netlify Environment Variables](https://docs.netlify.com/environment-variables/overview/)
- [Supabase Row Level Security](https://supabase.com/docs/guides/auth/row-level-security)

## 지원

문제가 계속되면 다음 정보를 포함하여 문의해주세요:
- 브라우저 Console 에러 메시지
- Netlify 함수 로그
- Supabase 프로젝트 상태