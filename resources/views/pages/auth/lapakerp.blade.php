@extends('layouts.default_home', [
	'paceTop' => true,
	'appSidebarHide' => true,
	'appHeaderHide' => true,
	'appContentClass' => 'p-0'
])
@section('title', 'LapakERP')

@section('content')
<body data-bs-spy='scroll' data-bs-target='#header' data-bs-offset='51'>
	<!-- begin #page-container -->
	<div id="page-container" class="fade">
		<!-- begin #header -->
		<div id="header" class="header navbar navbar-transparent navbar-fixed-top navbar-expand-lg">
			<!-- begin container -->
			<div class="container">
				<!-- begin navbar-brand -->
				<a href="<?= url('/'); ?>" class="navbar-brand">
					<span class="brand-logo"></span>
					<span class="brand-text">
						<span class="text-theme">Lapak</span> Kreatif
					</span>
				</a>
				<!-- end navbar-brand -->
				<!-- begin navbar-toggle -->
				<button type="button" class="navbar-toggle collapsed" data-bs-toggle="collapse" data-bs-target="#header-navbar">
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
					<span class="icon-bar"></span>
				</button>
				<!-- end navbar-header -->
				<!-- begin navbar-collapse -->
				<div class="collapse navbar-collapse" id="header-navbar">
					<ul class="nav navbar-nav navbar-end">
						<li class="nav-item dropdown">
							<a class="nav-link active" href="/profile">BERANDA</a>
						</li>
						<li class="nav-item dropdown">
							<a class="nav-link active" href="#home" data-click="scroll-to-target" data-scroll-target="#home">PRODUK <b class="caret"></b></a>
							<div class="dropdown-menu dropdown-menu-left animate__animated animate__fadeInDown">
								<a class="dropdown-item" href="/eorder">eOrder Sales (SFA)</a>
								<a class="dropdown-item" href="/lapakerp">LapakERP</a>
								<a class="dropdown-item" href="#">ePresensi  <span class="badge badge-secondary">coming soon</span></a>
							</div>
						</li>
						<li class="nav-item"><a class="nav-link" href="#service" data-click="scroll-to-target">LAYANAN</a></li>
						<li class="nav-item"><a class="nav-link" href="#pricing" data-click="scroll-to-target">HARGA</a></li>
						<li class="nav-item"><a class="nav-link" href="#contact" data-click="scroll-to-target">KONTAK</a></li>
					</ul>

					<div class="ms-4">
						<a class="btn btn-sm btn-success" href="/login">LOGIN</a>
						<a class="btn btn-sm btn-danger ms-1" href="/register">DAFTAR GRATIS</a>
					</div>

					

				</div>
				<!-- end navbar-collapse -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #header -->
		
		<!-- begin #home -->
		<div id="home" class="content has-bg home">
			<!-- begin content-bg -->
			<div class="content-bg" style="background-image: url(assets/img/bg/gallery-1.jpg);" 
				data-paroller="true" 
				data-paroller-type="foreground" 
				data-paroller-factor="-0.25">
			</div>
			<!-- end content-bg -->
			<!-- begin container -->
			<div class="container home-content">
				<h1 id="">LapakERP</h1>
				<h3>Bisnisnya Jalan, Boss-nya Jalan-Jalan</h3>
				<p>
					Sekarang Anda bisa analisa bisnis semudah baca koran
				</p>
					<a href="#service" class="btn btn-outline-white">Detail Fitur</a>
					<a href="/register" class="btn btn-danger btn-primary">Daftar Gratis</a> 				
				<br />
			</div>
			<!-- end container -->
		</div>
		<!-- end #home -->

		<!-- beign #profit -->
		<div id="profit" class="content" data-scrollview="true">
			<!-- begin container -->
			<div class="container">
				<h2 class="content-title">Puluhan tahun jalanin Bisnis, tapi masih repot dengan ginian?</h2>
				<p class="content-desc">
				</p>
				<!-- begin row -->
				<div class="row">
					<!-- begin col-6 -->
					<div class="col-lg-6 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa-solid fa-xmark"></i></div>
							<div class="info mt-3">
								<h5 class="title">Cashflow seret akibat ratusan piutang tidak tertagih</h5>
							</div>
						</div>
					</div>
					<!-- end col-6 -->
					<!-- begin col-6 -->
					<div class="col-lg-6 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa-solid fa-xmark"></i></div>
							<div class="info mt-1">
								<h5 class="title">Kewalahan saat melakukan stok opname ribuan stok secara manual</h5>
							</div>
						</div>
					</div>
					<!-- end col-6 -->



					<!-- begin col-6 -->
					<div class="col-lg-6 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa-solid fa-xmark"></i></div>
							<div class="info mt-1">
								<h5 class="title">Tidak punya data stok yang akurat, hitungnya masih manual</h5>
							</div>
						</div>
					</div>
					<!-- end col-6 -->
					<!-- begin col-6 -->
					<div class="col-lg-6 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa-solid fa-xmark"></i></div>
							<div class="info mt-1">
								<h5 class="title">Profit tipis akibat sales nakal markup harga dan membuat nota dobel</h5>
							</div>
						</div>
					</div>
					<!-- end col-6 -->

					<!-- begin col-6 -->
					<div class="col-lg-6 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa-solid fa-xmark"></i></div>
							<div class="info mt-1">
								<h5 class="title">Rugi karena harga produk tidak uptodate dan tidak sadar jualan di bawah HPP</h5>
							</div>
						</div>
					</div>
					<!-- end col-6 -->
					<!-- begin col-6 -->
					<div class="col-lg-6 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa-solid fa-xmark"></i></div>
							<div class="info mt-1">
								<h5 class="title">Lambat dalam mengambil keputusan karena butuh waktu berhari-hari</h5>
							</div>
						</div>
					</div>
					<!-- end col-6 -->
					
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #profit -->
		
	
		<!-- beign #service -->
		<div id="service" class="content" data-scrollview="true">
			<!-- begin container -->
			<div class="container">
				<h2 class="content-title">Keren apa aja yang bisa kamu dapetin kalo pake LapakERP?</h2>
				<p class="content-desc">
				</p>
				<!-- begin row -->
				<div class="row">
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-cog"></i></div>
							<div class="info">
								<h4 class="title">Cashflow Lancar Bisnis Makin Besar</h4>
								<p class="desc">Cashflow bisnis terjamin lancar, memudahkan proses penagihan sehingga tidak ada lagi piutang nyangkut berbulan-bulan.</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-paint-brush"></i></div>
							<div class="info">
								<h4 class="title">Monitor Stok secara Real-time</h4>
								<p class="desc">Tidak perlu lagi bingung dengan stok yang hilang atau berbeda dengan catatan! lapakERP akan membantu Anda monitor stok secara real-time.</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-file"></i></div>
							<div class="info">
								<h4 class="title">Analisa Biaya untuk Hindari Kerugian</h4>
								<p class="desc">Hindari kerugian dengan analisa biaya yang mudah dan cepat! Dilengkapi laporan keuangan yang mudah dibaca seperti rekening koran.</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-code"></i></div>
							<div class="info">
								<h4 class="title">Pantau Aktivitas Sales Kanvas dari HP</h4>
								<p class="desc">Aplikasi Android untuk monitoring Salesman dilengkapi GPS Tracking</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-shopping-cart"></i></div>
							<div class="info">
								<h4 class="title">Kontrol Banyak Cabang</h4>
								<p class="desc">Jagonya kontrol puluhan cabang realtime & terpusat</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-heart"></i></div>
							<div class="info">
								<h4 class="title">Layanan Bantuan</h4>
								<p class="desc">Kami siap membantu 24 Jam/7 Hari jika ada kendala</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #service -->
		
		<!-- begin #pricing -->
		<div id="pricing" class="content" data-scrollview="true">
			<!-- begin container -->
			<div class="container">
				<h2 class="content-title">Harga yang Asik, Produk yang Keren!</h2>
				<p class="content-desc">
					Yuk cek harga-harga kece dari produk Software House Keren! Kami punya penawaran spesial buat kamu yang suka yang terbaik tanpa harus nguras kantong. Langsung aja, cek harga di bawah ini!
				</p>
				<!-- begin pricing-table -->
				<ul class="pricing-table pricing-col-4">
					<li data-animation="true" data-animation-type="animate__fadeInUp">
						<div class="pricing-container">
							<h3>Paket Free</h3>
							<div class="price">
								<div class="price-figure">
									<span class="price-number">Rp 0 -,/Gratis</span>
									<span class="price-tenure">Selamanya</span>
								</div>
							</div>
							<ul class="features">
								<li>Web + Android <br>(Aplikasi Bersama)</li>
								<li>1 Cabang</li>
								<li>Cocok untuk bisnis kecil yang baru mulai eksplorasi teknologi.</li>
							</ul>
							<div class="footer">
								<a href="/register" class="btn btn-inverse btn-theme btn-block">Daftar Sekarang</a>
							</div>
						</div>
					</li>
					<li data-animation="true" data-animation-type="animate__fadeInUp">
						<div class="pricing-container">
							<h3>Paket Starter</h3>
							<div class="price">
								<div class="price-figure">
									<span class="price-number">Rp 350K</span>
									<span class="price-tenure">per Bulan</span>
								</div>
							</div>
							<ul class="features">
								<li>2GB Storage</li>
								<li>Up to 50 User Mobile</li>
								<li>Web + Android</li>
								<li>1 Cabang</li>
								<li>Min. kontrak 6 Bulan</li>
								<li>08-17/5 Day Work Support</li>
								<li>Cocok untuk bisnis yang ingin berkembang pesat.</li>
							</ul>
							<div class="footer">
								<a target="_blank" href="https://api.whatsapp.com/send?phone=6285746879090&text=Hi%20Yogi%2C%20Saya%20mau%20buat%20paket%20starter.%20Apakah%20bisa%20dibantu%3F" class="btn btn-inverse btn-theme btn-block">Hubungi Saya</a>
							</div>
						</div>
					</li>
					<li class="highlight" data-animation="true" data-animation-type="animate__fadeInUp">
						<div class="pricing-container">
							<h3>Paket Kreatif</h3>
							<div class="price">
								<div class="price-figure">
									<span class="price-number">Rp 500K</span>
									<span class="price-tenure">per Bulan</span>
								</div>
							</div>
							<ul class="features">
								<li>10GB Storage</li>
								<li>Up to 100 User Mobile</li>
								<li>Multi Cabang</li>
								<li>Web + Android</li>
								<li>Min. kontrak 3 Bulan</li>
								<li>08-17/5 Day Work Support</li>
								<li>Solusi untuk bisnis yang serius ingin meningkatkan efisiensi operasional.</li>
							</ul>
							<div class="footer">
								<a target="_blank" href="https://api.whatsapp.com/send?phone=6285746879090&text=Hi%20Yogi%2C%20Saya%20mau%20buat%20paket%20kreatif.%20Apakah%20bisa%20dibantu%3F" class="btn btn-inverse btn-theme btn-block">Hubungi Saya</a>
							</div>
						</div>
					</li>
					
					<li data-animation="true" data-animation-type="animate__fadeInUp">
						<div class="pricing-container">
							<h3>Paket Developer Plus</h3>
							<div class="price">
								<div class="price-figure">
									<span class="price-number">Custom</span>
								</div>
							</div>
							<ul class="features">
								<li>Biar produkmu jadi beda dan sesuai keinginan, pilihlah solusi custom dari Software House Keren. Kamu bisa mengatur segalanya sesuai gaya hidup dan kebutuhanmu. </li>
								<li>Pilih fitur yang kamu butuhkan, buang yang gak perlu. Kami akan kustomisasi aplikasi sesuai kebutuhanmu.</li>
								<li>24/7 WhatsApp Support</li>
							</ul>
							<div class="footer">
								<a target="_blank" href="https://api.whatsapp.com/send?phone=6285746879090&text=Hi%20Yogi%2C%20Saya%20mau%20buat%20custom%20projek.%20Apakah%20bisa%20dibantu%3F" class="btn btn-inverse btn-theme btn-block">Hubungi Saya</a>
							</div>
						</div>
					</li>
				</ul>
			</div>
			<!-- end container -->
		</div>
		<!-- end #pricing -->
		
		<!-- begin #contact -->
		<div id="contact" class="content bg-light" data-scrollview="true">
			<!-- begin container -->
			<div class="container">
				<h2 class="content-title">Kontak Kami</h2>
				<p class="content-desc">
					Ada pertanyaan atau ide cemerlang? Jangan ragu untuk menghubungi kami. Kami siap mendengar dan berkolaborasi!
				</p>
				<!-- begin row -->
				<div class="row">
					<!-- begin col-6 -->
					<div class="col-lg-6" data-animation="true" data-animation-type="animate__fadeInLeft">
						<h3></h3>
						<p>
							<strong>Lapak Kreatif</strong><br />
							Tambakboyo, RT 01 RW 02<br />
							Kecamatan Tikung, Lamongan<br />
							P: 085746879090<br />
						</p>
						<p>
							<a href="mailto:yogiektambakboyo@gmail.com" class="text-theme">yogiektambakboyo@gmail.com</a>
						</p>
					</div>
					<!-- end col-6 -->
					<!-- begin col-6 -->
					<div class="col-lg-6 form-col" data-animation="true" data-animation-type="animate__fadeInRight">
						
					</div>
					<!-- end col-6 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #contact -->
		
		<!-- begin #footer -->
		<div id="footer" class="footer">
			<div class="container">
				<div class="footer-brand">
					<div class="footer-brand-logo"></div>
					Lapak Kreatif
				</div>
				<p>
					&copy; Copyright Lapak Kreatif 2021 <br />
					An admin & front end theme with serious impact.
				</p>
				<p class="social-list">
					<a href="https://www.instagram.com/lapakkreatiflamongan"><i class="fab fa-instagram fa-fw"></i></a>
					<a href="https://x.com/lapakkreatiflmg"><i class="fab fa-twitter fa-fw"></i></a>
					<a href="https://www.youtube.com/@LapakKreatifLamongan"><i class="fab fa-youtube fa-fw"></i></a>
					<a href="https://www.facebook.com/profile.php?id=100079772493705&locale=id_ID"><i class="fab fa-facebook-f fa-fw"></i></a>
				</p>

				
			</div>
		</div>

		{{-- Modal Promo --}}
		<div class="modal fade" id="modal-promo" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
			<div class="modal-dialog modal-xl">
			  <div class="modal-content">
				<div class="modal-header">
					<button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
				  </div>
				<div class="modal-body">
					<div class="d-flex justify-content-center">
						<a href="/register">
							<img src="assets/img/user/banner_promo.jpg" alt="">
						</a>
					</div>
				</div>
			  </div>
			</div>
		</div>
		{{-- End Modal Promo --}}

		<a href="https://api.whatsapp.com/send?phone=6285746879090&text=Hai%21%20Kak%20Yogi%20Mau%20tanya%20dong" class="custom-float animate__animated animate__repeat-1 animate__tada animate__delay-2s" target="_blank">
			<i class="fa fa-whatsapp my-float"></i>
		</a>
		<!-- end #footer -->
		<!-- begin theme-panel -->
	<div class="theme-panel">
		<a href="javascript:;" data-click="theme-panel-expand" class="theme-collapse-btn"><i class="fa fa-cog"></i></a>
		<div class="theme-panel-content">
			<ul class="theme-list clearfix">
				<li><a href="javascript:;" class="bg-red" data-theme="theme-red" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Red" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-pink" data-theme="theme-pink" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Pink" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-orange" data-theme="theme-orange" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Orange" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-yellow" data-theme="theme-yellow" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Yellow" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-lime" data-theme="theme-lime" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Lime" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-green" data-theme="theme-green" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Green" data-original-title="" title="">&nbsp;</a></li>
				<li class="active"><a href="javascript:;" class="bg-teal" data-theme="" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Default" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-cyan" data-theme="theme-cyan" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Aqua" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-blue" data-theme="theme-blue" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Blue" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-purple" data-theme="theme-purple" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Purple" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-indigo" data-theme="theme-indigo" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Indigo" data-original-title="" title="">&nbsp;</a></li>
				<li><a href="javascript:;" class="bg-black" data-theme="theme-black" data-click="theme-selector" data-bs-toggle="tooltip" data-bs-trigger="hover" data-bs-container="body" data-bs-title="Black" data-original-title="" title="">&nbsp;</a></li>
			</ul>
			<hr class="mb-0" />
			<div class="row mt-10px pt-3px">
				<div class="col-9 control-label text-dark fw-bold">
					<div>Dark Mode <span class="badge bg-primary ms-1 position-relative py-4px px-6px" style="top: -1px">NEW</span></div>
					<div class="lh-14 fs-13px">
						<small class="text-dark opacity-50">
							Adjust the appearance to reduce glare and give your eyes a break.
						</small>
					</div>
				</div>
				<div class="col-3 d-flex">
					<div class="form-check form-switch ms-auto mb-0 mt-2px">
						<input type="checkbox" class="form-check-input" name="app-theme-dark-mode" id="appThemeDarkMode" value="1" />
						<label class="form-check-label" for="appThemeDarkMode">&nbsp;</label>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- end theme-panel -->
	</div>
	<!-- end #page-container -->
</body>
@endsection