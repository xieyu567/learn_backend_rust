FROM lukemathwalker/cargo-chef:latest-rust-1.64.0 as chef
WORKDIR /app
RUN apt update && apt install lld clang -y

FROM chef as planner
COPY . .
RUN cargo chef prepare --recipe-path recipe.json

FROM chef AS builder

WORKDIR /app
RUN apt update && apt install lld clang -y
COPY . .
RUN cargo build --release

FROM debian:bullseye-slim AS runtime

WORKDIR /app
RUN apt-get update -y && apt-get install -y --no-install-recommends openssl ca-certificates && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/*
COPY --from=builder /app/target/release/learn_backend_rust learn_backend_rust
COPY configuration configuration
ENV APP_ENVIRONMENT production

ENTRYPOINT ["./learn_backend_rust"]