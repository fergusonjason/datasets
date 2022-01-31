CREATE SCHEMA IF NOT EXISTS astro;

CREATE TABLE IF NOT EXISTS astro.gliese (
    id integer NOT NULL,
    name varchar(20),
    component varchar(2),
    ra varchar(12),
    "dec" varchar(12),
    proper_motion numeric(5,3),
    proper_motion_dir numeric(5,1),
    radial_velocity numeric(6,1),
    spectral_type_full varchar(10),
    spectral_type character(1),
    spectral_type_sub varchar(10),
    luminosity_class varchar(10),
    visual_magnitude numeric(5,2),
    absolute_magnitude numeric(5,2),
    parallax numeric(5,2),
    bv_color numeric(3,2),
    hd_number integer
);

ALTER TABLE ONLY astro.gliese
    ADD CONSTRAINT pk_gliese PRIMARY KEY (id);

CREATE INDEX idx_gliese_name ON astro.gliese USING btree (name);

CREATE INDEX idx_gliese_spectype ON astro.gliese USING btree (spectral_type);