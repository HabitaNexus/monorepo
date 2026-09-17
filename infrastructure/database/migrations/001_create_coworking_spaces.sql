CREATE TABLE coworking_spaces (
    id UUID PRIMARY KEY DEFAULT gen_random_uuid(),
    name TEXT NOT NULL,
    latitude DOUBLE PRECISION NOT NULL,
    longitude DOUBLE PRECISION NOT NULL,
    type TEXT NOT NULL CHECK (type IN ('cafe', 'coworking', 'ceci')),
    address TEXT NOT NULL DEFAULT '',
    description TEXT NOT NULL DEFAULT '',
    wifi_speed_mbps DOUBLE PRECISION,
    noise_level TEXT NOT NULL DEFAULT 'moderate' CHECK (noise_level IN ('quiet', 'moderate', 'lively')),
    hours TEXT NOT NULL DEFAULT '',
    outlets_available INTEGER NOT NULL DEFAULT 0,
    day_pass_price_usd DOUBLE PRECISION,
    monthly_membership_price_usd DOUBLE PRECISION,
    photo_url TEXT NOT NULL DEFAULT '',
    partnership_status TEXT NOT NULL DEFAULT 'none' CHECK (partnership_status IN ('none', 'pending', 'active', 'former')),
    has_parking BOOLEAN NOT NULL DEFAULT false,
    has_food BOOLEAN NOT NULL DEFAULT false,
    rating DOUBLE PRECISION NOT NULL DEFAULT 0.0,
    created_at TIMESTAMPTZ NOT NULL DEFAULT now(),
    updated_at TIMESTAMPTZ NOT NULL DEFAULT now()
);

CREATE INDEX idx_coworking_spaces_type ON coworking_spaces (type);
CREATE INDEX idx_coworking_spaces_location ON coworking_spaces (latitude, longitude);
CREATE INDEX idx_coworking_spaces_partnership ON coworking_spaces (partnership_status);

ALTER TABLE coworking_spaces ENABLE ROW LEVEL SECURITY;

CREATE POLICY "coworking_spaces_select_public"
    ON coworking_spaces
    FOR SELECT
    USING (true);

CREATE POLICY "coworking_spaces_insert_admin"
    ON coworking_spaces
    FOR INSERT
    WITH CHECK (auth.role() = 'authenticated');

CREATE POLICY "coworking_spaces_update_admin"
    ON coworking_spaces
    FOR UPDATE
    USING (auth.role() = 'authenticated');

CREATE POLICY "coworking_spaces_delete_admin"
    ON coworking_spaces
    FOR DELETE
    USING (auth.role() = 'authenticated');
