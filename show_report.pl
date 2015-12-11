use Data::Dumper;
use Products;

#
# 1. define product here
#
my %prodhash = ("AAA" => "0", 
					"BBB" => "1", 
					"CCC" => "2");

#
# 2. define quarter group here
#
my %quarter_group;
$quarter_group{"1"}{"1"} = "oct";
$quarter_group{"1"}{"2"} = "nov";
$quarter_group{"1"}{"3"} = "dec";
$quarter_group{"2"}{"1"} = "jan";
$quarter_group{"2"}{"2"} = "feb";
$quarter_group{"2"}{"3"} = "mar";
$quarter_group{"3"}{"1"} = "apr";
$quarter_group{"3"}{"2"} = "may";
$quarter_group{"3"}{"3"} = "jun";
$quarter_group{"4"}{"1"} = "jul";
$quarter_group{"4"}{"2"} = "aug";
$quarter_group{"4"}{"3"} = "sep";

#
# 3. the quarter that need to be used for reporting
#    "2" -> jan to mar
$quarter="2";


#
# 4. check user name
#
my $perlname = $0;
my @mynames = split(/_/, $0);
my $fname = @mynames;
if ( $#mynames != 1 ) {
	printf( "your perl file name is not in a correct format.\n" );
	exit;
}

print "Reporting Tool. Enter your first Name:";
chop ( $input = <STDIN> );

while ( lc( $input ) ne lc( @mynames[0] ) ) {
	
	if ( $input eq "" ) {
		exit;
	}

	if ( $input ne @mynames[0] ) {
		print( "*Invalid name! Enter your first Name:" );
	}
	chop ( $input = <STDIN> );
}


#
# 5. get price info, sold unit and tax ratio
#
my $products = new Products();
my @produtinfo = $products->get_product_info();
my $taxratio = $products->{income_tax};


#
# 6. show report
#
print("\n");
print("Report Prepared for $input\n");
print("====================================================\n");
print("Product    Gross      Net after     Earnings\n");
print("           Sales      " . $taxratio . " tx       Ratio\n");
print("----------------------------------------------------\n");


@products = keys %prodhash;

foreach $product (reverse sort @products ) {

	my %priceinfo = getprice( $product );

	my $soldunit = getsoldunit ( $product, $quarter );
	
	$grosssales = $soldunit * $priceinfo{"retail"};
	
	$grossprofit = $grosssales -	$soldunit * $priceinfo{"unit"};

	$tax = $grossprofit * $taxratio;

	$netprofit =  $grossprofit - $tax;

	if ( $grosssales > 0 ) {
		$earningsratio = 100 * $netprofit / $grosssales;
	} else {
		$earningsratio = 0;
	}

	printf( "%-10s %-10s %-13s %-9s\n", 
				$product, 
				sprintf( "%.2f", $grosssales ), 
				sprintf( "%.2f", $netprofit ), 
				sprintf( "%.2f", $earningsratio ) );

}	



#
# sub getprice
#
sub getprice {
	my $product = shift;

	my %price;
	$price{"retail"} = $produtinfo[0][$prodhash{$product}]{'price'}{'retail'};
	$price{"unit"} = $produtinfo[0][$prodhash{$product}]{'price'}{'unit'};

	return %price;
}



#
# sub getsoldunit
#
sub getsoldunit {
	my ( $product, $quarter ) = @_;
	my @monthkeys = ( "1", "2", "3" );
	my $units = 0;

	my @monthnames = ( $quarter_group{$quarter}{"1"}, 
				$quarter_group{$quarter}{"2"}, 
				$quarter_group{$quarter}{"3"} );
	
	foreach $month ( @monthnames ) {
		my $file = "Data/" . $product . "_" . $month . "_units_sold.txt";
		#printf("$file\n");

		if ( -e $file ) {
			open my $handle, '<', $file;
			chomp(my @lines = <$handle>);
			close $handle;

			foreach $unit ( @lines ) {

				if ( $unit =~ /^[0-9,.E]+$/  && $unit > 0 ) {
					#printf( "valid sold unit=" . $unit . "\n" );
					$units = $units + $unit;

				} else {
					$units = $units - 5;
					#printf("invalid sold unit=" . $unit . "\n");
				}
					
			} 

		}else {
				#printf("$file does not exist\n");
		}
	}
	
	return $units;

}


