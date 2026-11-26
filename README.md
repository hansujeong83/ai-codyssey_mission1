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

브라우저에서 `http://localhost:8080` 접속합니다. 호스트 8080 포트를 컨테이너 80 포트에 연결한 것입니다. 자동 점검 스크립트는 `bash scripts/run_web.sh`입니다.

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
| 포트 할당 실패 | 8080/8081 사용 중 | `docker ps`, 호스트 포트 변경 |
| bind mount 오류 | 저장소 루트가 아님/경로 오류 | `pwd`, `ls app`, 절대경로 확인 |
| 권한 오류 | 파일 권한 또는 공유 경로 | 최소 권한 확인, WSL 파일 경로 사용 |
| sudo 권한 제한 | 교육기관 정책 | 임의 우회 금지. 강의에서 지정한 OrbStack 등 승인 런타임 사용 여부를 담당자에게 확인 |

## 11. 완료 판정 체크리스트

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

상세 캡처 기준은 [`docs/evidence/README.md`](docs/evidence/README.md)를 따릅니다.
