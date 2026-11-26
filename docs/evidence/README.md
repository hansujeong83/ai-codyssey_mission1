# 실제 실행 증거 수집

아래 파일은 **사용자 PC에서 직접 실행한 화면만** 저장합니다. 예시 이미지나 생성된 로그를 실제 수행 증거처럼 제출하지 않습니다.

| 파일명 | 반드시 보여야 할 내용 |
|---|---|
| `01-environment.png` | Windows/Ubuntu, Python, Git, Docker 버전 |
| `02-terminal.png` | `pwd`, `ls -la`, `cd`, 파일 생성·복사·이동·삭제 |
| `03-permissions.png` | `chmod` 전후 `ls -l` |
| `04-hello-world.png` | `docker run --rm hello-world` 성공 |
| `05-ubuntu-container.png` | Ubuntu 컨테이너 내부 `/etc/os-release`, `pwd`, `exit` |
| `06-web-build.png` | Dockerfile 빌드 및 `docker ps` |
| `07-browser.png` | 브라우저 주소 `http://localhost:8080`과 본 페이지(주소창과 페이지 제목이 함께 보이도록) |
| `08-bind-mount.png` | 호스트 HTML 수정 전·후 브라우저 결과 |
| `09-volume.png` | 첫 컨테이너 삭제 후 두 번째 컨테이너에서 데이터 확인 |
| `10-github.png` | VS Code에서 본인 GitHub 저장소 연결 상태(비밀정보 제외) |

각 캡처에는 명령과 성공 출력이 함께 보이도록 하고, 토큰·비밀번호·개인 이메일은 가립니다.

## 자동 로그와 수동 캡처 구분

저장소 루트에서 `bash scripts/capture_mission1.sh`를 실행하면 `terminal-session.txt`가 현재 컴퓨터에서 실제 실행된 터미널 출력으로 생성됩니다. 이 로그는 터미널 기반 증거를 보완하지만 브라우저 화면이나 VS Code 화면을 대신하지 않습니다. 자동화가 `[FAIL]` 또는 `RESULT=PARTIAL`을 출력하면 실패 원인을 해결한 후 다시 실행하세요. Docker 데몬에 연결되지 않은 경우 Docker 실습은 검증되지 않은 상태이며, 그 상태의 로그를 성공 증거로 제출하면 안 됩니다.

스크린샷은 Windows에서 `Win + Shift + S`로 실제 화면을 캡처한 뒤 이 폴더에 위 표의 파일명으로 저장합니다. 캡처 파일은 제출 전에 열어 글자가 읽히는지, 주소창·명령·결과가 잘리지 않았는지 확인하세요.
