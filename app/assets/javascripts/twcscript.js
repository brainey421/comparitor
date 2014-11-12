$(document).ready(function() {
	$('body').on('click', 'button#rank1', function()
	{
		rank1 = $('[name=rank1]').val();
		rank2 = $('[name=rank2]').val();
		rank3 = $('[name=rank3]').val();
		
		if (rank2 == '0' && rank3 == '0') {
			$('[name=rank1]').val('1');
		
			$('div#item1').html('<p>First!</p>');
			$('div#item2').html('<button id="tie2" accesskey="w" type="button" class="btn btn-primary">tie for first</button> <button id="rank2" accesskey="2" type="button" class="btn btn-primary">rank second</button>');
			$('div#item3').html('<button id="tie3" accesskey="e" type="button" class="btn btn-primary">tie for first</button> <button id="rank3" accesskey="3" type="button" class="btn btn-primary">rank second</button>');
		}
		else if (rank2 == '1' && rank3 == '0') {
			$('[name=rank1]').val('2');
			
			$('div#item1').html('<p>Second!</p>');
			$('div#item3').html('<button id="tie3" accesskey="e" type="button" class="btn btn-primary">tie for second</button> <button id="rank3" accesskey="3" type="button" class="btn btn-primary">rank third</button>');
		}
		else if (rank2 == '0' && rank3 == '1') {
			$('[name=rank1]').val('2');
			
			$('div#item1').html('<p>Second!</p>');
			$('div#item2').html('<button id="tie2" accesskey="w" type="button" class="btn btn-primary">tie for second</button> <button id="rank2" accesskey="2" type="button" class="btn btn-primary">rank third</button>');
		}
		else if (rank2 == '1' && rank3 == '1') {
			$('[name=rank1]').val('2');
			
			$('div#item1').html('<p>Second!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
		else {
			$('[name=rank1]').val('3');
			
			$('div#item1').html('<p>Third!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
	});
	
	$('body').on('click', 'button#rank2', function()
	{
		rank1 = $('[name=rank1]').val();
		rank2 = $('[name=rank2]').val();
		rank3 = $('[name=rank3]').val();
		
		if (rank1 == '0' && rank3 == '0') {
			$('[name=rank2]').val('1');
		
			$('div#item1').html('<button id="tie1" accesskey="q" type="button" class="btn btn-primary">tie for first</button> <button id="rank1" accesskey="1" type="button" class="btn btn-primary">rank second</button>');
			$('div#item2').html('<p>First!</p>');
			$('div#item3').html('<button id="tie3" accesskey="e" type="button" class="btn btn-primary">tie for first</button> <button id="rank3" accesskey="3" type="button" class="btn btn-primary">rank second</button>');
		}
		else if (rank1 == '1' && rank3 == '0') {
			$('[name=rank2]').val('2');
			
			$('div#item2').html('<p>Second!</p>');
			$('div#item3').html('<button id="tie3" accesskey="e" type="button" class="btn btn-primary">tie for second</button> <button id="rank3" accesskey="3" type="button" class="btn btn-primary">rank third</button>');
		}
		else if (rank1 == '0' && rank3 == '1') {
			$('[name=rank2]').val('2');
			
			$('div#item1').html('<button id="tie1" accesskey="q" type="button" class="btn btn-primary">tie for second</button> <button id="rank1" accesskey="1" type="button" class="btn btn-primary">rank third</button>');
			$('div#item2').html('<p>Second!</p>');
		}
		else if (rank1 == '1' && rank3 == '1') {
			$('[name=rank2]').val('2');
			
			$('div#item2').html('<p>Second!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
		else {
			$('[name=rank2]').val('3');
			
			$('div#item2').html('<p>Third!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
	});
	
	$('body').on('click', 'button#rank3', function()
	{
		rank1 = $('[name=rank1]').val();
		rank2 = $('[name=rank2]').val();
		rank3 = $('[name=rank3]').val();
		
		if (rank1 == '0' && rank2 == '0') {
			$('[name=rank3]').val('1');
		
			$('div#item1').html('<button id="tie1" accesskey="q" type="button" class="btn btn-primary">tie for first</button> <button id="rank1" accesskey="1" type="button" class="btn btn-primary">rank second</button>');
			$('div#item2').html('<button id="tie2" accesskey="w" type="button" class="btn btn-primary">tie for first</button> <button id="rank2" accesskey="2" type="button" class="btn btn-primary">rank second</button>');
			$('div#item3').html('<p>First!</p>');
		}
		else if (rank1 == '1' && rank2 == '0') {
			$('[name=rank3]').val('2');
			
			$('div#item2').html('<button id="tie2" accesskey="w" type="button" class="btn btn-primary">tie for second</button> <button id="rank2" accesskey="2" type="button" class="btn btn-primary">rank third</button>');
			$('div#item3').html('<p>Second!</p>');
		}
		else if (rank1 == '0' && rank2 == '1') {
			$('[name=rank3]').val('2');
			
			$('div#item1').html('<button id="tie1" accesskey="q" type="button" class="btn btn-primary">tie for second</button> <button id="rank1" accesskey="1" type="button" class="btn btn-primary">rank third</button>');
			$('div#item3').html('<p>Second!</p>');
		}
		else if (rank1 == '1' && rank2 == '1') {
			$('[name=rank3]').val('2');
			
			$('div#item3').html('<p>Second!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
		else {
			$('[name=rank3]').val('3');
			
			$('div#item3').html('<p>Third!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
	});
	
	$('body').on('click', 'button#tie1', function()
	{
		rank1 = $('[name=rank1]').val();
		rank2 = $('[name=rank2]').val();
		rank3 = $('[name=rank3]').val();
		
		if (rank2 == '1' && rank3 == '0') {
			$('[name=rank1]').val('1');
			
			$('div#item1').html('<p>First!</p>');
			$('div#item3').html('<button id="tie3" accesskey="e" type="button" class="btn btn-primary">tie for first</button> <button id="rank3" accesskey="3" type="button" class="btn btn-primary">rank second</button>');
		}
		else if (rank2 == '0' && rank3 == '1') {
			$('[name=rank1]').val('1');
			
			$('div#item1').html('<p>First!</p>');
			$('div#item2').html('<button id="tie2" accesskey="w" type="button" class="btn btn-primary">tie for first</button> <button id="rank2" accesskey="2" type="button" class="btn btn-primary">rank second</button>');
		}
		else if (rank2 == '1' && rank3 == '1') {
			$('[name=rank1]').val('1');
			
			$('div#item1').html('<p>First!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
		else {
			$('[name=rank1]').val('2');
			
			$('div#item1').html('<p>Second!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
	});
	
	$('body').on('click', 'button#tie2', function()
	{
		rank1 = $('[name=rank1]').val();
		rank2 = $('[name=rank2]').val();
		rank3 = $('[name=rank3]').val();
		
		if (rank1 == '1' && rank3 == '0') {
			$('[name=rank2]').val('1');
			
			$('div#item2').html('<p>First!</p>');
			$('div#item3').html('<button id="tie3" accesskey="e" type="button" class="btn btn-primary">tie for first</button> <button id="rank3" accesskey="3" type="button" class="btn btn-primary">rank second</button>');
		}
		else if (rank1 == '0' && rank3 == '1') {
			$('[name=rank2]').val('1');
			
			$('div#item1').html('<button id="tie1" accesskey="q" type="button" class="btn btn-primary">tie for first</button> <button id="rank1" accesskey="1" type="button" class="btn btn-primary">rank second</button>');
			$('div#item2').html('<p>First!</p>');
		}
		else if (rank1 == '1' && rank3 == '1') {
			$('[name=rank2]').val('1');
			
			$('div#item2').html('<p>First!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
		else {
			$('[name=rank2]').val('2');
			
			$('div#item2').html('<p>Second!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
	});
	
	$('body').on('click', 'button#tie3', function()
	{
		rank1 = $('[name=rank1]').val();
		rank2 = $('[name=rank2]').val();
		rank3 = $('[name=rank3]').val();
		
		if (rank1 == '1' && rank2 == '0') {
			$('[name=rank3]').val('1');
			
			$('div#item2').html('<button id="tie2" accesskey="w" type="button" class="btn btn-primary">tie for first</button> <button id="rank2" accesskey="2" type="button" class="btn btn-primary">rank second</button>');
			$('div#item3').html('<p>First!</p>');
		}
		else if (rank1 == '0' && rank2 == '1') {
			$('[name=rank3]').val('1');
			
			$('div#item1').html('<button id="tie1" accesskey="q" type="button" class="btn btn-primary">tie for first</button> <button id="rank1" accesskey="1" type="button" class="btn btn-primary">rank second</button>');
			$('div#item3').html('<p>First!</p>');
		}
		else if (rank1 == '1' && rank2 == '1') {
			$('[name=rank3]').val('1');
			
			$('div#item3').html('<p>First!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
		else {
			$('[name=rank3]').val('2');
			
			$('div#item3').html('<p>Second!</p>');
			$('button#submit').attr('style', 'display: inline-block;');
		}
	});
	
	$('body').on('click', 'button#restart', function()
	{
		$('[name=rank1]').val('0');
		$('[name=rank2]').val('0');
		$('[name=rank3]').val('0');
		
		$('div#item1').html('<button id="rank1" accesskey="1" type="button" class="btn btn-primary">rank first</button>');
		$('div#item2').html('<button id="rank2" accesskey="2" type="button" class="btn btn-primary">rank first</button>');
		$('div#item3').html('<button id="rank3" accesskey="3" type="button" class="btn btn-primary">rank first</button>');
		$('button#submit').attr('style', 'display: none;');
	});
});
