# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Tech Stack

- Java 21, Spring Boot 3.5.9, Gradle 8.14
- Spring Data JPA + QueryDSL 5.0 + Flyway (PostgreSQL 15, schema: `todolist`)
- MapStruct 1.5.5 + Lombok
- Spring Security + JWT (jjwt 0.11.5)
- Redis 7 (refresh token store + code cache)
- SpringDoc OpenAPI (Swagger UI)

## Commands

```bash
# Build
./gradlew build

# Compile only (quick check)
./gradlew compileJava

# Run (local profile — auto-starts Docker containers for PostgreSQL + Redis)
./gradlew bootRun -PspringProfiles=local

# Run all tests
./gradlew test

# Run a single test class
./gradlew test --tests "com.example.todolist.module.user.facade.AuthFacadeTest"

# Run a single test method
./gradlew test --tests "com.example.todolist.module.user.facade.AuthFacadeTest.login_success"
```

## Local Environment

- **Profile `local`** port 8086 — Docker Compose가 앱 기동 시 자동으로 `docker-compose up -d` 실행 (`LocalDockerConfig`)
- PostgreSQL: `localhost:15432`, Redis: `localhost:16379`
- Swagger UI: http://localhost:8086/swagger-ui/index.html
- Docker 없이 인프라를 따로 띄우려면 `docker-compose up -d` 직접 실행

## Architecture

### Layer Structure (per module)

```
Controller → Facade → Service → Repository
```

- **Controller**: HTTP 요청/응답만 처리. 비즈니스 로직 없음.
- **Facade** (`@Facade` = `@Service`): 유스케이스 단위 조합. 입력값 검증(`ToyAssert`), 여러 Service 호출.
- **Service**: `BaseService<Entity, SearchParam, ID>` 구현. 단일 엔티티 CRUD.
- **Repository**: JpaRepository + QueryDSL (`RepositoryCustom` / `RepositoryImpl` 패턴).
- **Converter**: MapStruct 인터페이스. Entity ↔ Model 변환. `TypeConverter`로 `LocalDateTime ↔ String`, `YN enum ↔ String` 처리.

### Key Base Classes

| 클래스 | 역할 |
|--------|------|
| `BaseEntity<ID>` | JPA 엔티티 공통 필드 (id, createTime, updateTime, createId, updateId). `@PrePersist`/`@PreUpdate`로 자동 세팅. |
| `BaseModel<ID>` | API 응답용 DTO 공통 필드. createTime/updateTime은 `String` 타입. |
| `BaseService<T, P, ID>` | Service 인터페이스 (existsById, findById, findAllBy, save, update, deleteById). |
| `BaseSearchParam<ID>` | 검색 파라미터 공통 필드 (ids, createId, createTime 범위 등). |
| `ToyAssert` | 비즈니스 검증 유틸. 실패 시 `CustomException` throw. |

### API Response Envelope

`ResponseAdvice`가 `com.example.todolist.module` 패키지의 모든 컨트롤러 응답을 자동으로 래핑:
```json
{ "status": 200, "response": { ... } }
{ "status": 400, "error": "REQUIRED", "message": "..." }
```
- 컨트롤러에서 직접 `Response<T>`를 반환하면 이중 래핑 안 됨 (supports()에서 제외).

### Security Flow

JWT Stateless 방식:
1. `POST /auth/login` → `AccessToken` + `RefreshToken` 발급, RefreshToken은 Redis에 저장
2. 모든 요청: `JwtAuthenticationFilter` → `JwtTokenProvider.validateToken()` → `SecurityContext` 세팅
3. `POST /auth/issueAccessToken` → RefreshToken으로 AccessToken 재발급 (중복 로그인 감지 포함)
4. `POST /auth/logout` → Redis에서 RefreshToken 삭제

허용 URL: `/auth/login`, `/auth/logout`, `/auth/issueAccessToken`, Swagger, Actuator, `/static/**`

### Redis Cache (Code)

`CodeService`가 `CacheEventHandler` 구현:
- 앱 기동 시 `@PostConstruct`로 코드 데이터를 `cache:code` 해시 키에 캐싱
- `CodeFacade`가 `CacheEventPublishable` 구현 → 변경 시 `cache:invalidate` 채널에 publish
- `CacheEventListener`(MessageListener)가 구독하여 해당 핸들러의 `refreshCache()` 호출
- `CacheScheduler`가 cron(`cron.yml`)으로 주기적 갱신 (`0 0 * * * *`)

### Database Schema

- 스키마: `todolist` (public 아님)
- Flyway 마이그레이션: `src/main/resources/db/migration/V{n}__*.sql`
- Hibernate `globally_quoted_identifiers: true` — 모든 테이블/컬럼명이 따옴표로 감싸짐
- `ddl-auto: validate` — 엔티티와 실제 DB 스키마 불일치 시 기동 실패

### Module Structure

현재 모듈: `user`, `code`, `file`, `main`

새 모듈 추가 시 패턴:
```
module/{name}/
  controller/   entity/   model/   facade/
  service/      repository/   converter/
```
