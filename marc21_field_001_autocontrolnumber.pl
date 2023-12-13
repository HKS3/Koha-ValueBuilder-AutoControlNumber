#!/usr/bin/perl

# Copyright 2023 HKS3

use Modern::Perl;
use C4::Context;

my $builder = sub {
    my ( $params ) = @_;
    my $function_name = $params->{id};

    my $dbh = C4::Context->dbh;
    my $seq = 'AUTO_CONTROL_NUMBER_SEQUENCE';
    my $sth = $dbh->prepare("SELECT NEXTVAL($seq)");
    $sth->execute;
    my $val;
    if ( my $new_seq_value = $sth->fetchrow ) {
        $val = $new_seq_value;
    }
    else {
        $val = 'ERROR';
    }

    my $res = <<'EOJS';
<script type="text/javascript">
//<![CDATA[

$(document).ready(function() {
    if(!document.getElementById('%id%').value){
        document.getElementById('%id%').value = '%val%';
    }
});

//]]>
</script>

EOJS

    $res=~s/%id%/$function_name/g;
    $res=~s/%val%/$val/g;

    return $res;
};

return { builder => $builder };
