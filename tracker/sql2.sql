alter table users
add constraint ucagefirst check(age > 13),
add constraint ucagesecond check (age < 100);

alter table cs
add constraint ccwinratefirst check(winrate < 101),
add constraint ccwinratesecond check (winrate > -1);

alter table dota
add constraint dcwinratefirst check(winrate < 101),
add constraint dcwinratesecond check (winrate > -1);

alter table valorant
add constraint vcwinratefirst check(winrate < 101),
add constraint vcwinratesecond check (winrate > -1);

alter table id_table
add constraint userid FOREIGN KEY (users_id) REFERENCES users(users_id) ON DELETE CASCADE,
add constraint formid FOREIGN KEY (form_id) REFERENCES form(form_id) ON DELETE CASCADE,
add constraint csid FOREIGN KEY (cs_id) REFERENCES cs(cs_id) ON DELETE CASCADE,
add constraint dotaid FOREIGN KEY (dota_id) REFERENCES dota(dota_id) ON DELETE CASCADE,
add constraint valorantid FOREIGN KEY (valorant_id) REFERENCES valorant(valorant_id) ON DELETE CASCADE;

alter table form
add constraint fid FOREIGN KEY (form_id) REFERENCES users(users_id) ON DELETE CASCADE;

alter table cs
add constraint cid FOREIGN KEY (cs_id) REFERENCES users(users_id) ON DELETE CASCADE;

alter table dota
add constraint did FOREIGN KEY (dota_id) REFERENCES users(users_id) ON DELETE CASCADE;

alter table valorant
add constraint vid FOREIGN KEY (valorant_id) REFERENCES users(users_id) ON DELETE CASCADE;