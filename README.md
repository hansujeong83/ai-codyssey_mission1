# Mission 1 — 개발자 작업환경과 Docker 실습

Windows 11 + VS Code + Ubuntu(WSL) 사용을 기준으로 구성했습니다. 실습은 **PowerShell과 Ubuntu Bash를 구분**해 진행합니다. Docker Desktop 또는 교육기관에서 승인한 Docker 호환 런타임이 필요합니다.

> 제출 무결성: 이 패키지에는 실행 가능한 파일과 검증 절차가 포함됩니다. 현재 PC에서 Docker daemon, 브라우저, GitHub 연동을 실제 확인한 증거는 포함하지 않습니다. 아래 절차를 실행하고 `docs/evidence/`에 실제 캡처를 추가해야 합니다.

## 1. 환경 확인

PowerShell:
```powershell
wsl --list --verbose
python --version
git --version
docker --version
docker info
```

Ubuntu:
```bash
uname -a
python3 --version
git --version
docker --version
docker info
```

환경 점검 스크립트:
```bash
bash verify_env.sh
```
PowerShell에서는:
```powershell
.\verify_env.ps1
```

`docker --version`은 CLI 설치 여부만 확인합니다. `docker info`가 성공해야 엔진 연결까지 확인된 것입니다.

## 2. 터미널과 파일 조작

Ubuntu:
```bash
mkdir -p ~/codyssey/mission1/practice
cd ~/codyssey/mission1/practice
pwd
touch sample.txt
echo "Codyssey Mission 1" > sample.txt
cat sample.txt
cp sample.txt copy.txt
mv copy.txt renamed.txt
ls -la
rm renamed.txt
```

PowerShell 대응:
```powershell
New-Item -ItemType Directory -Force .\practice
Set-Location .\practice
Get-Location
Set-Content sample.txt "Codyssey Mission 1"
Get-Content sample.txt
Copy-Item sample.txt copy.txt
Rename-Item copy.txt renamed.txt
Get-ChildItem -Force
Remove-Item renamed.txt
```

## 3. Linux 권한

```bash
cd ~/codyssey/mission1/practice
touch permission-file.txt
mkdir permission-dir
ls -l permission-file.txt
chmod 640 permission-file.txt
chmod 750 permission-dir
ls -l permission-file.txt
ls -ld permission-dir
```

`r=4`, `w=2`, `x=1`입니다. 파일의 `x`는 실행 권한이고 디렉터리의 `x`는 내부 항목에 접근할 수 있는 탐색 권한입니다. `640`은 소유자 읽기/쓰기, 그룹 읽기, 기타 사용자 권한 없음입니다.

## 4. Git 설정과 저장소 연결

```bash
git config --global user.name "본인 이름"
git config --global user.email "GitHub에 등록한 이메일"
git config --global init.defaultBranch main
git config --list
```

저장소 연결:
```bash
git clone https://github.com/hansujeong83/ai-codyssey_mission1.git
cd ai-codyssey_mission1
git remote -v
git status
```

인증은 브라우저 로그인 또는 Git Credential Manager 등 승인된 방식을 사용합니다. 토큰을 README, 명령 기록, 스크린샷에 직접 적지 않습니다.

## 5. Docker 기본 및 Ubuntu 컨테이너

먼저 Docker Desktop/교육기관 승인 런타임을 실행합니다. WSL을 사용한다면 Docker Desktop의 WSL integration 설정도 확인합니다.

```bash
docker run --rm hello-world
docker images
docker run -it --name codyssey-ubuntu ubuntu:24.04 bash
```

컨테이너 안에서:
```bash
cat /etc/os-release
pwd
ls -la
echo "container works"
exit
```

호스트에서:
```bash
docker ps -a
docker logs codyssey-ubuntu
docker rm codyssey-ubuntu
```

실행 중인 컨테이너의 리소스와 접속 방식 차이도 확인합니다(요구 사항: `docker stats`, attach/exec 비교).
```bash
docker run -d --name codyssey-sleep ubuntu:24.04 sleep 600
docker stats --no-stream codyssey-sleep
docker exec -it codyssey-sleep bash      # 새 프로세스로 접속: exit 해도 컨테이너는 계속 실행
docker ps                                 # 여전히 Up 상태인지 확인
docker attach codyssey-sleep              # 메인 프로세스(sleep)에 연결: Ctrl+P, Ctrl+Q로 분리
docker rm -f codyssey-sleep
```
- `exec`: 실행 중인 컨테이너에 새 프로세스를 추가합니다. 종료해도 컨테이너에 영향이 없습니다.
- `attach`: 컨테이너의 메인 프로세스 입출력에 붙습니다. 메인 프로세스가 끝나면 컨테이너도 종료됩니다.
- 관찰한 결과는 본인 실행 출력으로 `docs/evidence/`에 캡처해 첨부하세요.

## 6. Dockerfile 웹 서버와 포트 매핑

저장소 루트에서:
```bash
docker build -t codyssey-mission1-web:1.0 .
docker run -d --name codyssey-mission1-web -p 8080:80 codyssey-mission1-web:1.0
docker ps
docker logs codyssey-mission1-web
```

브라우저에서 `http://localhost:8080` 접속합니다. 호스트 8080 포트를 컨테이너 80 포트에 연결한 것입니다.

정리:
```bash
docker rm -f codyssey-mission1-web
```

## 7. 바인드 마운트

저장소 루트에서 Ubuntu Bash:
```bash
docker run -d --name codyssey-bind -p 8081:80 \
  --mount type=bind,source="$(pwd)/app",target=/usr/share/nginx/html,readonly \
  nginx:1.27-alpine
```

`app/index.html`의 문구를 바꾸고 `http://localhost:8081`을 새로고침합니다. 호스트의 파일 변경이 컨테이너에 반영되는 것을 확인합니다.

```bash
docker rm -f codyssey-bind
```

## 8. 볼륨 영속성

```bash
bash scripts/verify_volume.sh
```

이 스크립트는 named volume에 파일을 기록한 뒤 첫 컨테이너를 삭제하고, 두 번째 컨테이너에서 같은 파일을 읽습니다. 마지막에 `PASS`가 출력되면 컨테이너 수명과 무관하게 데이터가 보존된 것입니다.

수동 실습 명령:
```bash
docker volume create codyssey-mission1-data
docker run -d --name volume-a -v codyssey-mission1-data:/data ubuntu:24.04 sleep infinity
docker exec volume-a sh -c 'echo persistent > /data/proof.txt'
docker rm -f volume-a
docker run -d --name volume-b -v codyssey-mission1-data:/data ubuntu:24.04 sleep infinity
docker exec volume-b cat /data/proof.txt
docker rm -f volume-b
```

## 9. Compose 선택 실습

```bash
docker compose up -d --build
docker compose ps
```
`http://localhost:8080`을 확인한 뒤:
```bash
docker compose down
```

## 10. 트러블슈팅

| 증상 | 원인 후보 | 확인/대응 |
|---|---|---|
| `docker: command not found` | CLI 미설치 또는 PATH | 승인 런타임 설치, 터미널 재시작 |
| `Cannot connect to the Docker daemon` | 엔진 중지/WSL 통합 | 런타임 실행, `docker info` 재확인 |
| 포트 할당 실패 | 8080/8081 사용 중 | `docker ps`, `ss -ltnp`, 호스트 포트 변경 |
| bind mount 오류 | 저장소 루트가 아님/경로 오류 | `pwd`, `ls app`, 절대경로 확인 |
| 권한 오류 | 파일 권한 또는 공유 경로 | 최소 권한 확인, WSL 파일 경로 사용 |
| sudo 권한 제한 | 교육기관 정책 | 임의 우회 금지. 강의에서 지정한 OrbStack 등 승인 런타임 사용 여부를 담당자에게 확인 |

## 디렉터리 구성과 역할
| 경로 | 역할 | 이렇게 나눈 기준 |
|---|---|---|
| `app/` | 컨테이너에 넣을 정적 웹 페이지(`index.html`) | 이미지 내용(소스)과 실행 설정을 분리 |
| `Dockerfile`, `docker-compose.yml`, `.dockerignore` | 이미지 빌드·실행 설정 | 저장소 루트에 둬서 `docker build .`의 컨텍스트가 되게 함 |
| `scripts/` | 반복 실행용 스크립트(`run_web.sh`, `verify_volume.sh`) | 손으로 치던 명령을 재현 가능하게 문서화 |
| `verify_env.sh`, `verify_env.ps1` | 환경 점검(Bash/PowerShell) | OS별 도구가 달라 두 벌 제공 |
| `docs/evidence/` | 실행 캡처와 로그 | 결과 증거를 코드와 분리해 한곳에 모음 |

## 디렉터리 구조 설계 기준

이 저장소는 **웹 콘텐츠**, **컨테이너 구성**, **반복 실습 스크립트**, **제출 증거**를 분리합니다. `app/`은 NGINX가 서비스할 원본 파일만 보관하고, `Dockerfile`과 `docker-compose.yml`은 실행 환경을 정의합니다. `scripts/`와 루트의 환경 점검 스크립트는 반복 작업을 자동화하며, `docs/`는 설명서와 실제 실행 증거를 보관합니다. 따라서 웹 페이지 수정은 `app/`에서, 컨테이너 동작 변경은 Docker 설정에서, 검증 절차 변경은 스크립트에서 수행할 수 있습니다.

## 이미지와 컨테이너의 차이
- **이미지**는 읽기 전용 템플릿입니다. Dockerfile의 각 명령이 층(layer)으로 쌓여 저장되고, 한 번 빌드하면 바뀌지 않습니다(저장 상태).
- **컨테이너**는 이미지를 실행한 인스턴스입니다. 이미지 위에 쓰기 가능한 층이 하나 얹히며, 컨테이너를 지우면 그 층의 변경은 사라집니다(실행 상태).
- 같은 이미지로 컨테이너를 여러 개 띄울 수 있습니다(`8080`, `8081` 포트 실습). 코드를 바꾸면 이미지를 다시 `build`하고 컨테이너를 새로 `run`하는 흐름입니다. 컨테이너 안에서 바꾼 파일은 이미지에 남지 않으므로, 남겨야 하는 데이터는 볼륨에 둡니다.

## 포트 매핑과 네트워크 네임스페이스
- 컨테이너는 Linux **network namespace**를 통해 자체 네트워크 인터페이스, IP 주소, 라우팅 테이블, 포트 공간을 호스트와 분리합니다. 따라서 컨테이너 안에서 NGINX가 80번 포트에 수신 대기해도 호스트의 `localhost:80`에 자동으로 공개되는 것은 아닙니다.
- `-p 8080:80`은 Docker가 호스트의 8080 포트와 컨테이너의 80 포트를 연결하도록 NAT/포트 게시 규칙을 설정한다는 뜻입니다. 외부에서 들어온 연결은 호스트 포트에 도착한 뒤 컨테이너 네트워크로 전달됩니다. 이 규칙이 있어야 브라우저가 `localhost:8080`으로 컨테이너 웹 서버에 접속할 수 있습니다.
- 컨테이너마다 자기 80번 포트를 쓰므로, 호스트 포트만 다르게(8080, 8081) 매핑하면 같은 서비스를 동시에 띄울 수 있습니다.

## 절대경로와 상대경로
- **절대경로**(`/home/user/project/app`, Windows는 `C:\...`)는 어디서 실행해도 같은 위치를 가리킵니다. 스크립트나 cron처럼 실행 위치가 바뀌는 곳, 문서에서 위치를 정확히 알려줄 때 씁니다.
- **상대경로**(`./app`, `../data`)는 현재 위치 기준입니다. 저장소 안에서 작업하고, 다른 PC로 옮겨도 동작해야 할 때 씁니다.
- 바인드 마운트의 `-v` 호스트 쪽은 절대경로가 필요합니다. 그래서 `$(pwd)/app`처럼 현재 위치를 절대경로로 바꿔 씁니다. 저장소 루트가 아닌 곳에서 실행하면 경로 오류가 납니다(트러블슈팅 참고).

## 바인드 마운트와 볼륨 비교
| 구분 | 바인드 마운트 | Docker 볼륨 |
|---|---|---|
| 저장 위치 | 호스트의 내가 지정한 폴더 | Docker가 관리하는 영역 |
| 장점 | 호스트에서 파일을 고치면 바로 반영(개발에 편리) | 컨테이너를 지워도 유지, 경로·권한 문제가 적고 이식성 좋음 |
| 단점 | 호스트 경로·권한에 의존, PC마다 경로가 다름 | 호스트에서 직접 편집하기 불편 |
| 용도 | 소스 코드·정적 파일 개발 중 반영 | DB, 업로드 파일 등 영속 데이터 |

## 포트 충돌 확인과 해제
`port is already allocated` 오류가 나면 해당 포트를 쓰는 프로세스를 찾습니다.
```bash
# Ubuntu/WSL
ss -ltnp | grep ':8080'
lsof -i :8080
docker ps --filter "publish=8080"      # 내 컨테이너가 쓰는지 확인
docker rm -f <컨테이너이름>              # 내 컨테이너면 정리
kill <PID>                              # 다른 프로세스라면 확인 후 종료
```
```powershell
# PowerShell
netstat -ano | findstr :8080
Stop-Process -Id <PID>
```
`ss` 또는 `lsof` 결과에서 PID를 확인한 뒤 `ps -fp PID`로 프로세스가 무엇인지 먼저 확인합니다. 본인이 종료해도 되는 프로세스일 때만 `kill -TERM PID`를 실행합니다. Docker 컨테이너가 점유 중이면 `docker rm -f 컨테이너이름`으로 해당 컨테이너를 정리합니다. 다른 서비스일 수 있으므로 확인 없이 PID를 종료하지 마세요. 종료하기 어렵다면 `-p 8082:80`처럼 비어 있는 다른 호스트 포트를 쓰면 됩니다.

## 11. 자동 실행 로그 생성

저장소 루트에서 다음을 실행하면 현재 PC에서 실제로 수행한 터미널 명령과 결과가 로그 파일에 기록됩니다.

```bash
bash scripts/capture_mission1.sh
```

생성 결과:
- `docs/evidence/terminal-session.txt`: 환경, 파일 조작, 권한, Docker, 포트, 바인드 마운트, 볼륨 및 Git 상태의 실제 실행 로그
- 스크립트는 Docker 엔진에 연결할 수 없으면 Docker 실습을 완료로 표시하지 않고 중단합니다.
- 브라우저 주소창, VS Code/GitHub 연동 등 화면 증거는 실제 PC에서 직접 캡처해야 합니다. 자동 생성 이미지나 예시 이미지를 실제 수행 증거로 제출하지 않습니다.

상세 개념 설명은 [기술 개념 및 평가자 안내](docs/TECHNICAL_GUIDE.md), 캡처 기준은 [증거 수집 안내](docs/evidence/README.md)를 참고합니다.

## 12. 완료 판정 체크리스트

- [ ] 환경 점검 스크립트 결과 확인
- [ ] 터미널 파일 조작과 chmod 전후 확인
- [ ] Git 설정 및 clone/remote 확인
- [ ] `hello-world` 성공
- [ ] Ubuntu 컨테이너 실행·내부 명령 확인
- [ ] Dockerfile 빌드 및 포트 8080 접속
- [ ] 바인드 마운트 수정 반영
- [ ] named volume 재생성 후 데이터 유지
- [ ] Compose 실행·종료
- [ ] 실제 화면 캡처 10개를 `docs/evidence/`에 추가

상세 캡처 기준은 [docs/evidence/README.md](docs/evidence/README.md)를 따릅니다.
