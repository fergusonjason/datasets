CREATE SCHEMA IF NOT EXISTS astro;

create table IF NOT EXISTS astro.hd(
    id integer NOT NULL,
    hd_id integer NOT NULL,
    dm varchar(12),
    photovisual_magnitude numeric(5,2),
    photographic_magnitude numeric(5,2),
    spectral_type_full varchar(3),
    spectral_type varchar(1),
    intensity integer,
    ra varchar(12),
    dec varchar(12)
);

alter table astro.hd
    add constraint pk_hd PRIMARY KEY (id);

create index idx_hd_hdid on astro.hd (hd_id);

create index idx_hd_spectype on astro.hd (spectral_type);
