DROP TABLE ASTRO.YALE;

CREATE TABLE IF NOT EXISTS astro.YALE(
    id integer,
    name varchar(12),
    hd_id integer,
    ads_id integer,
    variable varchar(10),
    ra varchar(12),
    dec varchar(12),
    visual_magnitude numeric(5,3),
    bv_magnitude numeric(5,3),
    spectral_type_full varchar(20),
    spectral_type varchar(1),
    spectral_type_sub varchar(3),
    intensity varchar(4),
    mt_wilson varchar(2),
    note_flag varchar(1)
);

CREATE OR REPLACE FUNCTION ASTRO.PROCESS_YALE_INPUT() RETURNS TRIGGER
language plpgsql AS $$
DECLARE
    S_T_REGEXP CONSTANT TEXT = '^([sd|d|sg|g|c])?([O|B|A|F|G|K|M|S|C])?(\d\.?\d?)?(IX|IV|V?I{0,3})?\w*';
    REGEXP_ARRAY TEXT[];
BEGIN
    NEW.NAME = TRIM(NEW.NAME);
    NEW.RA = TRIM(NEW.RA);
    NEW.DEC = TRIM(NEW.DEC);
    NEW.SPECTRAL_TYPE_FULL = TRIM(NEW.SPECTRAL_TYPE_FULL);
    IF NEW.SPECTRAL_TYPE_FULL ~ S_T_REGEXP THEN
        REGEXP_ARRAY = REGEXP_MATCHES(NEW.SPECTRAL_TYPE_FULL, S_T_REGEXP);
        NEW.MT_WILSON = TRIM(REGEXP_ARRAY[1]);
        NEW.SPECTRAL_TYPE = TRIM(REGEXP_ARRAY[2]);
        IF NEW.SPECTRAL_TYPE = '' THEN
            NEW.SPECTRAL_TYPE = NULL;
        END IF;
        NEW.SPECTRAL_TYPE_SUB = TRIM(REGEXP_ARRAY[3]);
        IF NEW.SPECTRAL_TYPE_SUB = '' THEN
            NEW.SPECTRAL_TYPE_SUB = NULL;
        END IF;
        NEW.INTENSITY = TRIM(REGEXP_ARRAY[4]);
        IF NEW.INTENSITY = '' THEN
            NEW.INTENSITY = NULL;
        END IF;
        IF NEW.NOTE_FLAG = '' THEN
            NEW.NOTE_FLAG = NULL;
        END IF;
    END IF;
    RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER TR_YALE_BEFORE_INSERT BEFORE INSERT ON ASTRO.YALE
    FOR EACH ROW
    EXECUTE PROCEDURE ASTRO.PROCESS_YALE_INPUT();

-- stop here and import the CSV

alter table astro.yale add constraint pk_yale primary key(id);

create index idx_yale_hdid on astro.yale(hd_id);

DROP TABLE YALE_NOTES;

CREATE TABLE IF NOT EXISTS astro.YALE_NOTES(
    id integer,
    yale_id integer,
    note_count integer,
    remark_abbr varchar(10),
    remark varchar(2000)
);

CREATE OR REPLACE FUNCTION ASTRO.PROCESS_YALE_NOTES() RETURNS TRIGGER
language plpgsql AS $$
BEGIN
    NEW.REMARK_ABBR = TRIM(NEW.REMARK_ABBR);
    RETURN NEW;
END $$;

CREATE OR REPLACE TRIGGER TR_YALENOTES_BEFORE_INSERT BEFORE INSERT ON ASTRO.YALE_NOTES
    FOR EACH ROW
    EXECUTE PROCEDURE ASTRO.PROCESS_YALE_NOTES();

-- stop here and import the CSV

alter table astro.yale_notes add constraint pk_yalenotes primary key(id);

create index idx_yalenote_yaleid on astro.yale_notes(yale_id);