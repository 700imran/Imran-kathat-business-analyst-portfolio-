-- Nightly verification (FR-09): returns the first broken record; zero rows = chain intact.
WITH ordered AS (
  SELECT seq, prev_hash, record_hash, payload, ts_utc,
         LAG(record_hash) OVER (ORDER BY seq) AS expected_prev,
         encode(digest(prev_hash || payload::text || to_char(ts_utc AT TIME ZONE 'UTC','YYYY-MM-DD"T"HH24:MI:SS.US'), 'sha256'), 'hex') AS recomputed
  FROM audit_event)
SELECT seq FROM ordered
WHERE (expected_prev IS NOT NULL AND prev_hash <> expected_prev) OR record_hash <> recomputed
ORDER BY seq LIMIT 1;   -- requires pgcrypto: CREATE EXTENSION pgcrypto;
