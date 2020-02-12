#!/bin/sh
set -e

PG_CONFIG_DIR=/etc/pgbouncer
PG_USER=postgres

invoke_main(){
    check_variables
    create_config
    start_app
}

check_variables(){
    test -n "$DATABASES_HOST" ||
        error "You have to set the DATABASES_HOST Environment variable at the very least"
}

error(){
    MESSAGE="$1"
    EXIT="${2:-1}"

    echo "$MESSAGE"
    exit "$EXIT"
}

create_config(){
    echo "Creating pgbouncer config in ${PG_CONFIG_DIR}"

    nl="$(printf '%b_' '\n')";
    nl="${nl%_}"

    cat > ${PG_CONFIG_DIR}/pgbouncer.ini << EOF
#pgbouncer.ini

[databases]
${DATABASES_CLIENT_SIDE_DBNAME:-*} = host = ${DATABASES_HOST} \
port=${DATABASES_PORT:-5432} user=${DATABASES_USER:-postgres}\
${DATABASES_PASSWORD:+" password=${DATABASES_PASSWORD}"}\
${DATABASES_DBNAME:+" dbname=${DATABASES_DBNAME}"}\
${DATABASES_AUTH_USER:+" auth_user=${DATABASES_AUTH_USER}"}\
${DATABASES_POOL_SIZE:+" pool_size=${DATABASES_POOL_SIZE}"}\
${DATABASES_RESERVE_POOL:+" reserve_pool=${DATABASES_RESERVE_POOL}"}\
${DATABASES_CONNECT_QUERY:+" connect_query=${DATABASES_CONNECT_QUERY}"}\
${DATABASES_POOL_MODE:+" pool_mode=${DATABASES_POOL_MODE}"}\
${DATABASES_MAX_DB_CONNECTIONS:+" max_db_connections=${DATABASES_MAX_DB_CONNECTIONS}"}\
${DATABASES_CLIENT_ENCODING:+" client_encoding=${DATABASES_CLIENT_ENCODING}"}\
${DATABASES_DATESTYLE:+" datestyle=${DATABASES_DATESTYLE}"}\
${DATABASES_TIMEZONE:+" timezone=${DATABASES_TIMEZONE}"}

[pgbouncer]
${PGBOUNCER_LOGFILE:+logfile = ${PGBOUNCER_LOGFILE}${nl}}\
${PGBOUNCER_PIDFILE:+pidfile = ${PGBOUNCER_PIDFILE}${nl}}\
listen_addr = ${PGBOUNCER_LISTEN_ADDR:-0.0.0.0}
${PGBOUNCER_LISTEN_PORT:+listen_port = ${PGBOUNCER_LISTEN_PORT}${nl}}\
${PGBOUNCER_UNIX_SOCKET_DIR:+unix_socket_dir = ${PGBOUNCER_UNIX_SOCKET_DIR}${nl}}\
${PGBOUNCER_UNIX_SOCKET_MODE:+unix_socket_mode = ${PGBOUNCER_UNIX_SOCKET_MODE}${nl}}\
${PGBOUNCER_UNIX_SOCKET_GROUP:+unix_socket_group = ${PGBOUNCER_UNIX_SOCKET_GROUP}${nl}}\
${PGBOUNCER_USER:+user = ${PGBOUNCER_USER}${nl}}\
${PGBOUNCER_AUTH_FILE:+auth_file = ${PGBOUNCER_AUTH_FILE}${nl}}\
${PGBOUNCER_AUTH_HBA_FILE:+auth_hba_file = ${PGBOUNCER_AUTH_HBA_FILE}${nl}}\
auth_type = ${PGBOUNCER_AUTH_TYPE:-any}
${PGBOUNCER_AUTH_USER:+auth_user = ${PGBOUNCER_AUTH_USER}${nl}}\
${PGBOUNCER_AUTH_QUERY:+auth_query = ${PGBOUNCER_AUTH_QUERY}${nl}}\
${PGBOUNCER_POOL_MODE:+pool_mode = ${PGBOUNCER_POOL_MODE}${nl}}\
${PGBOUNCER_MAX_CLIENT_CONN:+max_client_conn = ${PGBOUNCER_MAX_CLIENT_CONN}${nl}}\
${PGBOUNCER_DEFAULT_POOL_SIZE:+default_pool_size = ${PGBOUNCER_DEFAULT_POOL_SIZE}${nl}}\
${PGBOUNCER_MIN_POOL_SIZE:+min_pool_size = ${PGBOUNCER_MIN_POOL_SIZE}${nl}}\
${PGBOUNCER_RESERVE_POOL_SIZE:+reserve_pool_size = ${PGBOUNCER_RESERVE_POOL_SIZE}${nl}}\
${PGBOUNCER_RESERVE_POOL_TIMEOUT:+reserve_pool_timeout = ${PGBOUNCER_RESERVE_POOL_TIMEOUT}${nl}}\
${PGBOUNCER_MAX_DB_CONNECTIONS:+max_db_connections = ${PGBOUNCER_MAX_DB_CONNECTIONS}${nl}}\
${PGBOUNCER_MAX_USER_CONNECTIONS:+max_user_connections = ${PGBOUNCER_MAX_USER_CONNECTIONS}${nl}}\
${PGBOUNCER_SERVER_ROUND_ROBIN:+server_round_robin = ${PGBOUNCER_SERVER_ROUND_ROBIN}${nl}}\
ignore_startup_parameters = ${PGBOUNCER_IGNORE_STARTUP_PARAMETERS:-extra_float_digits}
${PGBOUNCER_DISABLE_PQEXEC:+disable_pqexec = ${PGBOUNCER_DISABLE_PQEXEC}${nl}}\
${PGBOUNCER_APPLICATION_NAME_ADD_HOST:+application_name_add_host = ${PGBOUNCER_APPLICATION_NAME_ADD_HOST}${nl}}\
${PGBOUNCER_CONFFILE:+conffile = ${PGBOUNCER_CONFFILE}${nl}}\
${PGBOUNCER_JOB_NAME:+job_name = ${PGBOUNCER_JOB_NAME}${nl}}\

# Log settings
${PGBOUNCER_SYSLOG:+syslog = ${PGBOUNCER_SYSLOG}${nl}}\
${PGBOUNCER_SYSLOG_IDENT:+syslog_ident = ${PGBOUNCER_SYSLOG_IDENT}${nl}}\
${PGBOUNCER_SYSLOG_FACILITY:+syslog_facility = ${PGBOUNCER_SYSLOG_FACILITY}${nl}}\
${PGBOUNCER_LOG_CONNECTIONS:+log_connections = ${PGBOUNCER_LOG_CONNECTIONS}${nl}}\
${PGBOUNCER_LOG_DISCONNECTIONS:+log_disconnections = ${PGBOUNCER_LOG_DISCONNECTIONS}${nl}}\
${PGBOUNCER_LOG_POOLER_ERRORS:+log_pooler_errors = ${PGBOUNCER_LOG_POOLER_ERRORS}${nl}}\
${PGBOUNCER_STATS_PERIOD:+stats_period = ${PGBOUNCER_STATS_PERIOD}${nl}}\
${PGBOUNCER_VERBOSE:+verbose = ${PGBOUNCER_VERBOSE}${nl}}\
admin_users = ${PGBOUNCER_ADMIN_USERS:-postgres}
${PGBOUNCER_STATS_USERS:+stats_users = ${PGBOUNCER_STATS_USERS}${nl}}\

# Connection sanity checks, timeouts
${PGBOUNCER_SERVER_RESET_QUERY:+server_reset_query = ${PGBOUNCER_SERVER_RESET_QUERY}${nl}}\
${PGBOUNCER_SERVER_RESET_QUERY_ALWAYS:+server_reset_query_always = ${PGBOUNCER_SERVER_RESET_QUERY_ALWAYS}${nl}}\
${PGBOUNCER_SERVER_CHECK_DELAY:+server_check_delay = ${PGBOUNCER_SERVER_CHECK_DELAY}${nl}}\
${PGBOUNCER_SERVER_CHECK_QUERY:+server_check_query = ${PGBOUNCER_SERVER_CHECK_QUERY}${nl}}\
${PGBOUNCER_SERVER_LIFETIME:+server_lifetime = ${PGBOUNCER_SERVER_LIFETIME}${nl}}\
${PGBOUNCER_SERVER_IDLE_TIMEOUT:+server_idle_timeout = ${PGBOUNCER_SERVER_IDLE_TIMEOUT}${nl}}\
${PGBOUNCER_SERVER_CONNECT_TIMEOUT:+server_connect_timeout = ${PGBOUNCER_SERVER_CONNECT_TIMEOUT}${nl}}\
${PGBOUNCER_SERVER_LOGIN_RETRY:+server_login_retry = ${PGBOUNCER_SERVER_LOGIN_RETRY}${nl}}\
${PGBOUNCER_CLIENT_LOGIN_TIMEOUT:+client_login_timeout = ${PGBOUNCER_CLIENT_LOGIN_TIMEOUT}${nl}}\
${PGBOUNCER_AUTODB_IDLE_TIMEOUT:+autodb_idle_timeout = ${PGBOUNCER_AUTODB_IDLE_TIMEOUT}${nl}}\
${PGBOUNCER_DNS_MAX_TTL:+dns_max_ttl = ${PGBOUNCER_DNS_MAX_TTL}${nl}}\
${PGBOUNCER_DNS_NXDOMAIN_TTL:+dns_nxdomain_ttl = ${PGBOUNCER_DNS_NXDOMAIN_TTL}${nl}}\

# TLS settings
${PGBOUNCER_CLIENT_TLS_SSLMODE:+client_tls_sslmode = ${PGBOUNCER_CLIENT_TLS_SSLMODE}${nl}}\
${PGBOUNCER_CLIENT_TLS_KEY_FILE:+client_tls_key_file = ${PGBOUNCER_CLIENT_TLS_KEY_FILE}${nl}}\
${PGBOUNCER_CLIENT_TLS_CERT_FILE:+client_tls_cert_file = ${PGBOUNCER_CLIENT_TLS_CERT_FILE}${nl}}\
${PGBOUNCER_CLIENT_TLS_CA_FILE:+client_tls_ca_file = ${PGBOUNCER_CLIENT_TLS_CA_FILE}${nl}}\
${PGBOUNCER_CLIENT_TLS_PROTOCOLS:+client_tls_protocols = ${PGBOUNCER_CLIENT_TLS_PROTOCOLS}${nl}}\
${PGBOUNCER_CLIENT_TLS_CIPHERS:+client_tls_ciphers = ${PGBOUNCER_CLIENT_TLS_CIPHERS}${nl}}\
${PGBOUNCER_CLIENT_TLS_ECDHCURVE:+client_tls_ecdhcurve = ${PGBOUNCER_CLIENT_TLS_ECDHCURVE}${nl}}\
${PGBOUNCER_CLIENT_TLS_DHEPARAMS:+client_tls_dheparams = ${PGBOUNCER_CLIENT_TLS_DHEPARAMS}${nl}}\
${PGBOUNCER_SERVER_TLS_SSLMODE:+server_tls_sslmode = ${PGBOUNCER_SERVER_TLS_SSLMODE}${nl}}\
${PGBOUNCER_SERVER_TLS_CA_FILE:+server_tls_ca_file = ${PGBOUNCER_SERVER_TLS_CA_FILE}${nl}}\
${PGBOUNCER_SERVER_TLS_KEY_FILE:+server_tls_key_file = ${PGBOUNCER_SERVER_TLS_KEY_FILE}${nl}}\
${PGBOUNCER_SERVER_TLS_CERT_FILE:+server_tls_cert_file = ${PGBOUNCER_SERVER_TLS_CERT_FILE}${nl}}\
${PGBOUNCER_SERVER_TLS_PROTOCOLS:+server_tls_protocols = ${PGBOUNCER_SERVER_TLS_PROTOCOLS}${nl}}\
${PGBOUNCER_SERVER_TLS_CIPHERS:+server_tls_ciphers = ${PGBOUNCER_SERVER_TLS_CIPHERS}${nl}}\

# Dangerous timeouts
${PGBOUNCER_QUERY_TIMEOUT:+query_timeout = ${PGBOUNCER_QUERY_TIMEOUT}${nl}}\
${PGBOUNCER_QUERY_WAIT_TIMEOUT:+query_wait_timeout = ${PGBOUNCER_QUERY_WAIT_TIMEOUT}${nl}}\
${PGBOUNCER_CLIENT_IDLE_TIMEOUT:+client_idle_timeout = ${PGBOUNCER_CLIENT_IDLE_TIMEOUT}${nl}}\
${PGBOUNCER_IDLE_TRANSACTION_TIMEOUT:+idle_transaction_timeout = ${PGBOUNCER_IDLE_TRANSACTION_TIMEOUT}${nl}}\
${PGBOUNCER_PKT_BUF:+pkt_buf = ${PGBOUNCER_PKT_BUF}${nl}}\
${PGBOUNCER_MAX_PACKET_SIZE:+max_packet_size = ${PGBOUNCER_MAX_PACKET_SIZE}${nl}}\
${PGBOUNCER_LISTEN_BACKLOG:+listen_backlog = ${PGBOUNCER_LISTEN_BACKLOG}${nl}}\
${PGBOUNCER_SBUF_LOOPCNT:+sbuf_loopcnt = ${PGBOUNCER_SBUF_LOOPCNT}${nl}}\
${PGBOUNCER_SUSPEND_TIMEOUT:+suspend_timeout = ${PGBOUNCER_SUSPEND_TIMEOUT}${nl}}\
${PGBOUNCER_TCP_DEFER_ACCEPT:+tcp_defer_accept = ${PGBOUNCER_TCP_DEFER_ACCEPT}${nl}}\
${PGBOUNCER_TCP_KEEPALIVE:+tcp_keepalive = ${PGBOUNCER_TCP_KEEPALIVE}${nl}}\
${PGBOUNCER_TCP_KEEPCNT:+tcp_keepcnt = ${PGBOUNCER_TCP_KEEPCNT}${nl}}\
${PGBOUNCER_TCP_KEEPIDLE:+tcp_keepidle = ${PGBOUNCER_TCP_KEEPIDLE}${nl}}\
${PGBOUNCER_TCP_KEEPINTVL:+tcp_keepintvl = ${PGBOUNCER_TCP_KEEPINTVL}${nl}}
EOF

    if [ -z "$QUIET" ]; then
        cat ${PG_CONFIG_DIR}/pgbouncer.ini
    fi
}

start_app(){
    echo "Starting pgbouncer."
    exec /opt/pgbouncer/pgbouncer ${QUIET:+-q} -u ${PG_USER} ${PG_CONFIG_DIR}/pgbouncer.ini
}

invoke_main
