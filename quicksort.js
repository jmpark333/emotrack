/**
 * 퀵소트(Quicksort) 함수
 * 배열을 빠르게 정렬하는 분할 정복 알고리즘
 * 평균 시간 복잡도: O(n log n)
 * 최악 시간 복잡도: O(n²)
 * 
 * @param {Array} arr - 정렬할 배열
 * @returns {Array} 정렬된 배열
 */
function quicksort(arr) {
  // 기본 경우: 배열 길이가 1 이하이면 그대로 반환
  if (arr.length <= 1) {
    return arr;
  }

  // 피벗 선택 (첫 번째 요소 사용)
  const pivot = arr[0];
  const left = [];
  const right = [];

  // 피벗을 기준으로 왼쪽(작은 값)과 오른쪽(큰 값)으로 분할
  for (let i = 1; i < arr.length; i++) {
    if (arr[i] < pivot) {
      left.push(arr[i]);
    } else {
      right.push(arr[i]);
    }
  }

  // 재귀적으로 왼쪽과 오른쪽 부분 배열을 정렬하고 병합
  return [...quicksort(left), pivot, ...quicksort(right)];
}

// 사용 예제와 테스트
const testArray = [64, 34, 25, 12, 22, 11, 90];
console.log('원본 배열:', testArray);
console.log('정렬된 배열:', quicksort(testArray));

// 모듈로 내보내기 (Node.js 환경에서 사용 가능)
if (typeof module !== 'undefined' && module.exports) {
  module.exports = quicksort;
}