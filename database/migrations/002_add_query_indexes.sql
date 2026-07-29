BEGIN;

CREATE INDEX hotel_bookings_city_created_at_covering_idx
    ON hotel_bookings (city, created_at DESC)
    INCLUDE (org_id, status, amount);

CREATE INDEX booking_events_booking_created_at_idx
    ON booking_events (booking_id, created_at DESC);

COMMIT;
