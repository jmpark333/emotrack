import subprocess
import time
import os
from datetime import datetime
import argparse  # 2025-07-12 09:55:47: 인자 파싱을 위해 추가

# 2025-07-02 09:13:58 기준: 이미지 클립보드만 저장하도록 코드 수정함
# (텍스트는 무시, 이미지만 저장)
# 변경자: AI (Cascade)

# 클립보드 내용을 저장할 디렉토리 - Windows Screenshots 폴더로 고정
# 2025-09-24: C:\Users\User\Pictures\Screenshots로 변경
SAVE_DIR_WIN = r"C:\Users\User\Pictures\Screenshots"
SAVE_DIR_WSL = "/mnt/c/Users/User/Pictures/Screenshots"

# 중복 저장을 방지하기 위해 마지막으로 저장된 클립보드 내용을 저장하는 변수
last_clipboard_content = None

# 이미지 저장을 위한 임시 파일 경로 (WSL에서 접근 가능한 Windows 경로)
# WSL 경로를 Windows 경로로 변환해야 합니다. /home/rg3270 -> C:\Users\YourUser...
# 이 부분은 사용자의 Windows 사용자 이름에 맞게 수정해야 할 수 있습니다.
# wslpath -w ~ 를 터미널에 실행하여 Windows 경로를 확인할 수 있습니다.
# 예: C:\Users\Username\AppData\Local\Packages\CanonicalGroupLimited.Ubuntu_79rhkp1fndgsc\LocalState\rootfs\home\rg3270
# 간단하게 WSL에서 바로 접근 가능한 /mnt/c/ 경로를 사용합니다.
TEMP_IMAGE_PATH_WIN = r"C:\temp_clipboard_image.png"
TEMP_IMAGE_PATH_WSL = "/mnt/c/temp_clipboard_image.png"


def copy_to_clipboard(text):
    """텍스트를 Windows 클립보드에 복사합니다."""
    try:
        # PowerShell을 사용하여 텍스트를 클립보드에 복사
        ps_command = f"Set-Clipboard -Value '{text}'"
        result = subprocess.run(['powershell.exe', '-NoProfile', '-Command', ps_command], 
                              capture_output=True, text=True, encoding='utf-8')
        if result.returncode == 0:
            print(f"클립보드에 경로 복사 완료: {text}")
            return True
        else:
            print(f"클립보드 복사 실패: {result.stderr}")
            return False
    except Exception as e:
        print(f"클립보드 복사 중 오류 발생: {e}")
        return False


def get_clipboard_content_wsl():
    """WSL 환경에서 PowerShell을 사용하여 Windows 클립보드 내용을 가져옵니다."""
    try:
        # PowerShell 스크립트를 사용하여 클립보드에 이미지가 있는지 확인하고,
        # 이미지가 있다면 Windows 임시 폴더에 저장한 후 그 경로를 반환합니다.
        ps_script = '''
Add-Type -AssemblyName System.Drawing
Add-Type -AssemblyName System.Windows.Forms
if ($([System.Windows.Forms.Clipboard]::ContainsImage())) {
    $image = [System.Windows.Forms.Clipboard]::GetImage()
    # Windows의 임시 디렉토리에 고유한 파일 이름으로 저장
    $tempFile = [System.IO.Path]::Combine([System.IO.Path]::GetTempPath(), ([System.IO.Path]::GetRandomFileName() + ".png"))
    $image.Save($tempFile, [System.Drawing.Imaging.ImageFormat]::Png)
    # 저장된 파일의 전체 경로를 출력
    Write-Output $tempFile
    exit 0
} else {
    # 이미지가 없으면 "no_image"를 출력하고 오류 코드로 종료
    Write-Output "no_image"
    exit 1
}
'''

        # PowerShell 스크립트 실행
        result = subprocess.run(
            ['powershell.exe', '-NoProfile', '-Command', ps_script],
            capture_output=True, text=True, encoding='utf-8', errors='ignore'
        )

        # PowerShell 스크립트 실행 결과 확인
        if result.returncode == 0:  # 성공적으로 이미지 경로를 받아온 경우
            win_path = result.stdout.strip()
            
            # wslpath를 사용하여 Windows 경로를 WSL 경로로 변환
            wsl_path_result = subprocess.run(['wslpath', '-u', win_path], capture_output=True, text=True)
            if wsl_path_result.returncode != 0:
                print(f"경로 변환 오류: {win_path} -> WSL 경로. 오류: {wsl_path_result.stderr}")
                return None, None
            
            wsl_path = wsl_path_result.stdout.strip()

            try:
                # WSL 경로에서 이미지 파일을 읽고 임시 파일 삭제
                with open(wsl_path, "rb") as f:
                    image_data = f.read()
                os.remove(wsl_path)
                return image_data, "image"
            except FileNotFoundError:
                print(f"임시 이미지 파일을 찾을 수 없습니다: {wsl_path}")
                return None, None

        elif "no_image" in result.stdout:  # 클립보드에 이미지가 없는 경우
            # Get-Clipboard를 사용하여 텍스트 콘텐츠를 가져옴
            # PowerShell의 출력 인코딩을 UTF-8로 명시적으로 설정하여 인코딩 오류 방지
            ps_command = "[Console]::OutputEncoding = [System.Text.Encoding]::UTF8; Get-Clipboard"
            text_result = subprocess.run(['powershell.exe', '-Command', ps_command], capture_output=True, text=True, encoding='utf-8')
            if text_result.returncode == 0 and text_result.stdout:
                return text_result.stdout.strip(), "text"
        else:  # PowerShell 스크립트 실행 중 오류 발생
            print(f"PowerShell 이미지 확인 중 오류 발생: {result.stderr}")
            return None, None

    except FileNotFoundError:
        print("PowerShell 또는 wslpath를 찾을 수 없습니다. WSL 환경에서 실행 중인지 확인하세요.")
        return None, None
    except Exception as e:
        print(f"알 수 없는 오류 발생: {e}")
        return None, None
    
    return None, None


def save_content(content, content_type):
    """클립보드에서 가져온 내용을 파일로 저장합니다.
    content_type이 'image'인 경우에만 저장합니다."""
    global last_clipboard_content  # 2025-07-12 10:00:23: 중복 저장 방지
    
    # 2025-07-02 09:13:58: 이미지만 저장하도록 수정
    # 2025-09-24: Screenshots 폴더에 저장하도록 수정
    if content_type == "image":
        # 2025-07-12 10:00:23: 동일 이미지 중복 저장 방지
        if last_clipboard_content == content:
            return  # 이전 내용과 같으면 저장하지 않음
        
        now = datetime.now().strftime("%Y%m%d_%H%M%S")
        filename = f"clipboard_image_{now}.png"
        
        # WSL 경로로 디렉토리 확인 및 생성
        if not os.path.exists(SAVE_DIR_WSL):
            try:
                os.makedirs(SAVE_DIR_WSL)
                print(f"'{SAVE_DIR_WSL}' 디렉토리가 생성되었습니다.")
            except Exception as e:
                print(f"디렉토리 생성 실패: {e}")
                return
        
        filepath_wsl = os.path.join(SAVE_DIR_WSL, filename)
        filepath_win = os.path.join(SAVE_DIR_WIN, filename)
        
        try:
            with open(filepath_wsl, "wb") as f:
                f.write(content)
            print(f"이미지 저장 완료: {filepath_win}")
            
            # 클립보드에 파일 경로 복사
            copy_to_clipboard(filepath_win)
            
            last_clipboard_content = content  # 마지막 이미지 갱신
        except Exception as e:
            print(f"이미지 저장 실패: {e}")  # 2025-07-12 10:00:23 수정
    else:
        pass  # 텍스트 등 기타 타입은 무시


if __name__ == "__main__":
    # 2025-09-24: Screenshots 폴더로 고정
    SAVE_DIR = SAVE_DIR_WSL
    
    # 디렉토리 존재 확인 및 생성
    if not os.path.exists(SAVE_DIR):
        try:
            os.makedirs(SAVE_DIR)
            print(f"'{SAVE_DIR_WIN}' 디렉토리가 생성되었습니다.")
        except Exception as e:
            print(f"디렉토리 생성 실패: {e}")
            exit(1)

    print(f"클립보드 모니터링을 시작합니다. (5초 간격)\n저장 폴더: {SAVE_DIR_WIN}")
    print("종료하려면 Ctrl+C를 누르세요.")

    # 필요한 Windows Forms 어셈블리 로드를 위한 사전 실행
    # 일부 시스템에서는 스크립트 실행 초기에 로드해두는 것이 안정적일 수 있습니다.
    try:
        subprocess.run('powershell.exe -Command "Add-Type -AssemblyName System.Windows.Forms"', shell=True, check=True)
    except (subprocess.CalledProcessError, FileNotFoundError) as e:
        print(f"초기화 중 오류 발생: {e}")
        print("스크립트를 계속 진행하지만, 이미지 처리에 문제가 발생할 수 있습니다.")

    while True:
        content, content_type = get_clipboard_content_wsl()
        # 2025-07-02 09:13:58: 이미지만 저장, 텍스트는 무시
        if content and content_type == "image":
            save_content(content, content_type)
        time.sleep(5)
