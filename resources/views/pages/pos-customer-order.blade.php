@extends('layouts.default', [
	'paceTop' => true, 
	'appContentFullHeight' => true, 
	'appContentClass' => 'p-0',
	'appSidebarHide' => true,
	'appHeaderHide' => true
])

@section('title', 'POS - Customer Order System')

@push('scripts')
	<script src="/assets/js/demo/pos-customer-order.demo.js"></script>
@endpush

@section('content')
	
	<!-- BEGIN pos -->
	<div class="pos pos-customer" id="pos-customer">
		
		<!-- BEGIN pos-menu -->
		<div class="pos-menu">
			<div class="logo">
				<a href="#">
					<div class="logo-img"><img src="/assets/img/pos/logo.svg" /></div>
					<div class="logo-text">Menu</div>
				</a>
			</div>
			<div class="nav-container">
				<div data-scrollbar="true" data-height="100%" data-skip-mobile="true" id="content_side_bar">
					<ul class="nav nav-tabs">
						<li class="nav-item">
							<a class="nav-link active" href="#" data-filter="all">
								<i class="fa fa-fw fa-utensils me-1 ms-n2"></i> All Items
							</a>
						</li>
					</ul>
				</div>
			</div>
		</div>
		<!-- END pos-menu -->
		
		<!-- BEGIN pos-content -->
		<div class="pos-content">
			<div class="row bg-light py-2 px-3">
				<div class="col-md-12 fs-3 fw-bold">ORDER ONLINE - {{ $branch[0]->remark }}</div>
				<input type="hidden" name="branch_ids" id="branch_ids" value="{{ $branch[0]->id }}">
			</div>
			<div class="pos-content-container" data-scrollbar="true" data-height="100%" data-skip-mobile="true">
				<div class="product-row" id="content_product">
				
				</div>
			</div>
		</div>
		<!-- END pos-content -->
		
		<!-- BEGIN pos-sidebar -->
		<div class="pos-sidebar" id="pos-sidebar">
			<div class="pos-sidebar-header">
				<div class="back-btn">
					<button type="button" data-dismiss-class="pos-mobile-sidebar-toggled" data-target="#pos-customer" class="btn">
						<svg viewBox="0 0 16 16" class="bi bi-chevron-left" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
							<path fill-rule="evenodd" d="M11.354 1.646a.5.5 0 0 1 0 .708L5.707 8l5.647 5.646a.5.5 0 0 1-.708.708l-6-6a.5.5 0 0 1 0-.708l6-6a.5.5 0 0 1 .708 0z"/>
						</svg>
					</button>
				</div>
				<div class="icon"><img src="/assets/img/pos/icon-table.svg" /></div>
				<div class="title col-sm-7"><label for="" id="customer_name">{{ $customer_name }}</label></div>
				<input type="hidden" id="customer_id" name="customer_id" value="{{ $customer_id }}">
				<div class=""><input class="btn btn-warning btn-sm @php echo $customer_id==""?"":"d-none"; @endphp " type="button" id="btn_login" value="Login" data-bs-toggle="modal" data-bs-target="#modalLogin" ></div>
			</div>
			<div class="pos-sidebar-nav">
				<ul class="nav nav-tabs nav-fill">
					<li class="nav-item">
						<a class="nav-link active" href="#" data-bs-toggle="tab" data-bs-target="#newOrderTab"><label id="order_qty"> New Order (0)</label></a>
					</li>
					<li class="nav-item">
						<a class="nav-link" href="#" data-bs-toggle="tab" data-bs-target="#orderHistoryTab" id="history_qty">Order History (0)</a>
					</li>
				</ul>
			</div>
			<div class="pos-sidebar-body tab-content" data-scrollbar="true" data-height="100%">
				<div class="tab-pane fade h-100 show active" id="newOrderTab">
					<div class="pos-table" id="content_order">
						
					</div>
				</div>
				<div class="tab-pane fade h-100" id="orderHistoryTab">
					<div class="pos-table" id="content_history">
						
					</div>
				</div>
			</div>
			<div class="pos-sidebar-footer">
				<div class="total">
					<div class="text">Total</div>
					<div class="price" id="order_total">0</div>
				</div>
				<div class="btn-row">
					<a href="#" class="btn btn-success" onclick="saveOrder();"><i class="fa fa-check fa-fw fa-lg"></i> Submit Order</a>
				</div>
			</div>
		</div>
		<!-- END pos-sidebar -->
	</div>
	<!-- END pos -->
	
	<!-- BEGIN pos-mobile-sidebar-toggler -->
	<a href="#" class="pos-mobile-sidebar-toggler" data-toggle-class="pos-mobile-sidebar-toggled" data-target="#pos-customer">
		<svg viewBox="0 0 16 16" class="img" fill="currentColor" xmlns="http://www.w3.org/2000/svg">
			<path fill-rule="evenodd" d="M14 5H2v9a1 1 0 0 0 1 1h10a1 1 0 0 0 1-1V5zM1 4v10a2 2 0 0 0 2 2h10a2 2 0 0 0 2-2V4H1z"/>
			<path d="M8 1.5A2.5 2.5 0 0 0 5.5 4h-1a3.5 3.5 0 1 1 7 0h-1A2.5 2.5 0 0 0 8 1.5z"/>
		</svg>
		<!-- <span class="badge">5</span> -->
	</a>
	<!-- END pos-mobile-sidebar-toggler -->
	
	<!-- BEGIN #modalPosItem -->
	<div class="modal modal-pos-item fade" id="modalPosItem">
		<div class="modal-dialog modal-lg">
			<div class="modal-content">
				<div class="modal-body p-0">
					<a href="#" data-bs-dismiss="modal" class="btn-close position-absolute top-0 end-0 m-4"></a>
					<div class="pos-product">
						<div class="pos-product-img">
							<div class="img" id="modal_photo" style="background-size: contain;background-image: url(/assets/img/pos/product-1.jpg)"></div>
						</div>
						<div class="pos-product-info">
							<input type="hidden" name="modal_id"  id="modal_id" value="0">
							<div class="title" id="modal_remark"></div>
							<div class="desc"  id="modal_product_desc">
								
							</div>
							<div class="price" id="modal_price"></div>
							<hr />
							<div class="option-row">
								<div class="qty">
									<div class="input-group">
										<a href="#" class="btn btn-default"  onclick="minQty();"><i class="fa fa-minus"></i></a>
										<input type="text" class="form-control border-0 text-center" id="modal_qty" name="modal_qty" value="1" />
										<a href="#" class="btn btn-default" onclick="addQty();"><i class="fa fa-plus"></i></a>
									</div>
								</div>
							</div>
							<div class="row">
								<a href="#" class="btn btn-default col-md-5 me-2" data-bs-dismiss="modal">@lang('general.lbl_cancel')</a>
								<a href="#" class="btn btn-success col-md-5" onclick="addOrder()"  data-bs-dismiss="modal">Add to cart <i class="fa fa-plus fa-fw ms-2"></i></a>
							</div>
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- END #modalPosItem -->

	<!-- BEGIN #modalLogin -->
	
	<div class="modal modal-pos-item fade" id="modalLogin">
		<div class="modal-dialog modal-sm">
			<div class="modal-content">
				<div class="modal-body p-2">
					<a href="#" data-bs-dismiss="modal" class="btn-close position-absolute top-0 end-0 m-4"></a>
					<div class="row mt-1">
						<div class="col-sm-11">
							<label class="h3" for="">Data Pembeli</label>
						</div>
					</div>
					<div class="row mt-1">
						<div class="col-sm-11">
							<label class="modal_name" for="">Nama</label>
						</div>
						<div class="col-sm-11 mt-1">
							<input  class="form form-control"  type="text" name="modal_name" id="modal_name">
						</div>
					</div>
					<div class="row mt-1">
						<div class="col-sm-11">
							<label class="modal_handphone" for="">No Handphone</label>
						</div>
						<div class="col-sm-11 mt-1">
							<input  class="form form-control"  type="number" name="modal_handphone" id="modal_handphone">
						</div>
					</div>

					<div class="row mt-2 d-flex flex-row-reverse">
						<div class="col-sm-4">
							<input type="button" data-bs-dismiss="modal" class="btn btn-sm btn-danger"  name="btn-login" id="btn-login" value="Submit">
						</div>
					</div>
				</div>
			</div>
		</div>
	</div>
	<!-- END #modalLogin -->
@endsection

@push('scripts')
	<script type="text/javascript">
			var productCat = [];
			var productList = [];
			var orderList = [];
			var historyList = [];
			var url = "{{ route('invoices.getproduct_public') }}";
            const res = axios.get(url, {
              headers: {
                'Content-Type': 'application/json'
              }
            }).then(resp => {
                $('#content_side_bar').html("");
                $content = '<ul class="nav nav-tabs"> <li class="nav-item"><a class="nav-link active" href="#" data-filter="all"><i class="fa fa-fw fa-utensils me-1 ms-n2"></i> All Items</a></li>';
              
                for(var i=0;i<resp.data.data_category.length;i++){
				var productC = {
						"category_id"        : resp.data.data_category[i]["category_id"],
						"category_name"      : resp.data.data_category[i]["category_name"]
				}

				productCat.push(productC);

				// Generate Product Card
				$content = $content + '<li class="nav-item"><a class="nav-link" href="#" data-filter="'+ resp.data.data_category[i]["category_id"] +'"><i class="fa fa-fw fa-hamburger me-1 ms-n2"></i> '+resp.data.data_category[i]["category_name"] +'</a></li>';
				}

				$content = $content + '</ul>';


				$('#content_side_bar').html($content);
				  

				$('#content_product').html("");
                $content_p = '';
            

                for(var i=0;i<resp.data.data.length;i++){
					var product = {
							"photo"      : resp.data.data[i]["photo"],
							"uom"      : resp.data.data[i]["uom"],
							"id"      : resp.data.data[i]["id"],
							"remark"      : resp.data.data[i]["remark"],
							"abbr"      : resp.data.data[i]["category_name"],
							"category_name"      : resp.data.data[i]["category_name"],
							"category_id"      : resp.data.data[i]["category_id"],
							"brand_name"      : resp.data.data[i]["brand_name"],
							"price"      : resp.data.data[i]["price"],
							"discount"      : 0,
							"qty"      : 0,
							"total"      : 0,
							"product_desc"      : resp.data.data[i]["product_desc"],
					}

					productList.push(product);

					// Generate Product Card
					$content_p = $content_p + '<div class="product-container" onclick="showItem('+resp.data.data[i]["id"]+')" data-type="'+resp.data.data[i]["category_id"]+'"><a href="#" class="product" id="'+resp.data.data[i]["id"]+'" data-bs-toggle="modal" data-bs-target="#modalPosItem"><div class="img" style="background-size: contain;background-image: url(/images/user-files/'+resp.data.data[i]["photo"]+')"></div><div class="text"><div class="title">'+resp.data.data[i]["remark"]+'</div><div class="desc">'+resp.data.data[i]["product_desc"]+'</div><div class="price">'+currency((resp.data.data[i]["price"]), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format()+'</div></div></a></div>';
				}


				$('#content_product').html($content_p);
				
          });

		  if($('#customer_id').val()==""){

		  }else{
				const json = JSON.stringify({
						customer_id : $('#customer_id').val(),
						branch_id : $('#branch_ids').val()
					}
				);
				const res = axios.post("{{ route('home.get_order') }}", json, {
					headers: {
					// Overwrite Axios's automatically set Content-Type
					'Content-Type': 'application/json'
					}
				}).then(resp => {
						if(resp.data.status=="success"){
							$('#content_history').html("");
							var $content = "";
							var result = resp.data.data;
							for (let index = 0; index < result.length; index++) {
								const element = result[index];

								var history = {
									"id"      : element.id,
									"dated"      : element.dated,
									"order_no"      : element.order_no,
									"total"      : element.total,
									"total_payment"      : element.total_payment,
								}

								var status_p = "UnPaid";
								var dnone = "";
								if(parseFloat(element.total)<=parseFloat(element.total_payment)){
									status_p = "Paid";
									dnone = "d-none";
								}

								$content = $content + '<div class="row pos-table-row">'+
									'<div class="col-9">'+
											'<div class="title">'+ element.order_no +'</div>'+
											'<div class="single-price">'+ element.dated +'</div>'+
									'</div>'+
									'<div class="col-3">'+
										'<div>'+ currency((element.total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format() +'</div>'+
										'<div>'+ status_p +'</div>'+
									'</div>'+
								'</div><div class="col-md-12 d-grid border-bottom p-1"><input type="button" class="btn btn-danger '+dnone+'" onclick="paymentClick('+ element.id +');" value="Bayar"></div>';


								historyList.push(history);
								
							}

							$('#history_qty').text("History ("+result.length+")");
            				$('#content_history').html($content);
						}
				});
		  }

		  function paymentClick(id){
			for (let index = 0; index < historyList.length; index++) {
				const element = historyList[index];
				if(element.id == id){
					alert(element.order_no);
				}
			}
		  }

		  function saveOrder(){
			var customer_id = $('#customer_id').val();
			if(orderList.length<=0){
				Swal.fire(
					{
					position: 'top-end',
					icon: 'warning',
					text: "@lang('general.lbl_msg_failed')",
					showConfirmButton: false,
					imageHeight: 30, 
					imageWidth: 30,   
					timer: 1500
					}
				);
			}else if(customer_id == ""){
				$('#modalLogin').modal('show');
			}else{
				Swal.fire({
							text: "@lang('general.lbl_sure_chekout_title') ",
							title : "@lang('general.lbl_confirmation')",
							icon: 'question',
							showDenyButton: false,
							showCancelButton: true,
							cancelButtonColor: '#d33',
							denyButtonColor: '#0072b3',
							cancelButtonText: "@lang('general.lbl_cancel')",
							confirmButtonText: "@lang('general.lbl_sure_checkout')",
						}).then((result) => {
							/* Read more about isConfirmed, isDenied below */
							if (result.isConfirmed) {
								const json = JSON.stringify({
									customer_id : $('#customer_id').val(),
									remark : "Online",
									currency : "IDR",
									kurs : "1",
									payment_nominal : "0",
									total_order : total,
									total_payment : "-",
									payment_type : "",
									voucher_code : "",
									total_discount : "0",
									total_vat : "0",
									remark : "Online",
									branch_id : $('#branch_ids').val(),
									product : orderList,
								}
							);
							const res = axios.post("{{ route('home.store_order') }}", json, {
								headers: {
								// Overwrite Axios's automatically set Content-Type
								'Content-Type': 'application/json'
								}
							}).then(resp => {
									if(resp.data.status=="success"){
										$order_no = resp.data.data;
										
										

										if(resp.data.redirect_url != ""){
											window.location.href = resp.data.redirect_url;
										}else{
											Swal.fire(
											{
												position: 'top-end',
												icon: 'success',
												text: "@lang('general.lbl_msg_success_invoice') : "+resp.data.data,
												showConfirmButton: false,
												imageHeight: 30, 
												imageWidth: 30,   
												timer: 1500
												}
											);
										}


									}else{
										Swal.fire(
											{
											position: 'top-end',
											icon: 'warning',
											text: "@lang('general.lbl_msg_failed')"+resp.data.message,
											showConfirmButton: false,
											imageHeight: 30, 
											imageWidth: 30,   
											timer: 1500
											}
										);
									}
							});
							
							} else{
							
							}
				});
			}
			
		  }

		  function showItem(id){
			for (let index = 0; index < productList.length; index++) {
				const element = productList[index];
				if(id==element.id){
					$('#modal_remark').text(element.remark);
					$('#modal_id').val(element.id);
					$('#modal_qty').val("1");
					$('#modal_price').text(currency((element.price), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());
					$('#modal_product_desc').text(element.product_desc);
					$('#modal_photo').css('background-image','url(/images/user-files/'+element.photo+')');
				}
			}
		  }

		  $('#btn-login').on('click', function(){
			$name = $('#modal_name').val();
			$handphone = $('#modal_handphone').val();

			if($name == ""){
				Swal.fire(
							{
							position: 'top-end',
							icon: 'warning',
							text: "Please fill name first",
							showConfirmButton: false,
							imageHeight: 30, 
							imageWidth: 30,   
							timer: 1500
							}
						);
			}else if($handphone == ""){
				Swal.fire(
							{
							position: 'top-end',
							icon: 'warning',
							text: "Please fill handphone first",
							showConfirmButton: false,
							imageHeight: 30, 
							imageWidth: 30,   
							timer: 1500
							}
						);
			}else{
				const json = JSON.stringify({
						name : $('#modal_name').val(),
						phone_no : $('#modal_handphone').val(),
						branch_id : $('#branch_ids').val()
					}
				);
				const res = axios.post("{{ route('home.setsession') }}", json, {
					headers: {
					// Overwrite Axios's automatically set Content-Type
					'Content-Type': 'application/json'
					}
				}).then(resp => {
						if(resp.data.status=="success"){
							$('#customer_name').text($('#modal_name').val());
							$('#customer_id').val(resp.data.data);
							$('#btn_login').addClass('d-none');

							const json = JSON.stringify({
									customer_id : $('#customer_id').val(),
									branch_id : $('#branch_ids').val()
								}
							);
							const res = axios.post("{{ route('home.get_order') }}", json, {
								headers: {
								// Overwrite Axios's automatically set Content-Type
								'Content-Type': 'application/json'
								}
							}).then(resp => {
									if(resp.data.status=="success"){
										$('#content_history').html("");
										var $content = "";
										var result = resp.data.data;
										for (let index = 0; index < result.length; index++) {
											const element = result[index];

											var history = {
												"id"      : element.id,
												"dated"      : element.dated,
												"order_no"      : element.order_no,
												"total"      : element.total,
												"total_payment"      : element.total_payment,
											}

											var status_p = "UnPaid";
											var dnone = "";
											if(parseFloat(element.total)<=parseFloat(element.total_payment)){
												status_p = "Paid";
												dnone = "d-none";
											}

											$content = $content + '<div class="row pos-table-row">'+
												'<div class="col-9">'+
														'<div class="title">'+ element.order_no +'</div>'+
														'<div class="single-price">'+ element.dated +'</div>'+
												'</div>'+
												'<div class="col-3">'+
													'<div>'+ currency((element.total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format() +'</div>'+
													'<div>'+ status_p +'</div>'+
												'</div>'+
											'</div><div class="col-md-12 d-grid border-bottom p-1"><input type="button" class="btn btn-danger '+dnone+'" onclick="paymentClick('+ element.id +');" value="Bayar"></div>';


											historyList.push(history);
											
										}

										$('#history_qty').text("History ("+result.length+")");
										$('#content_history').html($content);
									}
							});
							
						}else{
						Swal.fire(
							{
							position: 'top-end',
							icon: 'warning',
							text: "@lang('general.lbl_msg_failed')"+resp.data.message,
							showConfirmButton: false,
							imageHeight: 30, 
							imageWidth: 30,   
							timer: 1500
							}
						);
						}
				});
			}

			

		  });

		  function addOrder(){
			var product_id = $('#modal_id').val();
			var product_qty = $('#modal_qty').val();

			for (let index = 0; index < productList.length; index++) {
				const element = productList[index];
				if(product_id==element.id){

					var isExist = 0; 
					for (let index2 = 0; index2 < orderList.length; index2++) {
						const element2 = orderList[index2];

						if(element2.id == element.id){
							isExist = 1;
							orderList[index2].qty = parseFloat(orderList[index2].qty) + parseFloat(product_qty);
							orderList[index2].total = (parseFloat(orderList[index2].qty) + parseFloat(product_qty)) * parseFloat(orderList[index2].price) ;
						}
						
					}

					if(isExist == 0){
						var order = {
							"id" : element.id,
							"abbr" : element.abbr,
							"remark" : element.remark,
							"price" : element.price,
							"uom" : element.uom,
							"photo" : element.photo,
							"vat" : "0",
							"vat_total" : "0",
							"total_vat" : "0",
							"discount" : "0",
							"applypromo" : "0",
							"promo_no" : "",
							"qty" : product_qty,
							"total" : parseFloat(element.price) * parseFloat(product_qty),
							"seq" : Date.now()
						}

						orderList.push(order);
					}

					
				}
			}

			refreshTableOrder();
		  }

		  function refreshTableOrder(){
			$('#content_order').html("");
            var $content = "";
            sub_total = 0;
            discount_total = 0;
            total = 0;
            for (let index = 0; index < orderList.length; index++) {
                orderList[index].total = (orderList[index].qty)*(parseFloat(orderList[index].price)-parseFloat(orderList[index].discount));
                const element = orderList[index];
                $content = $content + '<div class="row pos-table-row"><div class="col-9"><div class="pos-product-thumb"><div class="img" style="background-image: url(/images/user-files/'+element.photo+')"></div><div class="info"><div class="title">'+ element.remark +'</div><div class="single-price">'+ currency((element.price), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format() +'</div><div class="input-group qty"><div class="input-group-append"><a href="#" onclick="minItemList('+ element.id +')" class="btn btn-default"><i class="fa fa-minus"></i></a></div><input type="text" id="list_qty_'+ element.id +'" class="form-control" value="'+ element.qty +'" readonly /><div class="input-group-prepend"><a href="#" class="btn btn-default" onclick="addItemList('+ element.id +')"><i class="fa fa-plus"></i></a></div></div></div></div></div><div class="col-3 total-price">'+ currency((element.total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format() +'</div></div>';

                sub_total = sub_total + (parseFloat(element.price) * parseFloat(element.qty)) ;
                discount_total = discount_total + (parseFloat(orderList[index].discount)*orderList[index].qty);
                total = total + parseFloat(element.total);
            }

			$('#order_total').text(currency((total), { separator: ".", decimal: ",", symbol: "", precision: 0 }).format());

            $('#order_qty').text("New Order ("+orderList.length+")");
            $('#content_order').html($content);
		  }

		  function addItemList(id){
			var qty = $('#list_qty_'+id).val();
			$('#list_qty_'+id).val(parseInt(qty)+1);
			for (let index = 0; index < orderList.length; index++) {
				var element = orderList[index];
					if(element.id == id){
						orderList[index].qty = parseInt(orderList[index].qty)+1;
				}
			}

			refreshTableOrder();

		  }

		  function minItemList(id){
			var qty = $('#list_qty_'+id).val();
			if(parseFloat(qty)>1){
				$('#list_qty_'+id).val(parseInt(qty)-1);
				for (let index = 0; index < orderList.length; index++) {
					var element = orderList[index];
						if(element.id == id){
							orderList[index].qty = parseInt(orderList[index].qty)-1;
					}
				}
			}else{
				for (let index = 0; index < orderList.length; index++) {
					var element = orderList[index];
						if(element.id == id){
							orderList.splice(index,1);
						}
				}
			}

			refreshTableOrder();
		  }

		  function addQty(){
			var qty = $('#modal_qty').val();
			$('#modal_qty').val(parseInt(qty)+1);
		  }

		  function minQty(){
			var qty = $('#modal_qty').val();
			if(parseFloat(qty)>0){
				$('#modal_qty').val(parseInt(qty)-1);
			}
		  }
	</script>
@endpush
