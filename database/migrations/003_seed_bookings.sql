BEGIN;

WITH booking_source AS (
    SELECT sequence_number
    FROM generate_series(1, 120) AS sequence_number
)
INSERT INTO hotel_bookings (
    id,
    org_id,
    hotel_id,
    city,
    checkin_date,
    checkout_date,
    amount,
    status,
    created_at
)
SELECT
    md5('booking-' || sequence_number)::UUID,
    md5('organization-' || (((sequence_number - 1) % 5) + 1))::UUID,
    'hotel-' || lpad((((sequence_number - 1) % 20) + 1)::TEXT, 3, '0'),
    (ARRAY['delhi', 'mumbai', 'bengaluru', 'jaipur', 'goa'])
        [((sequence_number - 1) % 5) + 1],
    CURRENT_DATE + ((sequence_number % 90) + 1),
    CURRENT_DATE + ((sequence_number % 90) + 1) + ((sequence_number % 5) + 1),
    round((1500 + (sequence_number * 137.45))::NUMERIC, 2),
    (ARRAY['pending', 'confirmed', 'completed', 'cancelled'])
        [((sequence_number - 1) % 4) + 1],
    CURRENT_TIMESTAMP
        - ((sequence_number % 60) * INTERVAL '1 day')
        - ((sequence_number % 24) * INTERVAL '1 hour')
FROM booking_source
ON CONFLICT (id) DO NOTHING;

WITH event_source AS (
    SELECT sequence_number
    FROM generate_series(1, 80) AS sequence_number
)
INSERT INTO booking_events (
    booking_id,
    event_type,
    payload,
    created_at
)
SELECT
    md5('booking-' || sequence_number)::UUID,
    CASE sequence_number % 3
        WHEN 0 THEN 'booking_confirmed'
        WHEN 1 THEN 'booking_created'
        ELSE 'payment_recorded'
    END,
    jsonb_build_object(
        'source', 'seed',
        'sequence', sequence_number
    ),
    CURRENT_TIMESTAMP
        - ((sequence_number % 60) * INTERVAL '1 day')
        - ((sequence_number % 24) * INTERVAL '1 hour')
FROM event_source
WHERE NOT EXISTS (
    SELECT 1
    FROM booking_events AS existing_event
    WHERE existing_event.booking_id =
        md5('booking-' || event_source.sequence_number)::UUID
      AND existing_event.payload ->> 'source' = 'seed'
);

ANALYZE hotel_bookings;
ANALYZE booking_events;

COMMIT;
