package Products;


sub new{

	my $class    = shift;
	my $tax      = sprintf("%.2f", rand);

	my $self     = {
                    income_tax => $tax 
		     	};

	bless $self, $class;


}

sub get_product_info {

	my $self = shift;
	my $product_group = [
		
		 {
			"product_id" 	=> "AAA",
			"price" 	    => {
                                "retail" => 8.37, 
                                "unit"   => 6.46
			}
		 },
		 {
			"product_id" 	=> "BBB",
            "price" 	    => {
                                "retail"  => 8.84, 
                                "unit" 	  => 6.24
			}
		 },	
		 {
			"product_id" 	=> "CCC",
            "price" 	    => {
                                "retail"  => 9.24, 
                                "unit" 	  => 4.76
			}
		 }
		
	];
	
	return $product_group;

}

1;

