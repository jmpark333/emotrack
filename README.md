# 정서적 독립 트래커 (Emotional Independence Tracker)

![Version](https://img.shields.io/badge/version-1.0.0-blue.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)
![Platform](https://img.shields.io/badge/platform-web-lightgrey.svg)

매일의 정서적 독립 습관을 추적하고 관리하는 웹 기반 트래커 애플리케이션입니다. 자기계발을 위한 일상 체크리스트와 감정 일기를 통해 정서적 성장을 도와줍니다.

## 🚀 기능

### 주요 기능
- **일일 체크리스트**: 정서적 독립을 위한 10가지 핵심 습관 추적
- **진행률 시각화**: 실시간 진행 상황과 통계 제공
- **감정 일기**: 감정 변화와 성장 과정 기록
- **데이터 백업/복구**: 로컬 스토리지 기반 데이터 관리
- **날짜 변경 감지**: 자동으로 일일 데이터 초기화
- **보상 시스템**: 목표 달성 시 랜덤 보상 제공
- **호흡 명상**: 스트레스 관리를 위한 호흡 가이드

### 체크리스트 항목
1. 감정 조절 연습
2. 의사결정 독립성
3. 타인 의존도 점검
4. 자기 확신 훈련
5. 외부 영향력 분석
6. 자기 표현 연습
7. 감정적 경계 설정
8. 내적 가치 재확인
9. 의견 주장 훈련
10. 자기 신뢰 구축

## 🛠️ 기술 스택

- **프론트엔드**: HTML5, CSS3, Vanilla JavaScript
- **스토리지**: LocalStorage
- **스타일링**: CSS Grid, Flexbox, CSS Variables
- **디자인**: 반응형 웹 디자인
- **배포**: Netlify

## 📦 설치 방법

### 로컬에서 실행하기
1. 저장소 클론:
```bash
git clone https://github.com/jmpark333/emotrack.git
cd emotrack
```

2. 로컬 서버 실행:
```bash
# Python 3
python -m http.server 8000

# 또는 Node.js
npx http-server
```

3. 브라우저에서 `http://localhost:8000` 접속

## 🎯 사용법

### 체크리스트 사용
1. 각 항목의 체크박스를 클릭하여 완료 표시
2. 진행률은 자동으로 계산되어 표시됩니다
3. 모든 항목 완료 시 보상이 지급됩니다

### 감정 일기 작성
1. "감정 일기" 섹션에 오늘의 감정을 입력
2. "저장" 버튼 클릭하여 기록 저장
3. "일기 보기"로 과거 기록 확인 가능

### 데이터 관리
- **자동 저장**: 모든 변경사항은 자동으로 로컬에 저장됩니다
- **백업**: "데이터 백업" 버튼으로 현재 데이터 백업
- **복구**: "데이터 복구" 버튼으로 백업 데이터 복원

## 📱 배포 정보

- **라이브 사이트**: [https://emotrack-app.netlify.app](https://emotrack-app.netlify.app)
- **배포 방식**: Netlify 자동 배포
- **마지막 배포**: 2025-09-10

## 🗂️ 프로젝트 구조

```
emotrack/
├── index.html          # 메인 애플리케이션 파일
├── README.md           # 프로젝트 문서
├── .netlify/           # Netlify 설정 파일
└── .git/              # Git 버전 관리
```

## 🔧 커스터마이징

### 색상 테마 변경
`index.html` 파일의 CSS Variables 섹션에서 색상을 수정할 수 있습니다:

```css
:root {
    --primary: #6C5CE7;    /* 주 색상 */
    --secondary: #A29BFE;  /* 보조 색상 */
    --success: #00B894;    /* 성공 색상 */
    --warning: #FDCB6E;    /* 경고 색상 */
    --danger: #FF7675;     /* 위험 색상 */
}
```

### 체크리스트 항목 추가/수정
`checklist` 배열의 내용을 수정하여 체크리스트 항목을 변경할 수 있습니다.

## 📈 데이터 정책

- **데이터 저장**: 모든 데이터는 사용자의 브라우저 로컬 스토리지에 저장됩니다
- **개인정보**: 서버로 데이터가 전송되지 않아 개인정보가 보호됩니다
- **데이터 삭제**: 브라우저 데이터 삭제 시 모든 기록이 제거됩니다

## 🤝 기여

기여를 환영합니다! 다음 단계를 따라주세요:

1. 저장소를 포크합니다
2. 기능 브랜치를 생성합니다 (`git checkout -b feature/AmazingFeature`)
3. 변경사항을 커밋합니다 (`git commit -m 'Add some AmazingFeature'`)
4. 브랜치에 푸시합니다 (`git push origin feature/AmazingFeature`)
5. 풀 리퀘스트를 열어줍니다

## 📝 라이선스

이 프로젝트는 MIT 라이선스 하에 배포됩니다. 자세한 내용은 [LICENSE](LICENSE) 파일을 참조하세요.

## 🙏 감사

- 정서적 독립 개념을 제시한 심리학 연구에 감사드립니다
- 자기계발 커뮤니티의 지속적인 영감에 감사드립니다

## 📞 연락처

프로젝트 관리자 - [@jmpark333](https://github.com/jmpark333)

프로젝트 링크: [https://github.com/jmpark333/emotrack](https://github.com/jmpark333/emotrack)

라이브 데모: [https://emotrack-app.netlify.app](https://emotrack-app.netlify.app)

---

⭐ 이 프로젝트가 마음에 드셨다면 스타를 눌러주세요!