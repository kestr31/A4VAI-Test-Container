# A4VAI 유닛 테스트 컨테이너 배포 유틸리티

[![en](https://img.shields.io/badge/lang-en-red.svg)](./README.md)
[![kr](https://img.shields.io/badge/lang-kr-blue.svg)](./README-KR.md)

- **이 저장소는 A4VAI 유닛 테스트 컨테이너를 배포하기 위한 자료를 제공합니다.**
    - 이 컨테이너는 A4VAI 시뮬레티어 구성 "모듈" 단위에 대한 소프트웨어/스크립트를 테스트하는 데 사용할 수 있습니다.
- **리소스는 스크립트와 문서, 설정 파일입니다.**
    - 스크립트는 `scripts` 디렉토리에 있습니다.
    - 모듈 전용 문서는 각 모듈 디렉토리에 있습니다.

## 빠른 시작

- 이 저장소를 로컬 머신에 클론하세요.
    - `git clone` 명령어를 사용해야 합니다. 저장소를 zip 파일로 다운로드하지 않도록 주의하세요.
    - 배포에 필요한 디렉토리 구조를 생성하려면 [kestr31/A4VAI-Env-Setup](https://github.com/kestr31/A4VAI-Env-Setup)이 필요할 수 있습니다.
    - 직접 작업 공간 디렉토리 구조를 수동으로 생성할 수도 있습니다.

```bash
git clone https://github.com/kestr31/A4VAI-Test-Container.git
```

- 예를 들어 `AirSim` 유닛 테스트 컨테이너를 배포하려면 다음 명령어를 사용하세요:

```bash
cd A4VAI-Test-Container
# A4VAI-Env-Setup을 사용하지 않은 경우 수동으로 작업 공간 디렉토리 구조를 생성하세요
mkdir -p ${HOME}/Documents/A4VAI-Workspace/Documents/A4VAI-Env-Setup/airsim_ws
# 디버그 모드로 AIRSIM 바이너리 컨테이너를 배포하세요
./scripts/run.sh airsim debug
# 컨테이너에 연결하세요
docker exec -it airsim-binary bash
```

- 컨테이너를 중지하려면 다음 명령어를 사용하세요:

```bash
./scripts/stop.sh airsim
```

- 저장소를 "리셋"하려면 다음 명령어를 사용하세요:
    - 새로 생성된 파일과 디렉토리는 그대로 유지됩니다.
    - 리셋할 모듈을 선택할 수 있습니다.

```bash
./scripts/reset.sh airsim
```

- 저장소를 "정리"하려면 다음 명령어를 사용하세요:
    - 새로 생성된 모든 파일과 디렉토리가 제거됩니다.
    - 정리할 모듈을 선택할 수 있습니다.

```bash
./scripts/clean.sh airsim
```

## 스크립트 목록

- `run.sh`
    - 사용 예: `./scripts/run.sh <module> <option>`
    - 지정된 모듈과 옵션으로 컨테이너를 배포합니다.
- `stop.sh`
    - 사용 예: `./scripts/stop.sh <module>`
    - 지정된 모듈의 컨테이너를 중지합니다.
- `reset.sh`
    - 사용 예: `./scripts/reset.sh <module>`
    - 지정된 모듈로 저장소를 리셋합니다.
    - 새로 생성된 파일과 디렉토리는 그대로 유지됩니다.
- `clean.sh`
    - 사용 예: `./scripts/clean.sh <module>`
    - 지정된 모듈로 저장소를 정리합니다.
    - 새로 생성된 모든 파일과 디렉토리가 제거됩니다.

## 라이센스

- 이 저장소는 MIT 라이센스 하에 배포됩니다.

---

> 본 문서는 ChatGPT 4o를 이용해 `README.md`를 번역한 문서입니다.