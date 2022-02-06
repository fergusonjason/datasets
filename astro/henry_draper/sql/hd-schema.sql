CREATE SCHEMA IF NOT EXISTS astro;

create table IF NOT EXISTS astro.hd(
    id integer NOT NULL,
    hd_id integer NOT NULL,
    dm varchar(12),
    photovisual_magnitude numeric(5,2),
    photographic_magnitude numeric(5,2),
    spectral_type_full varchar(3),
    spectral_type varchar(1),
    spectral_type_sub varchar(1),
    intensity integer,
    ra varchar(12),
    dec varchar(12)
);

create or replace function astro.process_hd() returns TRIGGER
language plpgsql AS $$
DECLARE
    S_T_REGEXP CONSTANT TEXT = '^(O|B|A|F|G|K|M)?([0-9])?';
    REGEXP_ARRAY TEXT[];
BEGIN
    NEW.DM = TRIM(NEW.DM);
    NEW.SPECTRAL_TYPE_FULL = TRIM(NEW.SPECTRAL_TYPE_FULL);
    REGEXP_ARRAY = REGEXP_MATCH(NEW.SPECTRAL_TYPE_FULL, S_T_REGEXP);
    NEW.SPECTRAL_TYPE = REGEXP_ARRAY[1];
    NEW.SPECTRAL_TYPE_SUB = REGEXP_ARRAY[2];
    -- NEW.INTENSITY = TRIM(NEW.INTENSITY);
    -- IF NEW.INTENSITY = '' THEN
    --     NEW.INTENSITY = NULL;
    -- END IF;
    RETURN NEW;
END $$;

DROP TRIGGER IF EXISTS tr_hd_before_insert;

create or replace trigger astro.tr_hd_before_insert before insert on astro.hd
    for each row
    execute procedure astro.process_hd();


alter table astro.hd
    add constraint pk_hd PRIMARY KEY (id);

create index idx_hd_hdid on astro.hd (hd_id);

create index idx_hd_spectype on astro.hd (spectral_type);
