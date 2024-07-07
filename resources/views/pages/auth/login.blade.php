@extends('layouts.default', [
	'paceTop' => true,
	'appSidebarHide' => true,
	'appHeaderHide' => true,
	'appContentClass' => 'p-0'
])

@section('title', 'Login Page')

@section('content')
	<!-- BEGIN login -->
	<div class="login login-v1">
		<!-- BEGIN login-container -->
		<div class="login-container">
			<!-- BEGIN login-header -->
			<div class="login-header">
				<div class="brand">
					<div class="d-flex align-items-center">
						<span class="logo"></span>{{ $company->remark }}
					</div>
					<small>{{ $company->address }} ({{ $settings->version }})</small>
				</div>
				<div class="icon">
					<i class="fa fa-lock"></i>
				</div>
			</div>
			<!-- END login-header -->
			
			<!-- BEGIN login-body -->
			<div class="login-body">
				<!-- BEGIN login-content -->
				<div class="login-content fs-13px">
					<div class="row">
                        <div class="col-9"></div>
                        <div class="col-3">
                            <a class="btn btn-primary mb-2 mt-2 btn-sm" id="btn-back" href="/profile">KEMBALI</a>
                        </div>
                    </div>
					<form action="{{ route('login.perform') }}" method="post">
						<input type="hidden" name="_token" value="{{ csrf_token() }}" />
						<div class="form-floating mb-20px">
							<input type="text"  name="username" value="{{ old('username') }}" class="form-control fs-13px h-45px" id="emailAddress" placeholder="Username"  required="required"/>
							<label for="emailAddress" class="d-flex align-items-center py-0">Username</label>
							@if ($errors->has('username'))
								<span class="text-danger text-left">{{ $errors->first('username') }}</span>
							@endif
						</div>
						<div class="form-floating mb-20px">
							<input type="password" name="password" class="form-control fs-13px h-45px" id="password" placeholder="Password" />
							<label for="password" class="d-flex align-items-center py-0">Password</label>
							@if ($errors->has('password'))
								<span class="text-danger text-left">{{ $errors->first('password') }}</span>
							@endif
						</div>
						<div class="form-check mb-20px">
							<input class="form-check-input" type="checkbox" value="" id="rememberMe"  name="remember" />
							<label class="form-check-label" for="rememberMe">
								@lang('login.checkbox')
							</label>
						</div>
						<div class="login-buttons">
							<button type="submit" class="btn h-45px btn-success d-block w-100 btn-lg">@lang('login.button')</button>
						</div>
					</form>
				</div>
				<!-- END login-content -->
			</div>
			<!-- END login-body -->
		</div>
		<!-- END login-container -->
	</div>
	<!-- END login -->
@endsection