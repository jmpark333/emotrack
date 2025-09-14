# Emotrack Byterover Handbook

## 목차
- [Layer 1: 시스템 개요](#layer-1-시스템-개요)
- [Layer 2: 모듈 맵](#layer-2-모듈-맵)
- [Layer 3: 통합 가이드](#layer-3-통합-가이드)
- [Layer 4: 확장 포인트](#layer-4-확장-포인트)

---

## Layer 1: 시스템 개요

### 프로젝트 목적
정서적 독립 트래커(Emotrack)는 매일의 정서적 독립 습관을 추적하고 관리하는 웹 기반 자기계발 애플리케이션입니다. 사용자가 감정 조절, 의사결정 독립성, 자기 확신 등 10가지 핵심 습관을 체계적으로 관리하도록 돕습니다.

### 기술 스택
- **프론트엔드**: HTML5, CSS3, Vanilla JavaScript (SPA)
- **데이터베이스**: Supabase (PostgreSQL) + Row Level Security (RLS)
- **인증**: Supabase Auth
- **스토리지**: 브라우저 캐시 제거 + 실시간 데이터베이스 동기화
- **스타일링**: CSS Grid, Flexbox, CSS Variables, 반응형 디자인
- **배포**: Netlify (자동 배포 + 캐시 제어 설정)
- **CDN**: jsDelivr (Supabase SDK)

### 아키텍처 패턴
**단일 파일 SPA (Single File SPA)**: 모든 로직이 하나의 HTML 파일에 포함된 모놀리식 아키텍처

- **클라이언트-사이드 렌더링**: 순수 JavaScript로 UI 제어
- **이벤트 드리븐 아키텍처**: 사용자 상호작용 기반 동작
- **실시간 데이터 동기화**: 모든 데이터 변경 즉시 데이터베이스 반영
- **오프라인 방지**: 엄격한 로그인 기반 데이터 접근
- **캐시 전략**: 브라우저 캐시 완전히 방지 (항상 최신 데이터)

### 주요 기술적 결정
1. **단일 파일 구조**: 배포 단순화 및 유지보수 용이성
2. **Supabase 통합**: 실시간 데이터 동기화 및 보안성 강화
3. **No 로컬 스토리지**: 데이터 무결성 및 일관성 보장
4. **엄격한 인증**: 로그인 없이는 모든 기능 비활성화
5. **반응형 UI**: 모바일 및 데스크톱 환경 모두 지원

---

## Layer 2: 모듈 맵

### 핵심 모듈

#### 1. 인증 모듈 (Authentication Module)
**파일 위치**: `index.html:700-920`
**책임**: 사용자 로그인/회원가입/세션 관리

**주요 함수**:
- `waitForSupabase()` - Supabase SDK 로딩 대기
- `login()` - 사용자 로그인 처리
- `signup()` - 회원가입 처리
- `logout()` - 로그아웃 처리
- `checkAuthState()` - 세션 상태 확인 및 자동 로그인

**의존성**: Supabase Auth SDK
**데이터 흐름**: 로그인 → 세션 확인 → 데이터 자동 로드

#### 2. 사용자 데이터 모듈 (User Data Module)
**파일 위치**: `index.html:1111-1400`
**책임**: 사용자 데이터 CRUD 및 동기화

**주요 함수**:
- `loadUserData()` - 사용자 데이터 로드
- `saveUserDataToSupabase()` - 데이터베이스에 저장
- `createNewUserData()` - 신규 사용자 데이터 생성
- `saveUserData()` - 데이터 저장 메인 함수

**의존성**: Supabase Client, 인증 모듈
**데이터 모델**: user_data 테이블 (레벨, 포인트, 연속일수 등)

#### 3. 감정 일기 모듈 (Emotion Diary Module)
**파일 위치**: `index.html:1074-1950`
**책임**: 감정 일기 CRUD 및 표시 관리

**주요 함수**:
- `loadDiaries()` - 일기 목록 로드
- `displayDiaries()` - 최근 3개 일기 표시
- `showAllDiaries()` - 모든 일기 표시 (더보기 기능)
- `saveDiary()` - 일기 저장
- `clearDiaries()` - 모든 일기 삭제

**특징**: 페이지네이션 없는 무한 스크롤 방식 (3개씩 표시 + 더보기)

#### 4. UI 업데이트 모듈 (UI Update Module)
**파일 위치**: `index.html:1393-1750`
**책임**: UI 상태 동기화 및 시각적 피드백

**주요 함수**:
- `updateUI()` - 전체 UI 업데이트
- `updateLevelProgress()` - 레벨 진행도 업데이트
- `updateDailyPoints()` - 일일 포인트 계산
- `updateStreak()` - 연속일수 계산
- `updateBadges()` - 보상 배지 업데이트

**의존성**: 사용자 데이터 모듈, DOM API

#### 5. 체크리스트 모듈 (Checklist Module)
**파일 위치**: `index.html:1750-1850`
**책임**: 일일 체크리스트 관리 및 진행도 추적

**주요 함수**:
- `handleCheck()` - 체크박스 변경 처리
- `updateProgress()` - 진행도 업데이트
- `checkDateChangeAndReset()` - 날짜 변경 감지 및 초기화

**데이터**: 10개 항목 정서적 독립 체크리스트

### 데이터 계층
- **user_data 테이블**: 사용자 기본 정보 (레벨, 포인트, 연속일수)
- **emotion_diaries 테이블**: 감정 일기 데이터 (타인행동, 내반응, 재해석)
- **Supabase RLS**: 사용자별 데이터 접근 제어

---

## Layer 3: 통합 가이드

### API 인터페이스

#### Supabase 인증 API
```javascript
// 로그인
const { data, error } = await supabaseClient.auth.signInWithPassword({
  email, password
});

// 회원가입
const { data, error } = await supabaseClient.auth.signUp({
  email, password
});

// 세션 확인
const { data: { session } } = await supabaseClient.auth.getSession();
```

#### 데이터베이스 API
```javascript
// 사용자 데이터 조회
const { data, error } = await supabaseClient
  .from('user_data')
  .select('*')
  .eq('user_id', currentUser.id)
  .single();

// 사용자 데이터 생성/업데이트
const { data, error } = await supabaseClient
  .from('user_data')
  .upsert([userData]);

// 감정 일기 조회
const { data, error } = await supabaseClient
  .from('emotion_diaries')
  .select('*')
  .eq('user_id', currentUser.id)
  .order('created_at', { ascending: false });
```

### 외부 통합

#### Supabase 설정
- **URL**: `https://hpejebnqhgojfxttfbal.supabase.co`
- **SDK 버전**: 2.39.7
- **인증 방식**: JWT 토큰
- **RLS 정책**: 사용자별 데이터 접근 제어

#### Netlify 배포 설정
```toml
[build]
publish = "."

# 캐시 방지 설정
[[headers]]
for = "/*.html"
[headers.values]
  Cache-Control = "no-cache, no-store, must-revalidate"

# SPA 라우팅
[[redirects]]
from = "/*"
to = "/index.html"
status = 200
```

### 구성 파일

#### 환경 변수 (코드 내 하드코딩)
```javascript
const supabaseUrl = 'https://hpejebnqhgojfxttfbal.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9...';
```

#### CSS 변수 (테마 설정)
```css
:root {
    --primary: #6C5CE7;    /* 주 색상 */
    --secondary: #A29BFE;  /* 보조 색상 */
    --success: #00B894;    /* 성공 색상 */
    --warning: #FDCB6E;    /* 경고 색상 */
    --danger: #FF7675;     /* 위험 색상 */
}
```

### 통합 지점
1. **인증 → 데이터 로드**: 로그인 성공 시 자동으로 사용자 데이터 로드
2. **체크리스트 → 보상 시스템**: 체크 완료 시 포인트 및 레벨 업데이트
3. **일기 저장 → UI 업데이트**: 일기 저장 후 최근 일기 목록 갱신
4. **날짜 변경 → 데이터 초기화**: 자정으로 넘어갈 때 일일 데이터 초기화

---

## Layer 4: 확장 포인트

### 디자인 패턴

#### 1. 모듈화된 함수 구조
```javascript
// 각 기능이 독립된 함수로 구현
async function loadUserData() { /* ... */ }
async function saveUserData() { /* ... */ }
function updateUI() { /* ... */ }
```

#### 2. 에러 핸들링 패턴
```javascript
try {
    const { data, error } = await supabaseClient.from(...);
    if (error) throw error;
    // 성공 처리
} catch (error) {
    console.error('오류:', error);
    // 사용자에게 알림
}
```

#### 3. 상태 관리 패턴
```javascript
// 전역 변수로 상태 관리
let currentUser = null;
let userData = {};
let diaries = [];
```

### 확장 영역

#### 1. 새로운 체크리스트 항목 추가
**위치**: `index.html` 내 `checklist` 배열
**확장 방법**: 배열에 새 항목 추가
```javascript
const checklist = [
    "감정 조절 연습",
    "의사결정 독립성",
    // ... 새 항목 추가 가능
    "자기 신뢰 구축"
];
```

#### 2. 새로운 보상 유형 추가
**위치**: `updateBadges()` 함수
**확장 방법**: 새로운 보상 조건 및 아이콘 추가
```javascript
if (completedCount === 5) {
    badges.push("🔥 5개 완료!");
}
```

#### 3. 감정 일기 필드 확장
**위치**: `emotion_diaries` 테이블 및 UI
**확장 방법**: 새 필드 추가 및 하위 호환성 유지
```sql
ALTER TABLE emotion_diaries ADD COLUMN new_field TEXT;
```

#### 4. 테마 커스터마이징
**위치**: CSS Variables
**확장 방법**: 색상 변수 수정
```css
:root {
    --primary: #새로운_색상;
    --secondary: #새로운_보조색상;
}
```

### 커스터마이징 전략

#### 데이터 기반 확장
- **새로운 통계 추가**: `userData` 객체에 새 필드 추가
- **새로운 일기 유형**: `emotion_diaries` 테이블에 카테고리 필드 추가
- **소셜 기능**: 사용자 간 상호작용을 위한 새 테이블 추가

#### UI 기반 확장
- **새로운 섹션 추가**: HTML에 새로운 div 섹션 추가
- **차트 및 시각화**: Chart.js 등 라이브러리 통합
- **알림 시스템**: 브라우저 알림 API 연동

#### 인증 기반 확장
- **소셜 로그인**: Google, GitHub OAuth 연동
- **역할 기반 접근**: 관리자/일반 사용자 구분
- **팀 기능**: 그룹별 데이터 관리

### 확장 시 고려사항
1. **하위 호환성**: 기존 데이터와의 호환성 유지
2. **RLS 정책**: 새 기능에 대한 접근 제어 정책 추가
3. **성능**: 대량 데이터 처리 시 최적화 고려
4. **보안**: 사용자 데이터 보안 및 프라이버시 보호

---

## 핸드북 생성 정보
- **생성일자**: 2025-09-14
- **프로젝트 버전**: v1.4.1
- **Byterover 버전**: 1.0
- **마지막 업데이트**: 로그인 성공 메시지 제거 및 감정 일기 더보기 기능 추가

## 변경 이력
- v1.4.1: 로그인 성공 메시지 완전히 제거, 브라우저 캐시 방지 강화
- v1.4.0: 인증 시스템 재설계, 데이터베이스 전용 전환
- v1.3.1: 연속일수 자동 계산 시스템 추가