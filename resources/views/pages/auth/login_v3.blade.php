@extends('layouts.default', [
	'paceTop' => true,
	'appSidebarHide' => true,
	'appHeaderHide' => true,
	'appContentClass' => 'p-0'
])

@section('title', 'Login Page')

@section('content')
	<!-- BEGIN login -->
	<div class="login login-with-news-feed">
		<!-- BEGIN news-feed -->
		<div class="news-feed">
			<div class="news-image" style="background-image: url(/assets/img/login-bg/login-bg-11.jpg)"></div>
			<div class="news-caption">
				<h4 class="caption-title"><b>{{ $company->remark }}</b></h4>
				<p>
					Welcome to the Point of Sales Portal
				</p>
			</div>
		</div>
		<!-- END news-feed -->
		
		<!-- BEGIN login-container -->
		<div class="login-container">
			<!-- BEGIN login-header -->
			<div class="login-header mb-30px">
				<div class="brand">
					<div class="d-flex align-items-center">
						<span class="logo"></span>
						
						
						<b>Login</b>
					</div>
					<small>Sign in to start your session</small>
				</div>
				<div class="icon">
					<i class="fa fa-sign-in-alt"></i>
				</div>
			</div>
			<!-- END login-header -->
			
			<!-- BEGIN login-content -->
			<div class="login-content">
				<form action="{{ route('login.perform') }}" method="post" class="fs-13px">
					<input type="hidden" name="_token" value="{{ csrf_token() }}" />
                    <div class="form-floating mb-15px">
						<input type="text" class="form-control h-45px fs-13px" placeholder="Email Address" id="username" name="username"/>
						<label for="emailAddress" class="d-flex align-items-center fs-13px text-gray-600">Email Address</label>
                        @if ($errors->has('username'))
							<span class="text-danger text-left  mt-1 mb-1">{{ $errors->first('username') }}</span>
						@endif
					</div>
					<div class="form-floating mb-15px">
						<input type="password" name="password" class="form-control h-45px fs-13px" placeholder="Password" id="password" />
						<label for="password" class="d-flex align-items-center fs-13px text-gray-600">Password</label>
                        @if ($errors->has('password'))
							<span class="text-danger text-left  mt-1 mb-1">{{ $errors->first('password') }}</span>
						@endif
                        @if (($errors) && !$errors->has('password'))
							<span class="text-danger text-left mt-1 mb-1">{{ $errors->first() }}</span>
						@endif
					</div>
					
					<div class="mb-15px">
						<button type="submit" class="btn btn-success d-block h-45px w-100 btn-lg fs-14px">@lang('login.button')</button>
					</div>
					<div class="mb-40px pb-40px text-dark">
						
					</div>
					<hr class="bg-gray-600 opacity-2" />
					<div class="text-gray-600 text-center text-gray-500-darker mb-0">
						&copy; All Right Reserved 2024
					</div>
				</form>
			</div>
			<!-- END login-content -->
		</div>
		<!-- END login-container -->
	</div>
	<!-- END login -->
@endsection
