#!/usr/bin/perl

# Copyright 2023 HKS3
# https://github.com/HKS3/Koha-ValueBuilder-AutoControlNumber

use Modern::Perl;
use C4::Context;

my $builder = sub {
    my ( $params ) = @_;

    my $dbh = C4::Context->dbh;
    my $seq = 'AUTO_CONTROL_NUMBER_SEQUENCE';
    my $nextval_sth = $dbh->prepare("SELECT NEXTVAL($seq)");
    my $extract_sth = $dbh->prepare(q{SELECT biblionumber FROM biblio_metadata WHERE ExtractValue(metadata,'//controlfield[@tag="001"]') = ?});

    my $controlnumber_exists = sub {
        my $cn = shift;
        $extract_sth->execute($cn);
        my $biblionumber = $extract_sth->fetchrow();
	warn "controlnumber $cn already in use by biblionumber: $biblionumber"
	  if defined $biblionumber;
        return defined $biblionumber;
    };

    my $get_controlnumber = sub {
        my $cn;

        do {
            $nextval_sth->execute();
            $cn = $nextval_sth->fetchrow();
            if (!defined $cn) {
                die "there was an error while fetching nextval from sequence '$seq'";
            }
        } while ( $controlnumber_exists->($cn) );

        return $cn;
    };

    my $build_js = sub {
        my ($id, $cn) = @_;
        my $js = <<"EOJS";
<script type="text/javascript">
//<![CDATA[

\$(document).ready(function() {
    if(!document.getElementById('$id').value){
        document.getElementById('$id').value = '$cn';
    }
});

//]]>
</script>

EOJS

        return $js;
    };

    my $id = $params->{id};
    my $cn = $get_controlnumber->();
    my $js = $build_js->($id, $cn);
    return $js;
};

return { builder => $builder };
