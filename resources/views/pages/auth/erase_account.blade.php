@extends('layouts.default', [
	'paceTop' => true,
	'appSidebarHide' => true,
	'appHeaderHide' => true,
	'appContentClass' => 'p-0'
])

@section('title', 'Bali Foam - Menghapus Akun')

@section('content')
	<!-- BEGIN login -->
	<div class="row container">
		<div class="mt-5">
			<h2>Kebijakan & Privasi Aplikasi Seluler KAKIKU</h2>
		</div>
		<div>
			<h2>Menghapus akun Anda</h2>
		</div>
		<br>
		<div>
			Dengan menghapus akun, Anda tidak akan bisa mendapatkan kembali akses aplikasi dan data Anda. Semua data akun KAKIKU Anda akan dihapus
		</div>
		<div>
			Data yang akan dihapus meliputi Nama, Alamat, Email, Handphone, Transaksi dan Semua Log.
		</div>
		<div class="mb-3">
			<label for="email_account" class="form-label">Alamat Email</label>
			<input type="email" class="form-control" id="email_account" placeholder="name@example.com">
		</div>
		<div class="mb-3">
			<label for="pass_account" class="form-label">Password</label>
			<input type="password" class="form-control" id="pass_account">
		</div>
		<div class="mb-3">
			<button class="btn btn-primary">Submit</button>
		</div>
		<br><br>
		Hubungi kami
		<br>
		Jika Anda mempunyai pertanyaan mengenai Kebijakan Privasi ini, Anda dapat menghubungi kami:
		<br>Melalui email: yogiektambakboyo@gmail.com
		<br>Dengan mengunjungi halaman ini di website kami: www.lapakkreatif.com/profile
        <br>Lapak Kreatif Lamongan


	</div>
	<!-- END login -->
@endsection