# Koha-ValueBuilder-AutoControlNumber
auto-generate next value for controlnumber

# create sequence
```
mysql --user=koha_MYUSER --password='MYPASSWORD' koha_MYBIB
CREATE SEQUENCE AUTO_CONTROL_NUMBER_SEQUENCE START WITH 100000;
```

# install
```
cp marc21_field_001_autocontrolnumber.pl /usr/share/koha/intranet/cgi-bin/cataloguing/value_builder/
```

# configure staff interface
go to `/cgi-bin/koha/admin/marc_subfields_structure.pl?op=add_form&tagfield=001&frameworkcode=ABC`

replace `ABC`  with your framework code.

select `marc21_field_001_autocontrolnumber.pl` from the `plugin` drop down menu.
