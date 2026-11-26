#!/usr/bin/env bash
# 본인 PC(WSL Ubuntu 등)의 저장소 루트에서 실행하세요:  bash scripts/collect_evidence.sh
# 각 명령과 실제 출력이 docs/evidence/text/*.txt 로 저장됩니다. 직접 실행한 결과만 기록됩니다.
# 토큰/비밀번호 형태의 문자열과 이메일은 자동으로 가립니다.
set +e
OUT=docs/evidence/text
mkdir -p "$OUT"
mask() { sed -E 's/(ghp_|gho_|github_pat_)[A-Za-z0-9_]+/\1***/g; s/([Tt]oken|[Pp]assword)[=: ]+[^ ]+/\1=***/g; s/[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}/***@***/g'; }
run() { # run <파일명> <명령...>
  local f="$OUT/$1.txt"; shift
  { echo "\$ $*"; echo "# $(date '+%Y-%m-%d %H:%M:%S')"; eval "$@" 2>&1; echo "# exit code: $?"; } | mask > "$f"
  echo "saved $f"
}

run 01-environment 'uname -a; cat /etc/os-release | head -3; echo $SHELL; python3 --version; git --version; docker --version'
run 02-terminal 'W=$(mktemp -d); cd "$W" && pwd && mkdir -p a/b && touch a/file.txt && echo hi > a/file.txt && ls -la a && cp a/file.txt a/copy.txt && mv a/copy.txt a/b/moved.txt && cat a/file.txt && ls -R a && rm a/b/moved.txt && ls -R a; cd - >/dev/null; rm -rf "$W"'
run 03-permissions 'W=$(mktemp -d); cd "$W" && touch f.txt && mkdir d && ls -l f.txt && ls -ld d && chmod 600 f.txt && chmod 700 d && ls -l f.txt && ls -ld d; cd - >/dev/null; rm -rf "$W"'
run 04-docker-info 'docker --version; docker info | head -20'
run 05-hello-world 'docker run --rm hello-world'
run 06-ubuntu-container 'docker run --rm ubuntu:24.04 sh -c "cat /etc/os-release | head -2; pwd; ls; echo container works"'
run 07-images-ps 'docker images; docker ps -a'
run 08-build 'docker build -t codyssey-mission1-web:1.0 .'
run 09-run-and-curl 'docker rm -f codyssey-mission1-web >/dev/null 2>&1; docker run -d --name codyssey-mission1-web -p 8080:80 codyssey-mission1-web:1.0; sleep 2; docker ps; curl -s http://localhost:8080 | head -15; docker logs codyssey-mission1-web | tail -5; docker stats --no-stream codyssey-mission1-web'
run 10-exec-attach 'docker run -d --name codyssey-sleep ubuntu:24.04 sleep 600; docker exec codyssey-sleep sh -c "echo exec-ok"; docker ps --filter name=codyssey-sleep; docker rm -f codyssey-sleep'
run 11-bind-mount 'mkdir -p /tmp/cod-bind && echo "<h1>before</h1>" > /tmp/cod-bind/index.html && docker rm -f cod-bind >/dev/null 2>&1; docker run -d --name cod-bind -p 8090:80 -v /tmp/cod-bind:/usr/share/nginx/html:ro nginx:1.27-alpine; sleep 2; curl -s localhost:8090; echo "<h1>after</h1>" > /tmp/cod-bind/index.html; curl -s localhost:8090; docker rm -f cod-bind'
run 12-volume 'bash scripts/verify_volume.sh'
run 13-git 'git config --list | grep -E "^(user\.name|user\.email|init\.defaultbranch|remote\.origin\.url)"; git remote -v; git log --oneline -5'
docker rm -f codyssey-mission1-web >/dev/null 2>&1
echo
echo "완료: $OUT 의 txt 파일을 확인하고, 이상한 값(개인정보)이 없는지 본 뒤 커밋하세요."
echo "트러블슈팅은 실제로 겪은 오류를 docs/evidence/text/14-troubleshooting.txt 에 직접 기록하세요(명령, 오류 메시지, 원인 확인, 해결)."
