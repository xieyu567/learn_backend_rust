use learn_backend_rust::configuration::get_configuration;
use learn_backend_rust::startup::run;
use learn_backend_rust::telemetry::{get_subscriber, init_subscriber};
use secrecy::ExposeSecret;
use sqlx::PgPool;
use std::net::TcpListener;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let subscriber = get_subscriber("learn_backend_rust".into(), "info".into(), std::io::stdout);
    init_subscriber(subscriber);

    let configuration = get_configuration().expect("Failed to read configuration.");
    let address = format!("127.0.0.1:{}", configuration.application_port);
    let listener = TcpListener::bind(address)?;
    let connection_pool =
        PgPool::connect(&configuration.database.connection_string().expose_secret())
            .await
            .expect("Failed to connect to CockroachDB");
    run(listener, connection_pool)?.await?;
    Ok(())
}
