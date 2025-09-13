// Supabase 디버깅 스크립트
// 브라우저 콘솔에서 실행

const supabaseUrl = 'https://hpejebnqhgojfxttfbal.supabase.co';
const supabaseKey = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImhwZWplYm5xaGdvamZ4dHRmYmFsIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc3NTA4MTIsImV4cCI6MjA3MzMyNjgxMn0.AibxZdVe1INo5e3voeA6lVkdI9nY46_MuWJWFl2_JAg';

console.log('=== Supabase 디버깅 시작 ===');

// 1. 클라이언트 생성
try {
    const supabaseClient = supabase.createClient(supabaseUrl, supabaseKey);
    console.log('✅ Supabase 클라이언트 생성 성공');

    // 2. 인증 상태 확인
    supabaseClient.auth.getSession().then(({ data, error }) => {
        if (error) {
            console.error('❌ 인증 상태 확인 오류:', error.message);
        } else {
            console.log('📋 인증 상태:', data.session ? '로그인됨' : '로그인되지 않음');
        }
    });

    // 3. 프로젝트 정보 확인
    supabaseClient.from('user_data').select('count', { count: 'exact', head: true }).then(({ data, error }) => {
        if (error) {
            console.error('❌ 데이터베이스 연결 오류:', error.message);
            console.error('상세 오류:', error);
        } else {
            console.log('✅ 데이터베이스 연결 성공');
            console.log('📊 전체 사용자 수:', data.count);
        }
    });

    // 4. 테스트 회원가입
    console.log('📝 테스트 회원가입 준비...');
    console.log('사용할 이메일: test@example.com');
    console.log('사용할 비밀번호: test1234');

} catch (err) {
    console.error('❌ 치명적 오류:', err.message);
}

console.log('=== 디버깅 스크립트 완료 ===');
console.log('회원가입 테스트를 하려면 다음을 실행하세요:');
console.log('supabaseClient.auth.signUp({ email: "test@example.com", password: "test1234" })');