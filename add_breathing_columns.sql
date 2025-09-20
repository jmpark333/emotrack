-- user_data 테이블에 호흡법 관련 컬럼 추가
ALTER TABLE user_data
ADD COLUMN IF NOT EXISTS daily_breathing_count INTEGER DEFAULT 0,
ADD COLUMN IF NOT EXISTS last_breathing_date TIMESTAMP WITH TIME ZONE;

-- 기존 데이터가 있다면 기본값 설정
UPDATE user_data
SET daily_breathing_count = 0,
    last_breathing_date = NULL
WHERE daily_breathing_count IS NULL
   OR last_breathing_date IS NULL;

-- 변경 사항 확인
SELECT column_name, data_type, column_default
FROM information_schema.columns
WHERE table_name = 'user_data'
  AND column_name IN ('daily_breathing_count', 'last_breathing_date')
ORDER BY column_name;