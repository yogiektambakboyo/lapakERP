@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Home')

@push('scripts')
	<script src="/assets/js/render.highlight.js"></script>
	<script src="/assets/js/chart.umd.js"></script>
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
		<div class="col-xl-6 col-lg-6">
			<!-- BEGIN card -->
			<div class="panel panel-inverse">
				<div class="panel-heading bg-teal">
				  <h4 class="panel-title"><i class="fas fa-file-invoice-dollar"></i> @lang('home.lbl_order_book')</h4>
				</div>
				<div class="panel-body">
					@if(count($d_data_order)>0)
						<table id="table_order"  width="100%" class="table table-striped table-bordered align-middle text-nowrap">
							<thead>
								<tr>
									<th>@lang('home.lbl_dated')</th>
									<th>@lang('home.lbl_name')</th>
									<th>@lang('home.lbl_invoice_no')</th>
									<th>@lang('home.lbl_branch_name')</th>
								</tr>
							</thead>
							<tbody>
								@foreach($d_data_order as $d_t_p)
									<tr>
										<td>{{ $d_t_p->dated }}</td>
										<td>{{ $d_t_p->name }}</td>
										<td>{{ $d_t_p->invoice_no }}</td>
										<td>{{ $d_t_p->branch_name }}</td>
									</tr>
									
								@endforeach
							</tbody>
						</table>
						
						
						
					@else
						<div class="align-items-center d-flex justify-content-center">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
				</div>
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-6 col-lg-6">
			<!-- BEGIN card -->
			<div class="panel panel-inverse">
				<div class="panel-heading  bg-teal">
				  <h4 class="panel-title"><i class="fas fa-business-time"></i>  @lang('home.lbl_due_date_invoice')</h4>
				</div>
				<div class="panel-body">
					@if(count($d_data_invoice_overdue)>0)
						<table id="table_invoice_overdue"  width="100%" class="table table-striped table-bordered align-middle text-nowrap">
							<thead>
								<tr>
									<th>@lang('home.lbl_branch_name')</th>
									<th>@lang('home.lbl_dated')</th>
									<th>@lang('home.lbl_invoice_no')</th>
									<th>Total</th>
								</tr>
							</thead>
							<tbody>
								@foreach($d_data_invoice_overdue as $d_t_p)
									<tr>
										<td>{{ $d_t_p->branch_name }}</td>
										<td>{{ $d_t_p->dated }}</td>
										<td>{{ $d_t_p->invoice_no }}</td>
										<td>{{ $d_t_p->total }}</td>
									</tr>
									
								@endforeach
							</tbody>
						</table>
						
						
						
					@else
						<div class="align-items-center d-flex justify-content-center">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
				</div>
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
	</div>
	<!-- END row -->
	
	<!-- BEGIN row -->
	<div class="row">
		
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-6 col-lg-6">
			<!-- BEGIN card -->
			<div class="panel panel-inverse">
				<div class="panel-heading bg-teal">
				  <h4 class="panel-title"><i class="fas fa-box"></i> @lang('home.lbl_inventory_balance')</h4>
				</div>
				<div class="panel-body">
					@if(count($d_data_stock)>0)
						<table id="table_order"  width="100%" class="table table-striped table-bordered align-middle text-nowrap">
							<thead>
								<tr>
									<th>@lang('home.lbl_branch_name')</th>
									<th>@lang('home.lbl_product_name')</th>
									<th>@lang('home.lbl_qty')</th>
								</tr>
							</thead>
							<tbody>
								@foreach($d_data_stock as $d_t_p)
									<tr>
										<td>{{ $d_t_p->branch_name }}</td>
										<td>{{ $d_t_p->product_name }}</td>
										<td>{{ $d_t_p->qty }}</td>
									</tr>
									
								@endforeach
							</tbody>
						</table>
						
						
						
					@else
						<div class="align-items-center d-flex justify-content-center">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
				</div>
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-6 col-lg-6">
			<!-- BEGIN card -->
			<div class="panel panel-inverse">
				<div class="panel-heading bg-teal">
				  <h4 class="panel-title"><i class="fas fa-hourglass-start"></i>  @lang('home.lbl_due_date_order')</h4>
				</div>
				<div class="panel-body">
					@if(count($d_data_order_overdue)>0)
						<table id="table_order_overdue"  width="100%" class="table table-striped table-bordered align-middle text-nowrap">
							<thead>
								<tr>
									<th>@lang('home.lbl_branch_name')</th>
									<th>@lang('home.lbl_dated')</th>
								</tr>
							</thead>
							<tbody>
								@foreach($d_data_order_overdue as $d_t_p)
									<tr>
										<td>{{ $d_t_p->branch_name }}</td>
										<td>{{ $d_t_p->dated }}</td>
									</tr>
									
								@endforeach
							</tbody>
						</table>
						
						
						
					@else
						<div class="align-items-center d-flex justify-content-center">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
				</div>
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
	</div>
	<!-- END row -->


	<!-- BEGIN row -->
	<div class="row">
		
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-6 col-lg-6">
			<!-- BEGIN card -->
			<div class="panel panel-inverse">
				<div class="panel-heading bg-teal">
				  <h4 class="panel-title"><i class="fas fa-chart-pie"></i> @lang('home.lbl_sales')</h4>
				</div>
				<div class="panel-body">
					@if(count($d_data_branch_acv)>0)
						<canvas id="pie-chart"></canvas>
					@else
						<div class="align-items-center d-flex justify-content-center">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
				</div>
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-6 col-lg-6">
			<!-- BEGIN card -->
			<div class="panel panel-inverse">
				<div class="panel-heading bg-teal">
				  <h4 class="panel-title"><i class="fas fa-trophy"></i> @lang('home.lbl_acv')</h4>
				</div>
				<div class="panel-body">
					@if(count($d_data_branch_acv)>0)
						<table id="table_acv"  width="100%" class="table table-striped table-bordered align-middle text-nowrap">
							<thead>
								<tr>
									<th>@lang('home.lbl_branch_name')</th>
									<th>Target</th>
									<th>Actual</th>
									<th>Percentage</th>
								</tr>
							</thead>
							<tbody>
								@foreach($d_data_branch_acv as $d_t_p)
									<tr>
										<td>{{ $d_t_p->branch_name }}</td>
										<td>{{ $d_t_p->value_target }}</td>
										<td>{{ $d_t_p->value_actual }}</td>
										<td>{{ $d_t_p->value_target>0?($d_t_p->value_actual*100/$d_t_p->value_target):0 }}%</td>
									</tr>
									
								@endforeach
							</tbody>
						</table>
						
						
						
					@else
						<div class="align-items-center d-flex justify-content-center">
							<img src="/assets/img/other/empty_cart.png" height="120px" class="justify-content-center" />
						</div>	
					@endif
				</div>
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

	$('#table_order').DataTable({
		deferRender:    true,
		scrollY:        350,
		scrollCollapse: true,
		scroller:       true,
		responsive: true
	});
	$('#table_invoice_overdue').DataTable({
		deferRender:    true,
		scrollY:        350,
		scrollCollapse: true,
		scroller:       true,
		responsive: true
	});

	$('#table_order_overdue').DataTable({
		deferRender:    true,
		scrollY:        350,
		scrollCollapse: true,
		scroller:       true,
		responsive: true
	});
	var ctx = document.getElementById('pie-chart').getContext('2d');

	var pieChart = new Chart(ctx, {
		type: 'pie',
		data: {
			labels: ['Red', 'Blue', 'Yellow', 'Green', 'Purple'],
			datasets: [{
				label: 'Sales',
				data: [12, 19, 3, 5, 3],
				backgroundColor: [
					'rgba(255, 99, 132, 0.2)',
					'rgba(54, 162, 235, 0.2)',
					'rgba(255, 206, 86, 0.2)',
					'rgba(75, 192, 192, 0.2)',
					'rgba(153, 102, 255, 0.2)',
					'rgba(255, 159, 64, 0.2)'
				],
				borderColor: [
					'rgba(255, 99, 132, 1)',
					'rgba(54, 162, 235, 1)',
					'rgba(255, 206, 86, 1)',
					'rgba(75, 192, 192, 1)',
					'rgba(153, 102, 255, 1)',
					'rgba(255, 159, 64, 1)'
				],
				borderWidth: 1
			}]
		},
		options: {
			responsive: true,
			plugins: {
				legend: {
					position: 'top',
				},
				tooltip: {
					callbacks: {
						label: function(tooltipItem) {
							return tooltipItem.label + ': ' + tooltipItem.raw.toFixed(2);
						}
					}
				}
			}
		}
	});
	pieChart.canvas.parentNode.style.height = '500px';

  </script>
@endpush