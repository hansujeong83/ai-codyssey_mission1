# Codyssey Mission 1 — 개발 환경 구축

26올인원 1기 입학연수 미션 1 제출 저장소입니다.

## 목표
Windows + WSL2(Ubuntu) 환경에서 Docker 기반 웹 서버를 실행하고, 포트 연결과 데이터 영속성을 확인합니다.

## 구성
- `Dockerfile`: NGINX 기반 웹 서버 이미지
- `docker-compose.yml`: 컨테이너 실행 구성
- `app/index.html`: 실습용 웹 페이지
- `verify_env.ps1`, `verify_env.sh`: 개발 환경 점검
- `scripts/run_web.sh`: 웹 서버 실행
- `scripts/verify_volume.sh`: 볼륨 영속성 확인
- `docs/evidence/`: 실제 실습 캡처 증거 안내
- `SUBMISSION_STATUS.md`: 제출 전 확인 사항

## 실행 환경
Windows PowerShell 또는 WSL2 Ubuntu 터미널에서 진행합니다. 자세한 명령어와 단계는 실습 가이드를 참고하세요.

## 실행 및 검증
실습 환경에 Docker Desktop 또는 Docker Engine이 설치되어 있어야 합니다. 안내된 명령을 실제 환경에서 실행하고 브라우저 접속, 볼륨 데이터 유지 여부를 확인하세요.

## 제출 증거
실제 실행 화면 캡처는 `docs/evidence/README.md`의 체크리스트에 따라 직접 추가해야 합니다. 실행하지 않은 결과나 캡처를 임의로 생성하지 않습니다.

## 주의
이 저장소의 문서와 스크립트는 실습 수행을 돕는 자료입니다. 최종 제출 전에는 본인의 PC에서 모든 명령을 실행하고 결과를 확인해야 합니다.
