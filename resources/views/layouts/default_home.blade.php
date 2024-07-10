<!DOCTYPE html>
<html lang="{{ app()->getLocale() }}">
<head>
	<meta charset="utf-8" />
	<meta content="width=device-width, initial-scale=1.0, maximum-scale=1.0, user-scalable=no" name="viewport" />
	<meta content="Lapak Kreatif Lamongan" name="author" />

	<!-- HTML Meta Tags -->
	<title>Lapak Kreatif Lamongan</title>
	<meta name="description" content="eOrder - Solusi Rekap Pemesanan Sales Terbaik & Gratis Selamanyaaa. Tersedia dalam Web, Android & iOS">

	<!-- Facebook Meta Tags -->
	<meta property="og:url" content="https://lapakkreatif.com">
	<meta property="og:type" content="website">
	<meta property="og:title" content="Lapak Kreatif Lamongan">
	<meta property="og:description" content="eOrder - Solusi Rekap Pemesanan Sales Terbaik & Gratis Selamanyaaa. Tersedia dalam Web, Android & iOS">
	<meta property="og:image" content="">

	<!-- Twitter Meta Tags -->
	<meta name="twitter:card" content="summary_large_image">
	<meta property="twitter:domain" content="lapakkreatif.com">
	<meta property="twitter:url" content="https://lapakkreatif.com">
	<meta name="twitter:title" content="Lapak Kreatif Lamongan">
	<meta name="twitter:description" content="eOrder - Solusi Rekap Pemesanan Sales Terbaik & Gratis Selamanyaaa. Tersedia dalam Web, Android & iOS">
	<meta name="twitter:image" content="">

	
	<!-- ================== BEGIN core-css ================== -->
	<link href="https://fonts.googleapis.com/css?family=Open+Sans:300,400,600,700" rel="stylesheet" />
	<link href="assets/css/one-page-parallax/vendor.min.css" rel="stylesheet" />
	<link href="assets/css/one-page-parallax/app.min.css" rel="stylesheet" />
	<link href="https://maxcdn.bootstrapcdn.com/font-awesome/4.5.0/css/font-awesome.min.css" rel="stylesheet" />
	<link href="assets/css/app.css" rel="stylesheet" />

	<!-- Google tag (gtag.js) -->
	<script async src="https://www.googletagmanager.com/gtag/js?id=G-VT39GBYGX9"></script>
	<script>
		window.dataLayer = window.dataLayer || [];
		function gtag(){dataLayer.push(arguments);}
		gtag('js', new Date());

		gtag('config', 'G-VT39GBYGX9');
	</script>
</head>
@php
	$bodyClass = (!empty($appBoxedLayout)) ? 'boxed-layout ' : '';
	$bodyClass .= (!empty($paceTop)) ? 'pace-top ' : $bodyClass;
	$bodyClass .= (!empty($bodyClass)) ? $bodyClass . ' ' : $bodyClass;
	$appSidebarHide = (!empty($appSidebarHide)) ? $appSidebarHide : '';
	$appHeaderHide = (!empty($appHeaderHide)) ? $appHeaderHide : '';
	$appSidebarTwo = (!empty($appSidebarTwo)) ? $appSidebarTwo : '';
	$appSidebarSearch = (!empty($appSidebarSearch)) ? $appSidebarSearch : '';
	$appTopMenu = (!empty($appTopMenu)) ? $appTopMenu : '';
	
	$appClass = (!empty($appTopMenu)) ? 'app-with-top-menu ' : '';
	$appClass .= (!empty($appHeaderHide)) ? 'app-without-header ' : ' app-header-fixed ';
	$appClass .= (!empty($appSidebarEnd)) ? 'app-with-end-sidebar ' : '';
	$appClass .= (!empty($appSidebarLight)) ? 'app-with-light-sidebar ' : '';
	$appClass .= (!empty($appSidebarWide)) ? 'app-with-wide-sidebar ' : '';
	$appClass .= (!empty($appSidebarHide)) ? 'app-without-sidebar ' : '';
	$appClass .= (!empty($appSidebarMinified)) ? 'app-sidebar-minified ' : '';
	$appClass .= (!empty($appSidebarTwo)) ? 'app-with-two-sidebar app-sidebar-end-toggled ' : '';
	$appClass .= (!empty($appContentFullHeight)) ? 'app-content-full-height ' : '';
	
	$appContentClass = (!empty($appContentClass)) ? $appContentClass : '';
@endphp
<body class="{{ $bodyClass }}">
	@include('includes.component.page-loader')
	
	<div id="app" class="app app-sidebar-fixed {{ $appClass }}">
		
		@includeWhen(!$appHeaderHide, 'includes.header')
		
		@includeWhen($appTopMenu, 'includes.top-menu')
		
		@includeWhen(!$appSidebarHide, 'includes.sidebar')
		
		@includeWhen($appSidebarTwo, 'includes.sidebar-right')
		
		<div id="content" class="app-content {{ $appContentClass }}">
			@yield('content')
		</div>
		
		@include('includes.component.scroll-top-btn')
		
		
	</div>
	
	@yield('outside-content')

	<script src="assets/js/one-page-parallax/vendor.min.js"></script>
	<script src="assets/js/one-page-parallax/app.min.js"></script>
	<link
		rel="stylesheet"
		href="https://cdnjs.cloudflare.com/ajax/libs/animate.css/4.1.1/animate.min.css"
	/>
	<script src="https://unpkg.com/typeit@8.7.1/dist/index.umd.js"></script>

	<script type="text/javascript">
		const instance = new TypeIt("#typeIt", {
			speed: 350,
			loop: true,
		  })
		  .type("<strong>Creative </strong>")
		  .pause(200)
		  .type("<span class='text-theme'>Team</span>")
		  .pause(300)
		  .delete(4)
		  .type("<span class='text-theme'>Agency</span>")
		  .pause(300)
		  .delete(6)
		  .type("<span class='text-theme'>Solution</span>")
		  .pause(300)
		  .go();

		setTimeout(function() {
			//$('#modal-promo').modal('show');	
		}, 2000);
	</script>
</body>
</html>
