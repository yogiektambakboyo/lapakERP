@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Home')

@push('scripts')
	<script src="/assets/js/render.highlight.js"></script>
@endpush

@if(!auth()->check())
	<script>window.location = "/login";</script>
@endif

@section('content')
	<!-- BEGIN page-header -->
	<h1 class="page-header">@lang('home.welcome'), @auth
		{{auth()->user()->name}} 
	@endauth </h1>
	<!-- END page-header -->
	
	<!-- BEGIN row -->
	<div class="row">
		<!-- BEGIN col-6 -->
		
	</div>
@endsection

@push('scripts')
<script>
	$("#default-daterange").daterangepicker({
	  opens: "right",
	  format: "MM/DD/YYYY",
	  separator: " to ",
	  startDate: moment().subtract("days", 29),
	  endDate: moment(),
	  minDate: "01/01/2021",
	  maxDate: "12/31/2021",
	}, function (start, end) {
	  $("#default-daterange input").val(start.format("MMMM D, YYYY") + " - " + end.format("MMMM D, YYYY"));
	});

	var val_berdua = $('#Berdua').val();
	var val_keluarga = $('#Keluarga').val();
	var val_rombongan = $('#Rombongan').val();
	var val_sendiri = $('#Sendiri').val();

	var xValues = ["Berdua","Keluarga","Rombongan","Sendiri"];
	var yValues = [0, 0, 0, 0];
	if(val_berdua){
		yValues[0] = val_berdua;
	}
	if(val_keluarga){
		yValues[1] = val_keluarga;
	}
	if(val_rombongan){
		yValues[2] = val_rombongan;
	}
	if(val_sendiri){
		yValues[3] = val_sendiri;
	}
	var barColors = [
		'#4dc9f6',
		'#f67019',
		'#f53794',
		'#537bc4',
		'#acc236',
		'#166a8f',
		'#00a950',
		'#58595b',
		'#8549ba'
	];

	new Chart(document.getElementById('visitor-type'), {
		type: "doughnut",
		data: {
			labels: xValues,
			datasets: [{
				backgroundColor: barColors,
				data: yValues,
				hoverOffset: 8,
			}]
		},
		options: {
			title: {
				display: true,
			},
			borderWidth : 1,
		}
	});


	var day_1 = $('#day_1').val();
	var day_2 = $('#day_2').val();
	var day_3 = $('#day_3').val();
	var day_4 = $('#day_4').val();
	var day_5 = $('#day_5').val();
	var day_6 = $('#day_6').val();
	var day_7 = $('#day_7').val();

	var day_1_name = $('#day_1').attr("name");
	var day_2_name  = $('#day_2').attr("name");
	var day_3_name  = $('#day_3').attr("name");
	var day_4_name  = $('#day_4').attr("name");
	var day_5_name  = $('#day_5').attr("name");
	var day_6_name  = $('#day_6').attr("name");
	var day_7_name  = $('#day_7').attr("name");

	// Visitor Line
	var labels = ["","","","","","",""];
	var data = [0,0,0,0,0,0,0];
	if(day_1){
		labels[0] = day_1_name;
		data[0] = day_1;
	}
	if(day_2){
		labels[1] = day_2_name;
		data[1] = day_2;
	}
	if(day_3){
		labels[2] = day_3_name;
		data[2] = day_3;
	}
	if(day_4){
		labels[3] = day_4_name;
		data[3] = day_4;
	}
	if(day_5){
		labels[4] = day_5_name;
		data[4] = day_5;
	}
	if(day_6){
		labels[5] = day_6_name;
		data[5] = day_6;
	}
	if(day_7){
		labels[6] = day_7_name;
		data[6] = day_7;
	}
	new Chart(document.getElementById('visitor-line'), {
		type: "line",
		data: {
			labels: labels,
			datasets: [{
				label: 'Visitor each Date',
				data: data,
				fill: false,
				borderColor: 'rgb(75, 192, 192)',
				tension: 0.1
			}]
		},
		options: {
			title: {
				display: true,
			},
			borderWidth : 1,
		}
	});

	const resheaderx = axios.get("{{ route('other.notif') }}", {
		headers: {
			// Overwrite Axios's automatically set Content-Type
			'Content-Type': 'application/json'
		}
	}).then(resp => {
		var data_notifx = resp.data;
		if(data_notifx.length>0){

			Swal.fire(
				{
					position: 'top-end',
					icon: 'warning',
					text: 'Ada '+data_notifx.length+' notifikasi yang perlu anda lihat, silahkan klik ikon lonceng pada bagian kanan atas untuk melihat detailnya',
					showConfirmButton: false,
					imageHeight: 30, 
					imageWidth: 30,   
					timer: 5000
				}
			);
		}
	});
  </script>
@endpush