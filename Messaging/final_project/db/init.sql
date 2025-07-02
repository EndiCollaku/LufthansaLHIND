CREATE TABLE IF NOT EXISTS edits (
    event_id BIGINT PRIMARY KEY,
    title TEXT,
    username TEXT,
    is_bot BOOLEAN,
    comment TEXT,
    timestamp TIMESTAMP,
    wiki TEXT
);

CREATE TABLE IF NOT EXISTS logs (
    event_id BIGINT PRIMARY KEY,
    title TEXT,
    username TEXT,
    is_bot BOOLEAN,
    comment TEXT,
    timestamp TIMESTAMP,
    wiki TEXT
);
