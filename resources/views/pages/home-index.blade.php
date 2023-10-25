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
		<div class="col-xl-6">
			<!-- BEGIN card -->
			<div class="card border-0 mb-3 overflow-hidden bg-gray-800 text-white">
				<!-- BEGIN card-body -->
				<div class="card-body">
					<!-- BEGIN row -->
					<div class="row">
						<!-- BEGIN col-7 -->
						<div class="col-xl-7 col-lg-8">
							<!-- BEGIN title -->
							<div class="mb-3 text-gray-500">
								<b>@lang('home.total_sales')</b>
								<span class="ms-2">
									<i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Total sales" data-bs-placement="top" data-bs-content="Net sales (gross sales minus discounts and returns) plus taxes. Includes orders from all sales channels."></i>
								</span>
							</div>
							<!-- END title -->
							<!-- BEGIN total-sales -->
							<div class="d-flex mb-1">
								<h2 class="mb-0">Rp. <span data-animation="number" data-value="{{  $d_data[0]->total }}">0.00</span></h2>
								<div class="ms-auto mt-n1 mb-n1"><div id="total-sales-sparkline"></div></div>
							</div>
							<!-- END total-sales -->
							<hr class="bg-white-transparent-5" />
							<!-- BEGIN row -->
							<div class="row text-truncate">
								<!-- BEGIN col-6 -->
								<div class="col-6">
									<div class="fs-12px text-gray-500">@lang('home.qty_sales')</div>
									<div class="fs-18px mb-5px fw-bold" data-animation="number" data-value="{{  $d_data_c[0]->count_sales }}">0</div>
									<div class="progress h-5px rounded-3 bg-gray-900 mb-5px">
										<div class="progress-bar progress-bar-striped rounded-right bg-teal" data-animation="width" data-value="{{ ($d_data_c[0]->count_sales/100)*100  }}" style="width: 0%"></div>
									</div>
								</div>
								<!-- END col-6 -->
								<!-- BEGIN col-6 -->
								<div class="col-6">
									<div class="fs-12px text-gray-500">@lang('home.avg_sales')</div>
									<div class="fs-18px mb-5px fw-bold">Rp. <span data-animation="number" data-value="@if($d_data_c[0]->count_sales>0) {{  ((int) ($d_data[0]->total/$d_data_c[0]->count_sales)) }} @else {{ '0' }} @endif">0.00</span></div>
									<div class="progress h-5px rounded-3 bg-gray-900 mb-5px">
										<div class="progress-bar progress-bar-striped rounded-right" data-animation="width" data-value="{{ ($d_data[0]->total/5000000)*100  }}" style="width: 0%"></div>
									</div>
								</div>
								<!-- END col-6 -->
							</div>
							<!-- END row -->
						</div>
						<!-- END col-7 -->
						<!-- BEGIN col-5 -->
						<div class="col-xl-5 col-lg-4 align-items-center d-flex justify-content-center">
							<img src="/assets/img/svg/img-1.svg" height="150px" class="d-none d-lg-block" />
						</div>
						<!-- END col-5 -->
					</div>
					<!-- END row -->
				</div>
				<!-- END card-body -->
			</div>
			<!-- END card -->
		</div>
		<!-- END col-6 -->
		<!-- BEGIN col-6 -->
		<div class="col-xl-6">
			<!-- BEGIN row -->
			<div class="row">
				<!-- BEGIN col-6 -->
				<div class="col-sm-6">
					<!-- BEGIN card -->
					<div class="card border-0 text-truncate mb-3 bg-gray-800 text-white">
						<!-- BEGIN card-body -->
						<div class="card-body">
							<!-- BEGIN title -->
							<div class="mb-3 text-gray-500">
								<b class="mb-3">@lang('home.sales_product')</b> 
								<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Sales of Product" data-bs-placement="top" data-bs-content="Total sales from product" data-original-title="" title=""></i></span>
							</div>
							<!-- END title -->
							<!-- BEGIN conversion-rate -->
							<div class="d-flex align-items-center mb-1">
								<h2 class="text-white mb-0">Rp. <span data-animation="number" data-value="{{ $d_data_p[0]->total_product }}">0.00</span></h2>
								<div class="ms-auto">
									<div id="conversion-rate-sparkline"></div>
								</div>
							</div>
							<!-- END conversion-rate -->
							
						</div>
						<!-- END card-body -->
					</div>
					<!-- END card -->
				</div>
				<!-- END col-6 -->
				<!-- BEGIN col-6 -->
				<div class="col-sm-6">
					<!-- BEGIN card -->
					<div class="card border-0 text-truncate mb-3 bg-gray-800 text-white">
						<!-- BEGIN card-body -->
						<div class="card-body">
							<!-- BEGIN title -->
							<div class="mb-3 text-gray-500">
								<b class="mb-3">@lang('home.sales_service')</b> 
								<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Sales of Service" data-bs-placement="top" data-bs-content="Total sales from services." data-original-title="" title=""></i></span>
							</div>
							<!-- END title -->
							<!-- BEGIN store-session -->
							<div class="d-flex align-items-center mb-1">
								<h2 class="text-white mb-0">Rp. <span data-animation="number" data-value="{{ $d_data_s[0]->total_service }}">0</span></h2>
								<div class="ms-auto">
									<div id="store-session-sparkline"></div>
								</div>
							</div>
							<!-- END store-session -->
						</div>
						<!-- END card-body -->
					</div>
					<!-- END card -->
				</div>
				<!-- END col-6 -->
			</div>
			<!-- END row -->
		</div>
		<!-- END col-6 -->
	</div>
	<!-- END row -->
	<!-- BEGIN row -->
	<div class="row">
		<!-- BEGIN col-4 -->
		<div class="col-xl-4 col-lg-6">
			<!-- BEGIN card -->
			<div class="card border-0 mb-3 bg-gray-900 text-white">
				<!-- BEGIN card-body -->
				<div class="card-body" style="background: no-repeat bottom right; background-image: url(/assets/img/svg/img-4.svg); background-size: auto 60%;">
					<!-- BEGIN title -->
					<div class="mb-3 text-gray-500 ">
						<b>@lang('home.top_terapist')</b>
						<span class="text-gray-500 ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Top Active Terapist" data-bs-placement="top" data-bs-content="Rangking most active terapist from execution"></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN sales -->
					<!-- END sales -->
				</div>
				<!-- END card-body -->
				<!-- BEGIN widget-list -->
				<div class="widget-list rounded-bottom dark-mode">
					<!-- BEGIN widget-list-item -->
					@if(count($d_data_t)>0)
						@foreach($d_data_t as $d_t)
							<a href="#" class="widget-list-item rounded-0 pt-3px">
								<div class="widget-list-media icon">
									<i class="fas fa-user bg-indigo text-white"></i>
								</div>
								<div class="widget-list-content">
									<div class="widget-list-title">{{ $d_t->user_name }}</div>
								</div>
								<div class="widget-list-action text-nowrap text-gray-500">
									<span data-animation="number" data-value="{{ $d_t->counter }}">0.00</span>
								</div>
							</a>
						@endforeach
					@else
						<div class="align-items-center d-flex justify-content-center dark-mode">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
					<!-- END widget-list-item -->
				</div>
				<!-- END widget-list -->
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-4 col-lg-6">
			<!-- BEGIN card -->
			<div class="card border-0 mb-3 bg-gray-800 text-white">
				<!-- BEGIN card-body -->
				<div class="card-body">
					<!-- BEGIN title -->
					<div class="mb-3 text-gray-500">
						<b>@lang('home.top_product')</b>
						<span class="ms-2 "><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Top products with units sold" data-bs-placement="top" data-bs-content="Products with the most individual units sold. Includes orders from all sales channels."></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN product -->
					@if(count($d_data_r_p)>0)
						@foreach($d_data_r_p as $d_t_p)
							<div class="d-flex align-items-center mb-15px">
								<div class="text-truncate">
									<div >{{ $d_t_p->product_name }}</div>
								</div>
								<div class="ms-auto text-center">
									<div class="fs-13px"><span data-animation="number" data-value="{{ $d_t_p->counter }}">0</span></div>
									<div class="text-gray-500 fs-10px">sold</div>
								</div>
							</div>
						@endforeach
					@else
						<div class="align-items-center d-flex justify-content-center">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
					<!-- END product -->
				</div>
				<!-- END card-body -->
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-4 col-lg-6">
			<!-- BEGIN card -->
			<div class="card border-0 mb-3 bg-gray-800 text-white">
				<!-- BEGIN card-body -->
				<div class="card-body">
					<!-- BEGIN title -->
					<div class="mb-3 text-gray-500">
						<b>@lang('home.top_service')</b>
						<span class="ms-2 "><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Top service with units sold" data-bs-placement="top" data-bs-content="Services with the most individual units sold. Includes orders from all sales channels."></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN product -->
					@if(count($d_data_t)>0)
						@foreach($d_data_r_s as $d_t_s)
							<div class="d-flex align-items-center mb-15px">
								<div class="text-truncate">
									<div >{{ $d_t_s->product_name }}</div>
								</div>
								<div class="ms-auto text-center">
									<div class="fs-13px"><span data-animation="number" data-value="{{ $d_t_s->counter }}">0</span></div>
									<div class="text-gray-500 fs-10px">sold</div>
								</div>
							</div>
						@endforeach
					@else
						<div class="align-items-center d-flex justify-content-center dark-mode">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
					<!-- END product -->
				</div>
				<!-- END card-body -->
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
	</div>
	<!-- END row -->

	<div class="row">
		<div class="col-xl-12">
			<div class="widget-chart with-sidebar inverse-mode">
				<div class="bg-gray-800" style="width: 80%">
					<h4 class="chart-title m-3">
						Visitors Analytics
						<small>Where do our visitors come from</small>
					</h4>
					<div id="visitors-line-chart" class="dark-mode my-1 mx-5"  style="position: relative; height:50vh;">
						<canvas id="visitor-line"></canvas>
					</div>
				</div>
				<div class="widget-chart-content bg-gray-900">
					<h4 class="chart-title">
						<?php
							$visitor_counter = 0;
							for ($i=0; $i < count($d_data_v); $i++) { 
								$visitor_counter = $visitor_counter+$d_data_v[$i]->counter;
								echo '<input type="hidden" id="'.$d_data_v[$i]->customer_type.'" value="'.$d_data_v[$i]->counter.'"> ';
							}
							echo $visitor_counter;

							for ($i=0; $i < count($d_data_v_dated); $i++) { 
								$visitor_counter = $visitor_counter+$d_data_v_dated[$i]->counter;
								echo '<input type="hidden" id="day_'.($i+1).'" name="'.$d_data_v_dated[$i]->dated.'" value="'.$d_data_v_dated[$i]->counter.'"> ';
							}
						?>
						<small>Total visitors</small>
					</h4>
					<div class="flex-grow-1 d-flex align-items-center">
						<canvas id="visitor-type" class="m-3"></canvas>
					</div>
				</div>
			</div>
		</div>
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