use learn_backend_rust::configuration::get_configuration;
use learn_backend_rust::startup::run;
use learn_backend_rust::telemetry::{get_subscriber, init_subscriber};
use sqlx::postgres::PgPoolOptions;
use std::net::TcpListener;

#[tokio::main]
async fn main() -> std::io::Result<()> {
    let subscriber = get_subscriber("learn_backend_rust".into(), "info".into(), std::io::stdout);
    init_subscriber(subscriber);

    let configuration = get_configuration().expect("Failed to read configuration.");
    let address = format!(
        "{}:{}",
        configuration.application.host, configuration.application.port
    );
    let listener = TcpListener::bind(address)?;
    let connection_pool = PgPoolOptions::new()
        .acquire_timeout(std::time::Duration::from_secs(2))
        .connect_lazy_with(configuration.database.with_db());
    run(listener, connection_pool)?.await?;
    Ok(())
}
