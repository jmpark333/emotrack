# Supabase 설정 가이드

이 문서는 정서적 독립 트래커 앱에 Supabase를 연동하는 방법을 안내합니다.

## 1. Supabase 프로젝트 생성

1. [Supabase](https://supabase.com)에 접속하여 회원가입 또는 로그인합니다.
2. "New Project"를 클릭하여 새 프로젝트를 생성합니다.
3. 프로젝트 정보를 입력합니다:
   - **Organization**: 조직 이름 선택
   - **Name**: 프로젝트 이름 (예: `emotrack`)
   - **Database Password**: `EsXUooz1q8jGMSVF` (제공된 비밀번호 사용)
   - **Region**: 가까운 지역 선택 (예: South Korea)
4. "Create new project"를 클릭합니다.

## 2. Database URL과 API Key 가져오기

프로젝트가 생성되면:

1. 프로젝트 대시보드에서 **Settings** → **API**로 이동합니다.
2. **Project URL**과 **service_role** 또는 **anon** public key를 복사합니다.
   - **URL**: `https://xxxxxxxx.supabase.co` 형식
   - **anon key**: `eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...` 형식

## 3. user_data 테이블 생성

SQL Editor에서 다음 SQL을 실행하여 사용자 데이터 테이블을 생성합니다:

```sql
-- user_data 테이블 생성
CREATE TABLE user_data (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    streak INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    points INTEGER DEFAULT 0,
    last_check TIMESTAMP,
    completed_today TEXT[] DEFAULT '{}',
    total_points INTEGER DEFAULT 0,
    start_date DATE,
    last_completed_date DATE,
    diaries JSONB DEFAULT '[]',
    breathing_points INTEGER DEFAULT 0,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),

    UNIQUE(user_id)
);

-- RLS (Row Level Security) 활성화
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;

-- 사용자 자신의 데이터만 읽을 수 있는 정책
CREATE POLICY "Users can view own data"
ON user_data FOR SELECT
USING (auth.uid() = user_id);

-- 사용자 자신의 데이터만 삽입할 수 있는 정책
CREATE POLICY "Users can insert own data"
ON user_data FOR INSERT
WITH CHECK (auth.uid() = user_id);

-- 사용자 자신의 데이터만 업데이트할 수 있는 정책
CREATE POLICY "Users can update own data"
ON user_data FOR UPDATE
USING (auth.uid() = user_id);

-- updated_at 자동 업데이트 트리거
CREATE OR REPLACE FUNCTION handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER handle_user_data_updated_at
    BEFORE UPDATE ON user_data
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();

-- 기존 테이블에 필드 추가 (이미 테이블이 있는 경우)
ALTER TABLE user_data ADD COLUMN IF NOT EXISTS breathing_points INTEGER DEFAULT 0;

-- 감정 일기 전용 테이블 생성
CREATE TABLE IF NOT EXISTS emotion_diaries (
    id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    wife_action TEXT NOT NULL,
    my_reaction TEXT NOT NULL,
    reinterpretation TEXT NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- RLS (Row Level Security) 활성화
ALTER TABLE emotion_diaries ENABLE ROW LEVEL SECURITY;

-- 일기 테이블 정책 생성
CREATE POLICY "Users can view own diaries"
ON emotion_diaries FOR SELECT
USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own diaries"
ON emotion_diaries FOR INSERT
WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own diaries"
ON emotion_diaries FOR UPDATE
USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own diaries"
ON emotion_diaries FOR DELETE
USING (auth.uid() = user_id);

-- created_at 자동 업데이트 트리거
CREATE TRIGGER handle_emotion_diaries_updated_at
    BEFORE UPDATE ON emotion_diaries
    FOR EACH ROW
    EXECUTE FUNCTION handle_updated_at();
```

## 4. 앱에 Supabase 설정 적용

`index.html` 파일에서 다음 부분을 찾아 수정합니다:

```javascript
// 이 부분을 찾아서:
/*
const supabaseUrl = 'YOUR_SUPABASE_URL';
const supabaseKey = 'YOUR_SUPABASE_KEY';
const supabaseClient = supabase.createClient(supabaseUrl, supabaseKey);
*/

// 이렇게 수정 (주석 해제 및 실제 값으로 변경):
const supabaseUrl = 'https://xxxxxxxx.supabase.co'; // 복사한 URL로 변경
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...'; // 복사한 키로 변경
const supabaseClient = supabase.createClient(supabaseUrl, supabaseKey);
```

## 5. 이메일 인증 설정 (선택사항)

1. **Authentication** → **Settings**로 이동합니다.
2. **Site URL**을 앱의 URL로 설정합니다 (로컬 개발 시 `http://localhost` 또는 Netlify URL).
3. **Email Templates**에서 이메일 내용을 원하는 대로 커스터마이징할 수 있습니다.

## 6. 테스트

1. 앱을 열고 "로그인/회원가입" 버튼을 클릭합니다.
2. 회원가입을 테스트합니다.
3. 로그인을 테스트합니다.
4. 데이터가 정상적으로 저장되고 로드되는지 확인합니다.

## 주의사항

- **보안**: API 키를 공개 저장소에 커밋하지 마세요. 환경 변수 사용을 권장합니다.
- **백업**: 정기적으로 데이터베이스를 백업하세요.
- **RLS**: Row Level Security가 올바르게 설정되었는지 확인하세요.
- **지역**: 사용자와 가까운 지역을 선택하여 응답 속도를 최적화하세요.

## 문제 해결

### 이메일 인증이 오지 않을 경우
1. Supabase 대시보드의 Authentication → Settings에서 Site URL을 확인합니다.
2. 스팸 메일함을 확인합니다.
3. 이메일 템플릿을 확인합니다.

### CORS 오류가 발생할 경우
1. Authentication → Settings에서 Redirect URLs에 앱 URL을 추가합니다.
2. `http://localhost:3000` (개발 환경)
3. `https://your-app.netlify.app` (프로덕션 환경)

### 데이터 저장 오류가 발생할 경우
1. RLS 정책이 올바르게 설정되었는지 확인합니다.
2. 사용자가 로그인되어 있는지 확인합니다.
3. 콘솔에서 오류 메시지를 확인합니다.