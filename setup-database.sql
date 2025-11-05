-- emotrack 데이터베이스 초기 설정 스크립트
-- Supabase SQL Editor에서 실행하세요

-- 1. user_data 테이블 생성
CREATE TABLE IF NOT EXISTS user_data (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    streak INTEGER DEFAULT 0,
    level INTEGER DEFAULT 1,
    points INTEGER DEFAULT 0,
    last_check TIMESTAMPTZ,
    completed_today BOOLEAN DEFAULT FALSE,
    total_points INTEGER DEFAULT 0,
    start_date TIMESTAMPTZ DEFAULT NOW(),
    breathing_points INTEGER DEFAULT 0,
    last_breathing_time TIMESTAMPTZ,
    diaries JSONB DEFAULT '[]',
    last_attendance_date TIMESTAMPTZ,
    attendance_points INTEGER DEFAULT 0,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW(),
    UNIQUE(user_id)
);

-- 2. diaries 테이블 생성
CREATE TABLE IF NOT EXISTS diaries (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    other_person_action TEXT NOT NULL,
    my_reaction TEXT NOT NULL,
    reinterpretation TEXT NOT NULL,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 3. point_history 테이블 생성
CREATE TABLE IF NOT EXISTS point_history (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
    point_type TEXT NOT NULL,
    points INTEGER NOT NULL,
    description TEXT,
    created_at TIMESTAMPTZ DEFAULT NOW()
);

-- 4. RLS (Row Level Security) 활성화
ALTER TABLE user_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE diaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE point_history ENABLE ROW LEVEL SECURITY;

-- 5. user_data 테이블 RLS 정책
DROP POLICY IF EXISTS "Users can view own data" ON user_data;
CREATE POLICY "Users can view own data" ON user_data
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own data" ON user_data;
CREATE POLICY "Users can insert own data" ON user_data
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own data" ON user_data;
CREATE POLICY "Users can update own data" ON user_data
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own data" ON user_data;
CREATE POLICY "Users can delete own data" ON user_data
    FOR DELETE USING (auth.uid() = user_id);

-- 6. diaries 테이블 RLS 정책
DROP POLICY IF EXISTS "Users can view own diaries" ON diaries;
CREATE POLICY "Users can view own diaries" ON diaries
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own diaries" ON diaries;
CREATE POLICY "Users can insert own diaries" ON diaries
    FOR INSERT WITH CHECK (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can update own diaries" ON diaries;
CREATE POLICY "Users can update own diaries" ON diaries
    FOR UPDATE USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can delete own diaries" ON diaries;
CREATE POLICY "Users can delete own diaries" ON diaries
    FOR DELETE USING (auth.uid() = user_id);

-- 7. point_history 테이블 RLS 정책
DROP POLICY IF EXISTS "Users can view own history" ON point_history;
CREATE POLICY "Users can view own history" ON point_history
    FOR SELECT USING (auth.uid() = user_id);

DROP POLICY IF EXISTS "Users can insert own history" ON point_history;
CREATE POLICY "Users can insert own history" ON point_history
    FOR INSERT WITH CHECK (auth.uid() = user_id);

-- 8. 인덱스 생성 (성능 최적화)
CREATE INDEX IF NOT EXISTS idx_user_data_user_id ON user_data(user_id);
CREATE INDEX IF NOT EXISTS idx_diaries_user_id ON diaries(user_id);
CREATE INDEX IF NOT EXISTS idx_diaries_created_at ON diaries(created_at DESC);
CREATE INDEX IF NOT EXISTS idx_point_history_user_id ON point_history(user_id);
CREATE INDEX IF NOT EXISTS idx_point_history_created_at ON point_history(created_at DESC);

-- 9. updated_at 자동 업데이트 트리거 함수
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- 10. user_data 테이블에 트리거 적용
DROP TRIGGER IF EXISTS update_user_data_updated_at ON user_data;
CREATE TRIGGER update_user_data_updated_at
    BEFORE UPDATE ON user_data
    FOR EACH ROW
    EXECUTE FUNCTION update_updated_at_column();

-- 완료 메시지
DO $$
BEGIN
    RAISE NOTICE '데이터베이스 설정이 완료되었습니다!';
    RAISE NOTICE '테이블: user_data, diaries, point_history';
    RAISE NOTICE 'RLS 정책이 모든 테이블에 적용되었습니다.';
END $$;
