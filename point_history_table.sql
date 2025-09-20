-- 포인트 내역 테이블 생성 SQL
CREATE TABLE point_history (
    id BIGSERIAL PRIMARY KEY,
    user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE,
    point_type VARCHAR(50) NOT NULL,
    points INTEGER NOT NULL,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    description TEXT
);

-- 인덱스 생성
CREATE INDEX idx_point_history_user_id ON point_history(user_id);
CREATE INDEX idx_point_history_created_at ON point_history(created_at);
CREATE INDEX idx_point_history_user_created ON point_history(user_id, created_at);

-- RLS (Row Level Security) 정책 활성화
ALTER TABLE point_history ENABLE ROW LEVEL SECURITY;

-- 사용자는 자신의 포인트 내역만 볼 수 있음
CREATE POLICY "Users can view their own point history" ON point_history
    FOR SELECT USING (auth.uid() = user_id);

-- 사용자는 자신의 포인트 내역만 추가할 수 있음
CREATE POLICY "Users can insert their own point history" ON point_history
    FOR INSERT WITH CHECK (auth.uid() = user_id);