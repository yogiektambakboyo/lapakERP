@php
	$appHeaderClass = (!empty($appHeaderInverse)) ? 'app-header-inverse ' : '';
	$appHeaderMenu = (!empty($appHeaderMenu)) ? $appHeaderMenu : '';
	$appHeaderMegaMenu = (!empty($appHeaderMegaMenu)) ? $appHeaderMegaMenu : ''; 
	$appHeaderTopMenu = (!empty($appHeaderTopMenu)) ? $appHeaderTopMenu : '';
@endphp

<!-- BEGIN #header -->
<div id="header" class="app-header {{ $appHeaderClass }}">
	<!-- BEGIN navbar-header -->
	<div class="navbar-header">
		@if ($appSidebarTwo)
		<button type="button" class="navbar-mobile-toggler" data-toggle="app-sidebar-end-mobile">
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		@endif
		<a href="/" class="navbar-brand"><span class="navbar-logo"></span> <b>Lapak</b> ERP</a>
		@if ($appHeaderMegaMenu && !$appSidebarTwo)
		<button type="button" class="navbar-mobile-toggler" data-bs-toggle="collapse" data-bs-target="#top-navbar">
			<span class="fa-stack fa-lg">
				<i class="far fa-square fa-stack-2x"></i>
				<i class="fa fa-cog fa-stack-1x mt-1px"></i>
			</span>
		</button>
		@endif
		@if($appTopMenu && !$appSidebarHide && !$appSidebarTwo)
		<button type="button" class="navbar-mobile-toggler" data-toggle="app-top-menu-mobile">
			<span class="fa-stack fa-lg">
				<i class="far fa-square fa-stack-2x"></i>
				<i class="fa fa-cog fa-stack-1x mt-1px"></i>
			</span>
		</button>
		@endif
		@if($appTopMenu && $appSidebarHide && !$appSidebarTwo)
		<button type="button" class="navbar-mobile-toggler" data-toggle="app-top-menu-mobile">
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		@endif
		@if (!$appSidebarHide)
		<button type="button" class="navbar-mobile-toggler" data-toggle="app-sidebar-mobile">
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
			<span class="icon-bar"></span>
		</button>
		@endif
	</div>
	
	@includeWhen($appHeaderMegaMenu, 'includes.component.header-mega-menu')
	
	<!-- BEGIN header-nav -->
	<div class="navbar-nav">
		<div class="navbar-item dropdown">
			<a href="#" data-bs-toggle="dropdown" class="navbar-link dropdown-toggle icon">
				<i class="fa fa-bell"></i>
				<!-- <span class="badge">5</span> -->
			</a>
			@include('includes.component.header-dropdown-notification')
		</div>
		
		<div class="navbar-item dropdown">
			<a href="#" class="navbar-link dropdown-toggle" data-bs-toggle="dropdown">
				<span class="d-none d-sm-inline ms-1"><img src="{{ url('/') }}{{ App::getLocale()=='en'?'/assets/img/flag/en.png':'/assets/img/flag/id.png' }}" width="16px" height="16px"></span> <b class="caret"></b>
			</a>
			<div class="dropdown-menu dropdown-menu-end">
				<a href="{{ route('setting.lang',"en") }}" class="dropdown-item"><span class="flag-icon flag-icon-us me-2" title="us"></span> English</a>
				<a href="{{ route('setting.lang',"id") }}" class="dropdown-item"><span class="flag-icon flag-icon-cn me-2" title="id"></span> Indonesia</a>
			</div>
		</div>
		
		<div class="navbar-item navbar-user dropdown">
			<a href="#" class="navbar-link dropdown-toggle d-flex align-items-center" data-bs-toggle="dropdown">
				<img src="/assets/img/user/user-13.jpg" alt="" /> 
				<span>
					<span class="d-none d-md-inline">
					@auth
						{{auth()->user()->name}} 
					@endauth
					</span>
					<b class="caret"></b>
				</span>
			</a>
			@include('includes.component.header-dropdown-profiles')
		</div>
		
		@if($appSidebarTwo)
		<div class="navbar-divider d-none d-md-block"></div>
		<div class="navbar-item d-none d-md-block">
			<a href="javascript:;" data-toggle="app-sidebar-end" class="navbar-link icon">
				<i class="fa fa-th"></i>
			</a>
		</div>
		@endif
	</div>
	<!-- END header-nav -->
</div>
<!-- END #header -->