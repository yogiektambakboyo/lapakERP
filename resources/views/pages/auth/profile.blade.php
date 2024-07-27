@extends('layouts.default_home', [
	'paceTop' => true,
	'appSidebarHide' => true,
	'appHeaderHide' => true,
	'appContentClass' => 'p-0'
])
@section('title', 'Landing Page')

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
							<a class="nav-link active" href="#home">BERANDA</a>
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
						<!-- <li class="nav-item"><a class="nav-link" href="#work" data-click="scroll-to-target">KLIEN</a></li> -->
						<li class="nav-item"><a class="nav-link" href="#pricing" data-click="scroll-to-target">HARGA</a></li>
						<li class="nav-item"><a class="nav-link" href="#afiliate" data-click="scroll-to-target">PROGRAM AFILIASI</a></li>
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
			<div class="content-bg" style="background-image: url(assets/img/bg/bg-home.jpg);" 
				data-paroller="true" 
				data-paroller-type="foreground" 
				data-paroller-factor="-0.25">
			</div>
			<!-- end content-bg -->
			<!-- begin container -->
			<div class="container home-content">
				<h1 id="typeIt"></h1>
				<h3>Bikin Hal Keren Bareng Kami!</h3>
				<p>
					Kembangkan bisnis Anda, hemat waktu, dan ciptakan perangkat lunak khusus yang indah yang memberikan hasil luar biasa
				</p>
				<a href="#service" class="btn btn-theme btn-primary">Lihat Layanan</a> <a href="#contact" class="btn btn-theme btn-outline-white">Kontak Kami</a><br />
				<br />
			</div>
			<!-- end container -->
		</div>
		<!-- end #home -->
		
		<!-- begin #about -->
		<div id="about" class="content" data-scrollview="true">
			<!-- begin container -->
			<div class="container" data-animation="true" data-animation-type="animate__fadeInDown">
				<h2 class="content-title">TENTANG KAMI</h2>
				<p class="content-desc">
					Hai Sobat Kekinian! Siap Bikin Digital-Mu Makin WOW?
				</p>
				<!-- begin row -->
				<div class="row">
					<!-- begin col-4 -->
					<div class="col-lg-4">
						<!-- begin about -->
						<div class="about">
							<h3 class="mb-3">Cerita Kekinian Kami</h3>
							<p>
								Dulu, kita dimulai dari garasi yang gak lebih besar dari kamar mandi. Nggak nyangka kan? Tapi dengan semangat kekinian dan obsesi buat bikin yang beda, kami terus berkembang.
								Pernah suatu waktu, kita mendapat proyek menantang dari Klien pertama. Waktu itu, mereka butuh solusi digital yang gak cuma bikin kerjaan jadi lebih efisien, tapi juga bisa bikin mata orang melotot kagum. Kami nerima tantangan itu dengan semangat tinggi, dan hasilnya? Boom! Kita berhasil bikin aplikasi kece yang disambut baik oleh semua orang.
							</p>
							<p>
								Dan sekarang, kami di sini bukan hanya sebagai penyedia jasa software, tapi sebagai kawan kekinian yang bisa ngobrolin apa aja. Kita percaya bahwa teknologi bukan cuma soal coding, tapi juga soal keakraban dan kecerdasan dalam merangkul ide-ide kreatif.
							</p>
						</div>
						<!-- end about -->
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4">
						<h3 class="mb-3">Filosofi Kami</h3>
						<!-- begin about-author -->
						<div class="about-author">
							<div class="quote">
								<i class="fa fa-quote-left"></i>
								<h3>We work harder,<br /><span>to let our user keep simple</span></h3>
								<i class="fa fa-quote-right"></i>
							</div>
							<div class="author">
								<div class="image">
									<img src="assets/img/user/g1.png" alt="Yogi Aditya" />
								</div>
								<div class="info">
									Yogi Aditya
									<small>Founder</small>
								</div>
							</div>
						</div>
						<!-- end about-author -->
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4">
						<h3 class="mb-3">Kerennya Kami</h3>
						<!-- begin skills -->
						<div class="skills">
							<div class="skills-name">Aplikasi Web</div>
							<div class="progress mb-3">
								<div class="progress-bar progress-bar-striped progress-bar-animated bg-theme" style="width: 95%">
									<span class="progress-number">95%</span>
								</div>
							</div>
							<div class="skills-name">Server Cloud</div>
							<div class="progress mb-3">
								<div class="progress-bar progress-bar-striped progress-bar-animated bg-theme" style="width: 90%">
									<span class="progress-number">90%</span>
								</div>
							</div>
							<div class="skills-name">Database Design</div>
							<div class="progress mb-3">
								<div class="progress-bar progress-bar-striped progress-bar-animated bg-theme" style="width: 95%">
									<span class="progress-number">100%</span>
								</div>
							</div>
							<div class="skills-name">Aplikasi Smartphone (Andorid & iOS)</div>
							<div class="progress mb-3">
								<div class="progress-bar progress-bar-striped progress-bar-animated bg-theme" style="width: 100%">
									<span class="progress-number">100%</span>
								</div>
							</div>
						</div>
						<!-- end skills -->
					</div>
					<!-- end col-4 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #about -->
		
		<!-- begin #milestone -->
		<div id="milestone" class="content bg-black-darker has-bg" data-scrollview="true">
			<!-- begin content-bg -->
			<div class="content-bg" style="background-image: url(assets/img/bg/bg-milestone.jpg)"></div>
			<!-- end content-bg -->
			<!-- begin container -->
			<div class="container">
				<!-- begin row -->
				<div class="row">
					<!-- begin col-3 -->
					<div class="col-lg-6 milestone-col">
						<div class="milestone">
							<div class="number" data-animation="true" data-animation-type="number" data-final-number="3">3</div>
							<div class="title">Klien Perusahaan</div>
						</div>
					</div>
					<!-- end col-3 -->
					<!-- begin col-3 -->
					<div class="col-lg-6 milestone-col">
						<div class="milestone">
							<div class="number" data-animation="true" data-animation-type="number" data-final-number="23">23</div>
							<div class="title">Aplikasi</div>
						</div>
					</div>
					<!-- end col-3 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #milestone -->
		
		<!-- begin #team -->
		<div id="team" class="content" data-scrollview="true">
			<!-- begin container -->
			<div class="container">
				<h2 class="content-title">TIM KAMI</h2>
				<p class="content-desc">
					Kenalan Sama Tim Kekinian Kita!
				</p>
				<!-- begin row -->
				<div class="row">
					<!-- begin col-4 -->
					<div class="col-lg-4">
						<!-- begin team -->
						<div class="team shadow p-3 mb-5 bg-body rounded">
							<div class="image" data-animation="true" data-animation-type="animate__flipInX">
								<img src="assets/img/user/g1.png" alt="Ryan Teller" />
							</div>
							<div class="info">
								<h3 class="name">Yogi Aditya</h3>
								<div class="title text-theme">FOUNDER</div>
								<p>Bos kita yang nggak pernah kehabisan ide keren. Dia yang pertama kali ngerintis & sekarang jadi jendral yang memimpin tim menuju kesuksesan!</p>
								<div class="social">
									<a href="#"><i class="fab fa-facebook-f fa-lg fa-fw"></i></a>
									<a href="#"><i class="fab fa-twitter fa-lg fa-fw"></i></a>
									<a href="#"><i class="fab fa-google-plus-g fa-lg fa-fw"></i></a>
								</div>
							</div>
						</div>
						<!-- end team -->
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4">
						<!-- begin team -->
						<div class="team shadow p-3 mb-5 bg-body rounded">
							<div class="image" data-animation="true" data-animation-type="animate__flipInX">
								<img src="assets/img/user/g2.png" alt="Jonny Cash" />
							</div>
							<div class="info">
								<h3 class="name">Dhanurendra M.</h3>
								<div class="title text-theme">LEAD DEVELOPER</div>
								<p>Jagoan coding yang bisa bikin apapun jadi nyata. Dia selalu update sama teknologi terbaru, jadi proyek-proyek kita selalu kekinian.</p>
								<div class="social">
									<a href="#"><i class="fab fa-facebook-f fa-lg fa-fw"></i></a>
									<a href="#"><i class="fab fa-twitter fa-lg fa-fw"></i></a>
									<a href="#"><i class="fab fa-google-plus-g fa-lg fa-fw"></i></a>
								</div>
							</div>
						</div>
						<!-- end team -->
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4">
						<!-- begin team -->
						<div class="team shadow p-3 mb-5 bg-body rounded">
							<div class="image" data-animation="true" data-animation-type="animate__flipInX">
								<img src="assets/img/user/g3.png" alt="Mia Donovan" />
							</div>
							<div class="info">
								<h3 class="name">Nabila Almahyra</h3>
								<div class="title text-theme">PROJEK MANAJER</div>
								<p>Manajer kita yang kece abis! Dia yang bikin proyek berjalan mulus dan hasilnya selalu sesuai ekspektasi klien. </p>
								<div class="social">
									<a href="#"><i class="fab fa-facebook-f fa-lg fa-fw"></i></a>
									<a href="#"><i class="fab fa-twitter fa-lg fa-fw"></i></a>
									<a href="#"><i class="fab fa-google-plus-g fa-lg fa-fw"></i></a>
								</div>
							</div>
						</div>
						<!-- end team -->
					</div>
					<!-- end col-4 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #team -->
		
		<!-- begin #quote -->
		<div id="quote" class="content bg-black-darker has-bg" data-scrollview="true">
			<!-- begin content-bg -->
			<div class="content-bg" style="background-image: url(assets/img/bg/bg-quote.jpg)"
				data-paroller-factor="0.5"
				data-paroller-factor-md="0.01"
				data-paroller-factor-xs="0.01">
			</div>
			<!-- end content-bg -->
			<!-- begin container -->
			<div class="container" data-animation="true" data-animation-type="animate__fadeInLeft">
				<!-- begin row -->
				<div class="row">
					<!-- begin col-12 -->
					<div class="col-lg-12 quote">
						<i class="fa fa-quote-left"></i> Passion leads to design, design leads to performance, <br />
						performance leads to <span class="text-theme">success</span>!  
						<i class="fa fa-quote-right"></i>
						<small>Hamba Tuhan, Developer Teams</small>
					</div>
					<!-- end col-12 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #quote -->
		
		<!-- beign #service -->
		<div id="service" class="content" data-scrollview="true">
			<!-- begin container -->
			<div class="container">
				<h2 class="content-title">Keren Apa Aja yang Bisa Kita Bantu?</h2>
				<p class="content-desc">
				</p>
				<!-- begin row -->
				<div class="row">
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-cog"></i></div>
							<div class="info">
								<h4 class="title">Bikin Aplikasi Online yang Gak Bikin Bete</h4>
								<p class="desc">Gak mau ribet pake aplikasi? Tenang aja, kami bikin aplikasi yang gampang dipake, seru, dan bisa diakses di mana aja!</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-paint-brush"></i></div>
							<div class="info">
								<h4 class="title">Ngehubungin Sistem Biar Makin Oke</h4>
								<p class="desc">Bingung nyambungin aplikasi satu sama lain? Kita ahlinya! Bikin semuanya jadi satu paket supaya kerjaan jadi makin efisien.</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-file"></i></div>
							<div class="info">
								<h4 class="title">Bikin Tampilan Aplikasi Jadi Kece Abis</h4>
								<p class="desc">Gak cuma bikin aplikasi, tapi juga bikin tampilannya cetar! Desain yang kekinian biar yang pake aplikasi kita jadi makin enjoy.</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-code"></i></div>
							<div class="info">
								<h4 class="title">Makai Teknologi Kece</h4>
								<p class="desc">Gak ketinggalan jaman, selalu update dengan teknologi terbaru.</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-shopping-cart"></i></div>
							<div class="info">
								<h4 class="title">Gak Bikin Pusing</h4>
								<p class="desc">Proyek kita didasarkan sama apa yang lo butuhin dan gak ribet.</p>
							</div>
						</div>
					</div>
					<!-- end col-4 -->
					<!-- begin col-4 -->
					<div class="col-lg-4 col-md-6">
						<div class="service">
							<div class="icon" data-animation="true" data-animation-type="animate__bounceIn"><i class="fa fa-heart"></i></div>
							<div class="info">
								<h4 class="title">Gak Sekedar Bikin, Tapi Temen Baik</h4>
								<p class="desc">Kita bukan cuma bikin aplikasi, tapi juga jadi temen lo buat berkembang bareng!</p>
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
		
		<!-- beign #action-box -->
		<div id="action-box" class="content has-bg" data-scrollview="true">
			<!-- begin content-bg -->
			<div class="content-bg" style="background-image: url(assets/img/bg/bg-action.jpg)"
				data-paroller-factor="0.5"
				data-paroller-factor-md="0.01"
				data-paroller-factor-xs="0.01">
			</div>
			<!-- end content-bg -->
			<!-- begin container -->
			<div class="container" data-animation="true" data-animation-type="animate__fadeInRight">
				<!-- begin row -->
				<div class="row action-box">
					<!-- begin col-9 -->
					<div class="col-lg-9">
						<div class="icon-large text-theme">
							<i class="fab fa-google-play"></i>
						</div>
						<h3>Cari tahu aplikasi kami di Play Store</h3>
						<p>
							
						</p>
					</div>
					<!-- end col-9 -->
					<!-- begin col-3 -->
					<div class="col-lg-3">
						<a href="https://play.google.com/store/apps/dev?id=8515839296231278601" target="_blank">
							<img src="assets/img/user/google_play.png" alt="">
						</a>
					</div>
					<!-- end col-3 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #action-box -->
		
		<!-- begin #client -->
		<div id="client" class="content has-bg bg-green" data-scrollview="true">
			<!-- begin content-bg -->
			<div class="content-bg" style="background-image: url(assets/img/bg/bg-client.jpg)"
				data-paroller-factor="0.5"
				data-paroller-factor-md="0.01"
				data-paroller-factor-xs="0.01">
			</div>
			<!-- end content-bg -->
			<!-- begin container -->
			<div class="container" data-animation="true" data-animation-type="animate__fadeInUp">
				<h2 class="content-title">Yuk intip cerita kece para sahabat tentang pengalaman mereka dengan Software House Keren. Gak sabar? Baca terus deh di bawah!</h2>
				<!-- begin carousel -->
				<div class="carousel testimonials slide" data-ride="carousel" id="testimonials">
					<!-- begin carousel-inner -->
					<div class="carousel-inner text-center">
						<!-- begin item -->
						<div class="carousel-item active">
							<blockquote>
								<i class="fa fa-quote-left"></i>
								Aku kaget banget sama desain dan fitur keren dari perangkat lunak mereka. Gampang dipake dan bener-bener ngebantu banget buat bisnisku. Mantul pokoknya!"
								<i class="fa fa-quote-right"></i>
							</blockquote>
							<div class="name"> — <span class="text-theme">Amanda</span>, Bos Muda</div>
						</div>
						<!-- end item -->
						<!-- begin item -->
						<div class="carousel-item">
							<blockquote>
								<i class="fa fa-quote-left"></i>
								Tim mereka gokil banget, responnya cepet dan totalitasnya juara! Mereka dengerin banget kebutuhan kita dan kasih solusi yang bener-bener kekinian. Thank you banget Software House Keren!" 
								<i class="fa fa-quote-right"></i>
							</blockquote>
							<div class="name"> — <span class="text-theme">- Budi</span>, Penggemar Startup</div>
						</div>
						<!-- end item -->
						<!-- begin item -->
						<div class="carousel-item">
							<blockquote>
								<i class="fa fa-quote-left"></i>
								Software House Keren bener-bener ngebantu banget nih buat ngelancarin operasional bisnisku. Puas banget sama hasilnya, pokoknya gak ragu direkomendasiin ke temen-temen lain!"
								<i class="fa fa-quote-right"></i>
							</blockquote>
							<div class="name"> — <span class="text-theme">Daniel</span>, Bos Resto Hits</div>
						</div>
						<!-- end item -->
					</div>
					<!-- end carousel-inner -->
					<!-- begin carousel-indicators -->
					<ol class="carousel-indicators m-b-0">
						<li data-bs-target="#testimonials" data-bs-slide-to="0" class="active"></li>
						<li data-bs-target="#testimonials" data-bs-slide-to="1" class=""></li>
						<li data-bs-target="#testimonials" data-bs-slide-to="2" class=""></li>
					</ol>
					<!-- end carousel-indicators -->
				</div>
				<!-- end carousel -->
			</div>
			<!-- end containter -->
		</div>
		<!-- end #client -->
		
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
								<li><small>Komisi Afiliasi : Rp. 500/Pengguna</small></li>
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
								<li><small>Komisi Afiliasi Rp25.000/Pengguna/Bulan</small></li>
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
								<li><small>Komisi Afiliasi Rp50.000/Pengguna/Bulan</small></li>
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
								<li><small>Komisi Afiliasi 15%</small></li>
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

		<!-- begin #afiliate -->
		<div id="afiliate" class="content bg-light" data-scrollview="true">
			<!-- begin container -->
			<div class="container">
				<h2 class="content-title">Program Afiliasi</h2>
				<p class="content-desc">
					Pengen dapat penghasilan tambahan bulanan? Ceritain produk kita ke teman kamu yang punya usaha dan ajak mereka untuk ikut berkembang bersama lapakERP. Sebagai ucapan terima kasih karena udah promosikan produk dari kita, kamu akan berhak mendapatkan komisi sesuai paket produk yang temanmu pakai.
				</p>
				<!-- begin row -->
				<div class="row">
					<!-- begin col-6 -->
					<div class="col-lg-1"></div>
					<div class="col-lg-10" data-animation="true" data-animation-type="animate__fadeInLeft">
						<img class="img-fluid" src="assets/img/work/afiliate.png"/>

					</div>
					<div class="col-lg-1"></div>
					<!-- end col-6 -->
				</div>
				<!-- end row -->
			</div>
			<!-- end container -->
		</div>
		<!-- end #afiliate -->
		
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
						<p class="social-list">
							<a href="https://www.instagram.com/lapakkreatiflamongan"><i class="fab fa-instagram fa-fw h3"></i></a>
							<a href="https://x.com/lapakkreatiflmg"><i class="fab fa-twitter fa-fw h3"></i></a>
							<a href="https://www.youtube.com/@LapakKreatifLamongan"><i class="fab fa-youtube fa-fw h3"></i></a>
							<a href="https://www.facebook.com/profile.php?id=100079772493705&locale=id_ID"><i class="fab fa-facebook-f fa-fw h3"></i></a>
						</p>
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
							<img src="assets/img/user/banner_promo.jpg" width="100%" alt="">
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