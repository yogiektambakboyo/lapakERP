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
	<h1 class="page-header">Welcome, @auth
		{{auth()->user()->name}} 
	@endauth </h1>
	<!-- END page-header -->
	<!-- BEGIN daterange-filter -->
	<div class="d-sm-flex align-items-center mb-3">
		<div class="input-group" id="default-daterange">
			<input type="text" name="default-daterange" class="form-control" value="" placeholder="Click to select the date range" />
			<div class="input-group-text"><i class="fa fa-calendar"></i></div>
		</div>
	</div>
	<!-- END daterange-filter -->
	
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
								<b>TOTAL SALES</b>
								<span class="ms-2">
									<i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Total sales" data-bs-placement="top" data-bs-content="Net sales (gross sales minus discounts and returns) plus taxes and shipping. Includes orders from all sales channels."></i>
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
									<div class="fs-12px text-gray-500">Total sales order</div>
									<div class="fs-18px mb-5px fw-bold" data-animation="number" data-value="{{  $d_data_c[0]->count_sales }}">0</div>
									<div class="progress h-5px rounded-3 bg-gray-900 mb-5px">
										<div class="progress-bar progress-bar-striped rounded-right bg-teal" data-animation="width" data-value="{{ ($d_data_c[0]->count_sales/100)*100  }}" style="width: 0%"></div>
									</div>
								</div>
								<!-- END col-6 -->
								<!-- BEGIN col-6 -->
								<div class="col-6">
									<div class="fs-12px text-gray-500">Avg. sales per order</div>
									<div class="fs-18px mb-5px fw-bold">Rp. <span data-animation="number" data-value="{{  $d_data[0]->total/$d_data_c[0]->count_sales }}">0.00</span></div>
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
								<b class="mb-3">SALES OF PRODUCT</b> 
								<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Conversion Rate" data-bs-placement="top" data-bs-content="Percentage of sessions that resulted in orders from total number of sessions." data-original-title="" title=""></i></span>
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
								<b class="mb-3">SALES OF SERVICES</b> 
								<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Store Sessions" data-bs-placement="top" data-bs-content="Number of sessions on your online store. A session is a period of continuous activity from a visitor." data-original-title="" title=""></i></span>
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
						<b>TOP TERAPIST BY EXECUTION</b>
						<span class="text-gray-500 ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Sales by social source" data-bs-placement="top" data-bs-content="Total online store sales that came from a social referrer source."></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN sales -->
					<!-- END sales -->
				</div>
				<!-- END card-body -->
				<!-- BEGIN widget-list -->
				<div class="widget-list rounded-bottom dark-mode">
					<!-- BEGIN widget-list-item -->
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
						<b>TOP PRODUCTS BY UNITS SOLD</b>
						<span class="ms-2 "><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Top products with units sold" data-bs-placement="top" data-bs-content="Products with the most individual units sold. Includes orders from all sales channels."></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN product -->
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
						<b>TOP SERVICES BY UNITS SOLD</b>
						<span class="ms-2 "><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Top products with units sold" data-bs-placement="top" data-bs-content="Products with the most individual units sold. Includes orders from all sales channels."></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN product -->
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
					<!-- END product -->
				</div>
				<!-- END card-body -->
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
	</div>
	<!-- END row -->
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
  </script>
@endpush