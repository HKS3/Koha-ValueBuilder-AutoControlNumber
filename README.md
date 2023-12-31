# Koha-ValueBuilder-AutoControlNumber
auto-generate next value for controlnumber

# create sequence

run this command in your mysql DB to find the highest control-number in existence.

```
SELECT MAX(ExtractValue(metadata,'//controlfield[@tag="001"]')) CURRENT_MAX_CONTROLNUMBER FROM biblio_metadata;
```

use this value to pick the start value of your sequence. the start value should be higher then the currently highest control-number. 

```
mysql --user=koha_MYUSER --password='MYPASSWORD' koha_MYBIB
CREATE SEQUENCE AUTO_CONTROL_NUMBER_SEQUENCE START WITH 100000;
```

# installation
```
cp marc21_field_001_autocontrolnumber.pl /usr/share/koha/intranet/cgi-bin/cataloguing/value_builder/
```

# configure staff interface
go to `/cgi-bin/koha/admin/marc_subfields_structure.pl?op=add_form&tagfield=001&frameworkcode=ABC`

replace `ABC`  with your framework code.

select `marc21_field_001_autocontrolnumber.pl` from the `plugin` drop down menu.

# AUTHORS

- David Schmidt <mail@davidschmidt.at>
- Thomas Klausner <domm@plix.at>
- Mark Hofstetter <cpan@trust-box.at>

# COPYRIGHT AND LICENSE

This software is copyright (c) 2022 by David Schmidt.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.
