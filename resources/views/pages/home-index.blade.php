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
	<div class="row">
		<div class="col-lg-10">
			<h1 class="page-header">@lang('home.welcome'), @auth
				{{auth()->user()->name}} 
			@endauth </h1>
		</div>
	</div>
	
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
		
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-4 col-lg-6">
			<!-- BEGIN card -->
			<div class="card border-0 mb-3 bg-gray-800 text-white">
				<!-- BEGIN card-body -->
				<div class="card-body" >
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
@endsection

@push('scripts')
<script>


	function copyClip() {
		// Get the text field
		var copyText = document.getElementById("code_aff");

		// Select the text field
		copyText.select();
		//copyText.setSelectionRange(0, 99999); // For mobile devices

		// Copy the text inside the text field
		navigator.clipboard.writeText(copyText.value);
		// Alert the copied text
		alert("Copied : " + copyText.value);
	}
  </script>
@endpush