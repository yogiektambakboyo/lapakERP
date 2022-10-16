@extends('layouts.default')

@section('title', 'Dashboard V3')

@push('css')
	<link href="/assets/plugins/jvectormap-next/jquery-jvectormap.css" rel="stylesheet" />
	<link href="/assets/plugins/nvd3/build/nv.d3.css" rel="stylesheet" />
	<link href="/assets/plugins/bootstrap-daterangepicker/daterangepicker.css" rel="stylesheet" />
@endpush

@push('scripts')
	<script src="/assets/plugins/d3/d3.min.js"></script>
	<script src="/assets/plugins/nvd3/build/nv.d3.js"></script>
	<script src="/assets/plugins/jvectormap-next/jquery-jvectormap.min.js"></script>
	<script src="/assets/plugins/jvectormap-next/jquery-jvectormap-world-mill.js"></script>
	<script src="/assets/plugins/apexcharts/dist/apexcharts.min.js"></script>
	<script src="/assets/plugins/moment/moment.js"></script>
	<script src="/assets/plugins/bootstrap-daterangepicker/daterangepicker.js"></script>
	<script src="/assets/js/demo/dashboard-v3.js"></script>
@endpush

@section('content')
	<!-- BEGIN breadcrumb -->
	<ol class="breadcrumb float-xl-end">
		<li class="breadcrumb-item"><a href="javascript:;">Home</a></li>
		<li class="breadcrumb-item"><a href="javascript:;">Dashboard</a></li>
		<li class="breadcrumb-item active">Dashboard v3</li>
	</ol>
	<!-- END breadcrumb -->
	<!-- BEGIN page-header -->
	<h1 class="page-header mb-3">Dashboard v3</h1>
	<!-- END page-header -->
	<!-- BEGIN daterange-filter -->
	<div class="d-sm-flex align-items-center mb-3">
		<a href="#" class="btn btn-dark me-2 text-truncate" id="daterange-filter">
			<i class="fa fa-calendar fa-fw text-white-transparent-5 ms-n1"></i> 
			<span>1 Jun 2021 - 7 Jun 2021</span>
			<b class="caret ms-1 opacity-5"></b>
		</a>
		<div class="text-muted fw-bold mt-2 mt-sm-0">compared to <span id="daterange-prev-date">24 Mar-30 Apr 2021</span></div>
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
								<h2 class="mb-0">$<span data-animation="number" data-value="64559.25">0.00</span></h2>
								<div class="ms-auto mt-n1 mb-n1"><div id="total-sales-sparkline"></div></div>
							</div>
							<!-- END total-sales -->
							<!-- BEGIN percentage -->
							<div class="mb-3 text-gray-500">
								<i class="fa fa-caret-up"></i> <span data-animation="number" data-value="33.21">0.00</span>% compare to last week
							</div>
							<!-- END percentage -->
							<hr class="bg-white-transparent-5" />
							<!-- BEGIN row -->
							<div class="row text-truncate">
								<!-- BEGIN col-6 -->
								<div class="col-6">
									<div class="fs-12px text-gray-500">Total sales order</div>
									<div class="fs-18px mb-5px fw-bold" data-animation="number" data-value="1568">0</div>
									<div class="progress h-5px rounded-3 bg-gray-900 mb-5px">
										<div class="progress-bar progress-bar-striped rounded-right bg-teal" data-animation="width" data-value="55%" style="width: 0%"></div>
									</div>
								</div>
								<!-- END col-6 -->
								<!-- BEGIN col-6 -->
								<div class="col-6">
									<div class="fs-12px text-gray-500">Avg. sales per order</div>
									<div class="fs-18px mb-5px fw-bold">$<span data-animation="number" data-value="41.20">0.00</span></div>
									<div class="progress h-5px rounded-3 bg-gray-900 mb-5px">
										<div class="progress-bar progress-bar-striped rounded-right" data-animation="width" data-value="55%" style="width: 0%"></div>
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
								<b class="mb-3">CONVERSION RATE</b> 
								<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Conversion Rate" data-bs-placement="top" data-bs-content="Percentage of sessions that resulted in orders from total number of sessions." data-original-title="" title=""></i></span>
							</div>
							<!-- END title -->
							<!-- BEGIN conversion-rate -->
							<div class="d-flex align-items-center mb-1">
								<h2 class="text-white mb-0"><span data-animation="number" data-value="2.19">0.00</span>%</h2>
								<div class="ms-auto">
									<div id="conversion-rate-sparkline"></div>
								</div>
							</div>
							<!-- END conversion-rate -->
							<!-- BEGIN percentage -->
							<div class="mb-4 text-gray-500 ">
								<i class="fa fa-caret-down"></i> <span data-animation="number" data-value="0.50">0.00</span>% compare to last week
							</div>
							<!-- END percentage -->
							<!-- BEGIN info-row -->
							<div class="d-flex mb-2">
								<div class="d-flex align-items-center">
									<i class="fa fa-circle text-red fs-8px me-2"></i>
									Added to cart
								</div>
								<div class="d-flex align-items-center ms-auto">
									<div class="text-gray-500 fs-11px"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="262">0</span>%</div>
									<div class="w-50px text-end ps-2 fw-bold"><span data-animation="number" data-value="3.79">0.00</span>%</div>
								</div>
							</div>
							<!-- END info-row -->
							<!-- BEGIN info-row -->
							<div class="d-flex mb-2">
								<div class="d-flex align-items-center">
									<i class="fa fa-circle text-warning fs-8px me-2"></i>
									Reached checkout
								</div>
								<div class="d-flex align-items-center ms-auto">
									<div class="text-gray-500 fs-11px"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="11">0</span>%</div>
									<div class="w-50px text-end ps-2 fw-bold"><span data-animation="number" data-value="3.85">0.00</span>%</div>
								</div>
							</div>
							<!-- END info-row -->
							<!-- BEGIN info-row -->
							<div class="d-flex">
								<div class="d-flex align-items-center">
									<i class="fa fa-circle text-lime fs-8px me-2"></i>
									Sessions converted
								</div>
								<div class="d-flex align-items-center ms-auto">
									<div class="text-gray-500 fs-11px"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="57">0</span>%</div>
									<div class="w-50px text-end ps-2 fw-bold"><span data-animation="number" data-value="2.19">0.00</span>%</div>
								</div>
							</div>
							<!-- END info-row -->
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
								<b class="mb-3">STORE SESSIONS</b> 
								<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Store Sessions" data-bs-placement="top" data-bs-content="Number of sessions on your online store. A session is a period of continuous activity from a visitor." data-original-title="" title=""></i></span>
							</div>
							<!-- END title -->
							<!-- BEGIN store-session -->
							<div class="d-flex align-items-center mb-1">
								<h2 class="text-white mb-0"><span data-animation="number" data-value="70719">0</span></h2>
								<div class="ms-auto">
									<div id="store-session-sparkline"></div>
								</div>
							</div>
							<!-- END store-session -->
							<!-- BEGIN percentage -->
							<div class="mb-4 text-gray-500 ">
								<i class="fa fa-caret-up"></i> <span data-animation="number" data-value="9.5">0.00</span>% compare to last week
							</div>
							<!-- END percentage -->
							<!-- BEGIN info-row -->
							<div class="d-flex mb-2">
								<div class="d-flex align-items-center">
									<i class="fa fa-circle text-teal fs-8px me-2"></i>
									Mobile
								</div>
								<div class="d-flex align-items-center ms-auto">
									<div class="text-gray-500 fs-11px"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="25.7">0.00</span>%</div>
									<div class="w-50px text-end ps-2 fw-bold"><span data-animation="number" data-value="53210">0</span></div>
								</div>
							</div>
							<!-- END info-row -->
							<!-- BEGIN info-row -->
							<div class="d-flex mb-2">
								<div class="d-flex align-items-center">
									<i class="fa fa-circle text-blue fs-8px me-2"></i>
									Desktop
								</div>
								<div class="d-flex align-items-center ms-auto">
									<div class="text-gray-500 fs-11px"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="16.0">0.00</span>%</div>
									<div class="w-50px text-end ps-2 fw-bold"><span data-animation="number" data-value="11959">0</span></div>
								</div>
							</div>
							<!-- END info-row -->
							<!-- BEGIN info-row -->
							<div class="d-flex">
								<div class="d-flex align-items-center">
									<i class="fa fa-circle text-cyan fs-8px me-2"></i>
									Tablet
								</div>
								<div class="d-flex align-items-center ms-auto">
									<div class="text-gray-500 fs-11px"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="7.9">0.00</span>%</div>
									<div class="w-50px text-end ps-2 fw-bold"><span data-animation="number" data-value="5545">0</span></div>
								</div>
							</div>
							<!-- END info-row -->
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
		<!-- BEGIN col-8 -->
		<div class="col-xl-8 col-lg-6">
			<!-- BEGIN card -->
			<div class="card border-0 mb-3 bg-gray-800 text-white">
				<div class="card-body">
					<div class="mb-3 text-gray-500 "><b>VISITORS ANALYTICS</b> <span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Top products with units sold" data-bs-placement="top" data-bs-content="Products with the most individual units sold. Includes orders from all sales channels." data-original-title="" title=""></i></span></div>
					<div class="row">
						<div class="col-xl-3 col-4">
							<h3 class="mb-1"><span data-animation="number" data-value="127.1">0</span>K</h3>
							<div>New Visitors</div>
							<div class="text-gray-500 fs-11px text-truncate"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="25.5">0.00</span>% from previous 7 days</div>
						</div>
						<div class="col-xl-3 col-4">
							<h3 class="mb-1"><span data-animation="number" data-value="179.9">0</span>K</h3>
							<div>Returning Visitors</div>
							<div class="text-gray-500 fs-11px text-truncate"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="5.33">0.00</span>% from previous 7 days</div>
						</div>
						<div class="col-xl-3 col-4">
							<h3 class="mb-1"><span data-animation="number" data-value="766.8">0</span>K</h3>
							<div>Total Page Views</div>
							<div class="text-gray-500 fs-11px text-truncate"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="0.323">0.00</span>% from previous 7 days</div>
						</div>
					</div>
				</div>
				<div class="card-body p-0">
					<div style="height: 269px">
						<div id="visitors-line-chart" class="widget-chart-full-width dark-mode" style="height: 254px"></div>
					</div>
				</div>
			</div>
			<!-- END card -->
		</div>
		<!-- END col-8 -->
		<!-- BEGIN col-4 -->
		<div class="col-xl-4 col-lg-6">
			<!-- BEGIN card -->
			<div class="card border-0 mb-3 bg-gray-800 text-white">
				<div class="card-body">
					<div class="mb-2 text-gray-500">
						<b>SESSION BY LOCATION</b>
						<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Total sales" data-bs-placement="top" data-bs-content="Net sales (gross sales minus discounts and returns) plus taxes and shipping. Includes orders from all sales channels."></i></span>
					</div>
					<div id="visitors-map" class="mb-2" style="height: 200px"></div>
					<div>
						<div class="d-flex align-items-center text-white mb-2">
							<div class="widget-img widget-img-xs rounded bg-inverse me-2 w-40px" style="background-image: url(/assets/img/flag/us.jpg)"></div>
							<div class="d-flex w-100">
								<div>United States</div>
								<div class="ms-auto text-gray-500"><span data-animation="number" data-value="39.85">0.00</span>%</div>
							</div>
						</div>
						<div class="d-flex align-items-center text-white mb-2">
							<div class="widget-img widget-img-xs rounded bg-inverse me-2 w-40px" style="background-image: url(/assets/img/flag/cn.jpg)"></div>
							<div class="d-flex w-100">
								<div>China</div>
								<div class="ms-auto text-gray-500"><span data-animation="number" data-value="14.23">0.00</span>%</div>
							</div>
						</div>
						<div class="d-flex align-items-center text-white mb-2">
							<div class="widget-img widget-img-xs rounded bg-inverse me-2 w-40px" style="background-image: url(/assets/img/flag/de.jpg)"></div>
							<div class="d-flex w-100">
								<div>Germany</div>
								<div class="ms-auto text-gray-500"><span data-animation="number" data-value="12.83">0.00</span>%</div>
							</div>
						</div>
						<div class="d-flex align-items-center text-white mb-2">
							<div class="widget-img widget-img-xs rounded bg-inverse me-2 w-40px" style="background-image: url(/assets/img/flag/fr.jpg)"></div>
							<div class="d-flex w-100">
								<div>France</div>
								<div class="ms-auto text-gray-500"><span data-animation="number" data-value="11.14">0.00</span>%</div>
							</div>
						</div>
						<div class="d-flex align-items-center text-white mb-0">
							<div class="widget-img widget-img-xs rounded bg-inverse me-2 w-40px" style="background-image: url(/assets/img/flag/jp.jpg)"></div>
							<div class="d-flex w-100">
								<div>Japan</div>
								<div class="ms-auto text-gray-500"><span data-animation="number" data-value="10.75">0.00</span>%</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
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
						<b>SALES BY SOCIAL SOURCE</b>
						<span class="text-gray-500 ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Sales by social source" data-bs-placement="top" data-bs-content="Total online store sales that came from a social referrer source."></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN sales -->
					<h3 class="mb-10px">$<span data-animation="number" data-value="55547.89">0.00</span></h3>
					<!-- END sales -->
					<!-- BEGIN percentage -->
					<div class="text-gray-500 mb-1px"><i class="fa fa-caret-up"></i> <span data-animation="number" data-value="45.76">0.00</span>% increased</div>
					<!-- END percentage -->
				</div>
				<!-- END card-body -->
				<!-- BEGIN widget-list -->
				<div class="widget-list rounded-bottom dark-mode">
					<!-- BEGIN widget-list-item -->
					<a href="#" class="widget-list-item rounded-0 pt-3px">
						<div class="widget-list-media icon">
							<i class="fab fa-apple bg-indigo text-white"></i>
						</div>
						<div class="widget-list-content">
							<div class="widget-list-title">Apple Store</div>
						</div>
						<div class="widget-list-action text-nowrap text-gray-500">
							$<span data-animation="number" data-value="34840.17">0.00</span>
						</div>
					</a>
					<!-- END widget-list-item -->
					<!-- BEGIN widget-list-item -->
					<a href="#" class="widget-list-item">
						<div class="widget-list-media icon">
							<i class="fab fa-facebook-f bg-blue text-white"></i>
						</div>
						<div class="widget-list-content">
							<div class="widget-list-title">Facebook</div>
						</div>
						<div class="widget-list-action text-nowrap text-gray-500">
							$<span data-animation="number" data-value="12502.67">0.00</span>
						</div>
					</a>
					<!-- END widget-list-item -->
					<!-- BEGIN widget-list-item -->
					<a href="#" class="widget-list-item">
						<div class="widget-list-media icon">
							<i class="fab fa-twitter bg-info text-white"></i>
						</div>
						<div class="widget-list-content">
							<div class="widget-list-title">Twitter</div>
						</div>
						<div class="widget-list-action text-nowrap text-gray-500">
							$<span data-animation="number" data-value="4799.20">0.00</span>
						</div>
					</a>
					<!-- END widget-list-item -->
					<!-- BEGIN widget-list-item -->
					<a href="#" class="widget-list-item">
						<div class="widget-list-media icon">
							<i class="fab fa-google bg-red text-white"></i>
						</div>
						<div class="widget-list-content">
							<div class="widget-list-title">Google Adwords</div>
						</div>
						<div class="widget-list-action text-nowrap text-gray-500">
							$<span data-animation="number" data-value="3405.85">0.00</span>
						</div>
					</a>
					<!-- END widget-list-item -->
					<!-- BEGIN widget-list-item -->
					<a href="#" class="widget-list-item pb-3px rounded-bottom">
						<div class="widget-list-media icon">
							<i class="fab fa-instagram bg-pink text-white"></i>
						</div>
						<div class="widget-list-content">
							<div class="widget-list-title">Instagram</div>
						</div>
						<div class="widget-list-action text-nowrap text-gray-500">
							$<span data-animation="number" data-value="0.00">0.00</span>
						</div>
					</a>
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
					<div class="d-flex align-items-center mb-15px">
						<div class="widget-img rounded-3 me-10px bg-white p-3px w-30px">
							<div class="h-100 w-100" style="background: url(/assets/img/product/product-8.jpg) center no-repeat; background-size: auto 100%;"></div>
						</div>
						<div class="text-truncate">
							<div >Apple iPhone XR (2021)</div>
							<div class="text-gray-500">$799.00</div>
						</div>
						<div class="ms-auto text-center">
							<div class="fs-13px"><span data-animation="number" data-value="195">0</span></div>
							<div class="text-gray-500 fs-10px">sold</div>
						</div>
					</div>
					<!-- END product -->
					<!-- BEGIN product -->
					<div class="d-flex align-items-center mb-15px">
						<div class="widget-img rounded-3 me-10px bg-white p-3px w-30px">
							<div class="h-100 w-100" style="background: url(/assets/img/product/product-9.jpg) center no-repeat; background-size: auto 100%;"></div>
						</div>
						<div class="text-truncate">
							<div >Apple iPhone XS (2021)</div>
							<div class="text-gray-500">$1,199.00</div>
						</div>
						<div class="ms-auto text-center">
							<div class="fs-13px"><span data-animation="number" data-value="185">0</span></div>
							<div class="text-gray-500 fs-10px">sold</div>
						</div>
					</div>
					<!-- END product -->
					<!-- BEGIN product -->
					<div class="d-flex align-items-center mb-15px">
						<div class="widget-img rounded-3 me-10px bg-white p-3px w-30px">
							<div class="h-100 w-100" style="background: url(/assets/img/product/product-10.jpg) center no-repeat; background-size: auto 100%;"></div>
						</div>
						<div class="text-truncate">
							<div >Apple iPhone XS Max (2021)</div>
							<div class="text-gray-500">$3,399</div>
						</div>
						<div class="ms-auto text-center">
							<div class="fs-13px"><span data-animation="number" data-value="129">0</span></div>
							<div class="text-gray-500 fs-10px">sold</div>
						</div>
					</div>
					<!-- END product -->
					<!-- BEGIN product -->
					<div class="d-flex align-items-center mb-15px">
						<div class="widget-img rounded-3 me-10px bg-white p-3px w-30px">
							<div class="h-100 w-100" style="background: url(/assets/img/product/product-11.jpg) center no-repeat; background-size: auto 100%;"></div>
						</div>
						<div class="text-truncate">
							<div >Huawei Y5 (2021)</div>
							<div class="text-gray-500">$99.00</div>
						</div>
						<div class="ms-auto text-center">
							<div class="fs-13px"><span data-animation="number" data-value="96">0</span></div>
							<div class="text-gray-500 fs-10px">sold</div>
						</div>
					</div>
					<!-- END product -->
					<!-- BEGIN product -->
					<div class="d-flex align-items-center">
						<div class="widget-img rounded-3 me-10px bg-white p-3px w-30px">
							<div class="h-100 w-100" style="background: url(/assets/img/product/product-12.jpg) center no-repeat; background-size: auto 100%;"></div>
						</div>
						<div class="text-truncate">
							<div >Huawei Nova 4 (2021)</div>
							<div class="text-gray-500">$499.00</div>
						</div>
						<div class="ms-auto text-center">
							<div class="fs-13px"><span data-animation="number" data-value="55">0</span></div>
							<div class="text-gray-500 fs-10px">sold</div>
						</div>
					</div>
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
					<div class="mb-3 text-gray-500 ">
						<b>MARKETING CAMPAIGN</b>
						<span class="ms-2"><i class="fa fa-info-circle" data-bs-toggle="popover" data-bs-trigger="hover" data-bs-title="Marketing Campaign" data-bs-placement="top" data-bs-content="Campaign that run for getting more returning customers."></i></span>
					</div>
					<!-- END title -->
					<!-- BEGIN row -->
					<div class="row align-items-center pb-1px">
						<!-- BEGIN col-4 -->
						<div class="col-4">
							<div class="h-100px d-flex align-items-center justify-content-center">
								<img src="/assets/img/svg/img-2.svg" class="mw-100 mh-100" />
							</div>
						</div>
						<!-- END col-4 -->
						<!-- BEGIN col-8 -->
						<div class="col-8">
							<div class="mb-2px text-truncate">Email Marketing Campaign</div>
							<div class="mb-2px  text-gray-500  fs-11px">Mon 12/6 - Sun 18/6</div>
							<div class="d-flex align-items-center mb-2px">
								<div class="flex-grow-1">
									<div class="progress h-5px rounded-pill bg-white-transparent-1">
										<div class="progress-bar progress-bar-striped bg-indigo" data-animation="width" data-value="80%" style="width: 0%"></div>
									</div>
								</div>
								<div class="ms-2 fs-11px w-30px text-center"><span data-animation="number" data-value="80">0</span>%</div>
							</div>
							<div class="text-gray-500 fs-11px mb-15px text-truncate">
								57.5% people click the email
							</div>
							<a href="#" class="btn btn-xs btn-indigo fs-10px ps-2 pe-2">View campaign</a>
						</div>
						<!-- END col-8 -->
					</div>
					<!-- END row -->
					<hr class=" bg-white-transparent-2 mt-20px mb-20px" />
					<!-- BEGIN row -->
					<div class="row align-items-center">
						<!-- BEGIN col-4 -->
						<div class="col-4">
							<div class="h-100px d-flex align-items-center justify-content-center">
								<img src="/assets/img/svg/img-3.svg" class="mw-100 mh-100" />
							</div>
						</div>
						<!-- END col-4 -->
						<!-- BEGIN col-8 -->
						<div class="col-8">
							<div class="mb-2px text-truncate">Facebook Marketing Campaign</div>
							<div class="mb-2px  text-gray-500  fs-11px">Sat 10/6 - Sun 18/6</div>
							<div class="d-flex align-items-center mb-2px">
								<div class="flex-grow-1">
									<div class="progress h-5px rounded-pill bg-white-transparent-1">
										<div class="progress-bar progress-bar-striped bg-warning" data-animation="width" data-value="60%" style="width: 0%"></div>
									</div>
								</div>
								<div class="ms-2 fs-11px w-30px text-center"><span data-animation="number" data-value="60">0</span>%</div>
							</div>
							<div class="text-gray-500 fs-11px mb-15px text-truncate">
								+124k visitors from facebook
							</div>
							<a href="#" class="btn btn-xs btn-warning fs-10px ps-2 pe-2">View campaign</a>
						</div>
						<!-- END col-8 -->
					</div>
					<!-- END row -->
				</div>
				<!-- END card-body -->
			</div>
			<!-- END card -->
		</div>
		<!-- END col-4 -->
	</div>
	<!-- END row -->
@endsection