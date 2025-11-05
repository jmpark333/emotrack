#!/bin/bash

# Supabase 환경 변수 업데이트 스크립트

# 새로운 Supabase URL
NEW_SUPABASE_URL="https://pmeamznimqarggzihzcv.supabase.co"

# 새로운 ANON KEY를 여기에 입력하세요
# Supabase Dashboard > Settings > API > anon public key
NEW_ANON_KEY="YOUR_NEW_ANON_KEY_HERE"

echo "🔄 Supabase 환경 변수 업데이트 중..."

# .env 파일 업데이트
cat > .env << EOF
SUPABASE_URL='${NEW_SUPABASE_URL}'
SUPABASE_ANON_KEY='${NEW_ANON_KEY}'
EOF

echo "✅ .env 파일 업데이트 완료!"
echo ""
echo "📋 다음 단계:"
echo "1. Netlify Dashboard 접속: https://app.netlify.com"
echo "2. emotrack-app 사이트 선택"
echo "3. Site configuration > Environment variables"
echo "4. 다음 환경 변수 업데이트:"
echo "   - SUPABASE_URL = ${NEW_SUPABASE_URL}"
echo "   - SUPABASE_ANON_KEY = ${NEW_ANON_KEY}"
echo "5. Deploys > Trigger deploy > Clear cache and deploy site"
echo ""
echo "⚠️  중요: Netlify 환경 변수도 반드시 업데이트해야 합니다!"
