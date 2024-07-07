@extends('layouts.default', [
	'paceTop' => true,
	'appSidebarHide' => true,
	'appHeaderHide' => true,
	'appContentClass' => 'p-0'
])

@section('title', 'Pendaftaran')

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
                    <div class="row mb-2">
                        <div class="col-9">
                            <h1 class="text-white">Pendaftaran</h1>
                        </div>
                        <div class="col-3">
                            <a class="btn btn-primary mb-2 mt-2 btn-sm" id="btn-back" href="/profile">KEMBALI</a>
                        </div>
                    </div>
					<form action="{{ route('register.store_regis') }}" method="post">
                        @if(session()->has('success'))
                            <div class="alert alert-success">
                                {{ session('success') }}
                            </div>
                        @endif
						<input type="hidden" name="_token" value="{{ csrf_token() }}" />
						<div class="form-floating mb-20px">
							<input type="company"  name="company" value="{{ old('company') }}" class="form-control fs-13px h-45px" id="company" placeholder="Nama Perusahaan"  required="required"/>
							<label for="company" class="d-flex align-items-center py-0">Masukkan Nama Perusahaan</label>
							@if ($errors->has('company'))
								<span class="text-danger text-left">{{ $errors->first('company') }}</span>
							@endif
						</div>
                        <div class="form-floating mb-20px">
							<input type="email"  name="email" value="{{ old('email') }}" class="form-control fs-13px h-45px" id="email" placeholder="Alamat Email"  required="required"/>
							<label for="email" class="d-flex align-items-center py-0">Masukkan Alamat Email</label>
							@if ($errors->has('email'))
								<span class="text-danger text-left">{{ $errors->first('email') }}</span>
							@endif
						</div>
						<div class="form-floating mb-20px">
							<input type="password" name="password" class="form-control fs-13px h-45px" id="password" placeholder="Password"  required="required"/>
							<label for="password" class="d-flex align-items-center py-0">Masukkan Password (Minimal 6 karakter)</label>
							@if ($errors->has('password'))
								<span class="text-danger text-left">{{ $errors->first('password') }}</span>
							@endif
						</div>
                        <div class="form-floating mb-20px">
							<input type="password" name="password_again" class="form-control fs-13px h-45px" id="password_again" placeholder="Masukkan Password Sekali Lagi" required="required" />
							<label for="password_again" class="d-flex align-items-center py-0">Masukkan Password Sekali Lagi</label>
							@if ($errors->has('password_again'))
								<span class="text-danger text-left">{{ $errors->first('password_again') }}</span>
							@endif
						</div>
						<div class="login-buttons">
							<button type="submit" id="submit" class="btn h-45px btn-success d-block w-100 btn-lg d-none">DAFTAR</button>
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

<script src="https://code.jquery.com/jquery-3.7.1.min.js" integrity="sha256-/JqT3SQfawRcv/BIHPThkBvs0OEvtFFmqPF/lYI/Cxo=" crossorigin="anonymous"></script>
<script type="text/javascript">
    $('#password').on('change keyup paste', function(){
        $('#submit').removeClass('d-none');

        var pass_lama = $('#password').val();
        var pass_again = $('#password_again').val();

        if(pass_lama != pass_again || pass_again.length < 6 ){
            $('#submit').addClass('d-none');
        }

    });

    $('#password_again').on('change keyup paste', function(){
        $('#submit').removeClass('d-none');

        var pass_lama = $('#password').val();
        var pass_again = $('#password_again').val();

        if(pass_lama != pass_again || pass_again.length < 6){
            $('#submit').addClass('d-none');
        }

    });

</script>


@endsection


