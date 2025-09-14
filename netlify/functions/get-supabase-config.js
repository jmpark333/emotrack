exports.handler = async (event, context) => {
  try {
    // Netlify 환경변수에서 Supabase 설정 가져오기
    const supabaseUrl = process.env.SUPABASE_URL;
    const supabaseAnonKey = process.env.SUPABASE_ANON_KEY;

    // 환경변수가 설정되지 않은 경우 에러 반환
    if (!supabaseUrl || !supabaseAnonKey) {
      console.error('Supabase 환경변수가 설정되지 않았습니다:', {
        supabaseUrl: !!supabaseUrl,
        supabaseAnonKey: !!supabaseAnonKey
      });
      
      return {
        statusCode: 500,
        headers: {
          'Content-Type': 'application/json',
          'Access-Control-Allow-Origin': '*',
          'Access-Control-Allow-Headers': 'Content-Type',
          'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
        },
        body: JSON.stringify({
          error: 'Supabase 환경변수가 설정되지 않았습니다. 관리자에게 문의해주세요.'
        })
      };
    }

    // 성공적으로 설정 반환
    return {
      statusCode: 200,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
      },
      body: JSON.stringify({
        supabaseUrl,
        supabaseAnonKey
      })
    };

  } catch (error) {
    console.error('Netlify Function 오류:', error);
    
    return {
      statusCode: 500,
      headers: {
        'Content-Type': 'application/json',
        'Access-Control-Allow-Origin': '*',
        'Access-Control-Allow-Headers': 'Content-Type',
        'Access-Control-Allow-Methods': 'GET, POST, OPTIONS'
      },
      body: JSON.stringify({
        error: '서버 내부 오류가 발생했습니다.'
      })
      };
  }
};
