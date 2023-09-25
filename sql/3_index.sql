alter table isu_condition add index uuid_timestamp_desc(jia_isu_uuid,timestamp DESC);
alter table `isu` add index `character_idx`(`character`);