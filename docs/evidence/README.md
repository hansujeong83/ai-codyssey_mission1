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
| `07-browser.png` | 브라우저 주소 `http://localhost:8080`과 본 페이지 |
| `08-bind-mount.png` | 호스트 HTML 수정 전·후 브라우저 결과 |
| `09-volume.png` | 첫 컨테이너 삭제 후 두 번째 컨테이너에서 데이터 확인 |
| `10-github.png` | VS Code에서 본인 GitHub 저장소 연결 상태(비밀정보 제외) |

각 캡처에는 명령과 성공 출력이 함께 보이도록 하고, 토큰·비밀번호·개인 이메일은 가립니다.

## 텍스트 증거 자동 수집
스크린샷과 별개로, 명령과 출력을 텍스트로 남기면 검토 도구가 내용을 읽을 수 있습니다. 본인 PC(WSL Ubuntu)의 저장소 루트에서 실행하세요.
```bash
bash scripts/collect_evidence.sh
```
- 결과는 `docs/evidence/text/*.txt`에 저장됩니다(환경, 터미널 조작, 권한 전후, docker info, hello-world, Ubuntu 컨테이너, images/ps, build, 포트 매핑·curl·logs·stats, exec, 바인드 마운트, 볼륨, git 설정).
- 이 스크립트는 직접 실행한 출력만 기록하며 값을 만들어 넣지 않습니다. 토큰·이메일 형태 문자열은 자동으로 가리지만, 저장 후 한 번 더 확인하세요.
- 트러블슈팅은 실제로 겪은 오류를 `docs/evidence/text/14-troubleshooting.txt`에 직접 적습니다(명령, 오류 메시지, 원인 확인, 해결).
