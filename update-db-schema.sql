-- 데이터베이스 스키마 업데이트 스크립트
-- Supabase SQL Editor에서 실행하세요

-- 1. diaries 필드 추가 (JSONB 타입)
ALTER TABLE user_data ADD COLUMN IF NOT EXISTS diaries JSONB DEFAULT '[]';

-- 2. breathing_points 필드 추가 (INTEGER 타입)
ALTER TABLE user_data ADD COLUMN IF NOT EXISTS breathing_points INTEGER DEFAULT 0;

-- 3. 업데이트 확인
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'user_data'
AND column_name IN ('diaries', 'breathing_points')
ORDER BY column_name;