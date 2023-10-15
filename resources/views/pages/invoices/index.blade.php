@extends('layouts.default', ['appSidebarSearch' => true])

@section('title', 'Sales Invoice')

@section('content')
    <div class="bg-light p-4 rounded">
        <h1>@lang('general.lbl_invoice')</h1>
        <div class="lead row mb-3">
            <div class="col-md-10">
                <div class="col-md-12">
                    @lang('general.lbl_invoice_title')
                </div>
                <div class="col-md-10"> 	
                    <form action="{{ route('invoices.search') }}" method="GET" class="row row-cols-lg-auto g-3 align-items-center">
                        <input type="hidden" name="filter_begin_date" value="2022-01-01"><input type="hidden" name="filter_end_date" value="2035-01-01">
                        <div class="col-2"><input type="hidden" class="form-control  form-control-sm" name="search" placeholder="@lang('general.lbl_search')" value="{{ $keyword }}"></div>
                        <div class="col-2"><a href="#modal-filter"  data-bs-toggle="modal" data-bs-target="#modal-filter" class="btn btn-sm btn-lime">@lang('general.btn_filter')</a></div>   
                        <div class="col-2"><input type="submit" class="btn btn-sm btn-success" value="@lang('general.btn_export')" name="export"></div>  
                        <div class="col-2"><input type="button" class="btn btn-sm btn-warning d-none" value="Gabung Pembayaran" name="join" id="join_payment"   href="#modal-add-payment" data-bs-toggle="modal" data-bs-target="#modal-add-payment"></div>  
                    </form>
                </div>
            </div>
            <div class="col-md-2">
                <a href="{{ route('invoices.create') }}" class="btn btn-primary float-right {{ $act_permission->allow_create==1?'':'d-none' }}"><span class="fa fa-plus-circle"></span>  @lang('general.btn_create')</a>
            </div>
        </div>
        
        <div class="mt-2">
            @include('layouts.partials.messages')
        </div>

        <table class="table table-striped" id="example">
            <thead>
            <tr>
                <th scope="col" width="14%">@lang('general.lbl_branch')</th>
                <th>@lang('general.invoice_no')</th>
                <th scope="col" width="8%">@lang('general.lbl_dated')</th>
                <th scope="col" width="15%">@lang('general.lbl_total_customer')</th>
                <th scope="col" width="10%">Total</th>
                <th scope="col" width="10%">@lang('general.lbl_total_payment')</th>
                <th scope="col" width="2%" class="nex">@lang('general.lbl_action')</th>  
                <th scope="col" width="2%" class="nex"></th>
                <th scope="col" width="2%" class="nex"></th>    
                <th scope="col" width="2%" class="nex"></th>    
            </tr>
            </thead>
            <tbody>

                @foreach($invoices as $order)
                    <tr>
                        <td>{{ $order->branch_name }}</td>
                        <td @if ($order->is_checkout == 0) class="bg-danger" @endif>{{ $order->invoice_no }}</td>
                        <td>{{ Carbon\Carbon::parse($order->dated)->format('d-m-Y') }}</td>
                        <td>{{ $order->customer }}</td>
                        <td>{{ number_format($order->total,0,',','.') }}</td>
                        <td  @if ($order->total_payment < $order->total) class="bg-warning" @endif>{{ number_format($order->total_payment,0,',','.') }}</td>
                        <td><a href="{{ route('invoices.show', $order->id) }}" class="btn btn-warning btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_show')</a></td>
                        @if (($order->is_checkout == 0)&&($order->total_payment >= $order->total))
                        <td>
                            <a onclick="showConfirmCheckout({{ $order->id }}, '{{ $order->invoice_no }}')" class="btn btn-success btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_checkout')</a>
                        </td>
                        @elseif($order->is_checkout == 0)
                        <td>
                            <a onclick="showErrorCheckout({{ $order->id }}, '{{ $order->invoice_no }}')" class="btn btn-success btn-sm  {{ $act_permission->allow_show==1?'':'d-none' }}">@lang('general.lbl_checkout')</a>
                        </td>
                        @else
                        <td></td>
                        @endif
                        <td><a href="{{ route('invoices.edit', $order->id) }}" class="btn btn-info btn-sm  {{ $act_permission->allow_edit==1?'':'d-none' }} ">@lang('general.lbl_edit')</a></td>
                        <td class=" {{ $act_permission->allow_delete==1?'':'d-none' }}">
                            <a onclick="showConfirm({{ $order->id }}, '{{ $order->invoice_no }}')" class="btn btn-danger btn-sm  {{ $act_permission->allow_delete==1?'':'d-none' }} ">@lang('general.lbl_delete')</a>
                        </td>
                    </tr>
                @endforeach
            </tbody>
        </table>

        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('invoices.search') }}" method="GET">   
                        @csrf 
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id" id="filter_branch_id">
                                <option value="">@lang('general.lbl_allbranch')</option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>

                        <div class="col-md-12">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_date_start')</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_begin_date"
                            id="filter_begin_date"
                            class="form-control" 
                            value="{{ old('filter_begin_date') }}" required/>
                            @if ($errors->has('filter_begin_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_begin_date') }}</span>
                                @endif
                        </div>

                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_date_end')</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" 
                            name="filter_end_date"
                            id="filter_end_date"
                            class="form-control" 
                            value="{{ old('filter_end_date') }}" required/>
                            @if ($errors->has('filter_end_date'))
                                    <span class="text-danger text-left">{{ $errors->first('filter_end_date') }}</span>
                                @endif
                        </div>
                        <br>
                        <div class="col-md-12">
                            <button type="submit" class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
                        </div>
                    </form>
                </div>
            </div>
            </div>
        </div>

        <div class="modal fade" id="modal-add-payment" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg ">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title" id="staticBackdropLabel">Gabung Pembayaran</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                  
                  <div class="container">
                        <div class="row">
                                <label for="input_payment_type" class="col-sm-2 col-form-label">Tipe Bayar</label>
                                <div class="col-sm-2">
                                    <select class="form-control form-control-sm" name="input_payment_type" id="input_payment_type">
                                        <?php 
                                            for ($i=0; $i < count($payment_type); $i++) { 
                                                echo '<option value="'.$payment_type[$i].'">'.$payment_type[$i].'</option>';
                                            }
                                        ?>
                                    </select>
                                </div>

                                <label for="input_payment_nominal" class="col-sm-1 col-form-label">Nominal</label>
                                <div class="col-sm-2">
                                   <input type="number" class="form-control form-control-sm" id="input_payment_nominal" name="input_payment_nominal" value="0">
                                </div>


                                <div class="col-sm-2">
                                    <button class="btn btn-success col-sm-12" id="input_btn_submit">Terapkan</button>
                                 </div>
                                 <div class="col-sm-2">
                                     <button class="btn btn-danger col-sm-12"  id="input_btn_reset">Reset</button>
                                 </div>
                        </div>

                          <div class="mb-3">
                            <table class="table table-striped" id="payment">
                                <thead>
                                <tr>
                                    <th>@lang('general.invoice_no')</th>
                                    <th scope="col" width="15%">@lang('general.lbl_total_customer')</th>
                                    <th scope="col" width="10%">Tipe Bayar</th>
                                    <th scope="col" width="10%">Total</th>
                                    <th scope="col" width="10%">Pembayaran</th>
                                </tr>
                                </thead>
                                <tbody>
                                </tbody>
                            </table>
                          </div>

                          <div class="row">
                            <label for="input_total" class="col-sm-2 col-form-label">Total Tagihan</label>
                            <div class="col-sm-2">
                                <input type="text" class="form-control form-control-sm" id="input_total" name="input_total" value="0" readonly>
                            </div>

                            <label for="input_total_payment" class="col-sm-2 col-form-label">Total Pembayaran</label>
                            <div class="col-sm-2">
                               <input type="text" class="form-control form-control-sm" id="input_total_payment" name="input_total_payment" value="0" readonly>
                            </div>

                            <label for="input_charge" class="col-sm-2 col-form-label">Kembalian</label>
                            <div class="col-sm-2">
                               <input type="text" class="form-control form-control-sm" id="input_charge" name="input_charge" value="0" readonly>
                            </div>
                    </div>

                    <div class="row">
                        <div>Catatan : Faktur akan otomatis ter-checkout setelah proses pembayaran berhasil</div>
                    </div>

                  </div>
      
                </div>
                <div class="modal-footer">
                <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">@lang('general.lbl_close') </button>
                <button type="button" class="btn btn-primary" id="btn_save_payment">@lang('general.lbl_save')</button>
                </div>
            </div>
            </div>
          </div>


    </div>
@endsection


@push('scripts')
    <script type="text/javascript">
         //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');
         
          const today = new Date();
          const yyyy = today.getFullYear();
          const yyyy1 = today.getFullYear()+1;
          let mm = today.getMonth() + 1; // Months start at 0!
          let dd = today.getDate();

          if (dd < 10) dd = '0' + dd;
          if (mm < 10) mm = '0' + mm;

          const formattedToday = mm + '/' + dd + '/' + yyyy;
          const formattedNextYear = mm + '/' + dd + '/' + yyyy1;

          $('#filter_begin_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_begin_date').val(formattedToday);


          $('#filter_end_date').datepicker({
              format : 'yyyy-mm-dd',
              todayHighlight: true,
          });
          $('#filter_end_date').val(formattedToday);

          function showConfirm(id,data){
            Swal.fire({
            title: "@lang('general.lbl_sure')",
            text: "@lang('general.lbl_sure_title') "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
            confirmButtonText: "@lang('general.lbl_sure_delete')"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('invoices.destroy','XX') }}";
                    var lastvalurl = "XX";

                    url = url.replace(lastvalurl, id)
                    const res = axios.delete(url, {}, {
                        headers: {
                            // Overwrite Axios's automatically set Content-Type
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: 'Deleted!',
                                        text: "@lang('general.lbl_msg_delete_title') ",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close') "
                                        }).then((result) => {
                                            window.location.href = "{{ route('invoices.index') }}"; 
                                        })
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
                                    });
                            }
                        });
                    }
                })
        }

        function showErrorCheckout(id,data){

            Swal.fire(
            {
                position: 'top-end',
                icon: 'warning',
                text: "@lang('general.lbl_msg_failed') Faktur "+data+" belum lunas, silahkan penuhi pembayaran dahulu sesuai total ",
                showConfirmButton: false,
                imageHeight: 30, 
                imageWidth: 30,   
                timer: 1500
            });
        }

        function showConfirmCheckout(id,data){
            Swal.fire({
            title: "@lang('general.lbl_sure')",
            text: "@lang('general.lbl_sure_chekout_title') "+data+" !",
            icon: 'warning',
            showCancelButton: true,
            confirmButtonColor: '#3085d6',
            cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
            confirmButtonText: "@lang('general.lbl_sure_checkout')"
            }).then((result) => {
                if (result.isConfirmed) {
                    var url = "{{ route('invoices.checkout','XX') }}";
                    var lastvalurl = "XX";
    
                    url = url.replace(lastvalurl, id)
                    const res = axios.patch(url, {}, {
                        headers: {
                            // Overwrite Axios's automatically set Content-Type
                            'Content-Type': 'application/json'
                        }
                        }).then(
                            resp => {
                                if(resp.data.status=="success"){
                                    Swal.fire({
                                        title: 'Success!',
                                        text: "@lang('general.lbl_msg_checkout_title') ",
                                        icon: 'success',
                                        showCancelButton: false,
                                        confirmButtonColor: '#3085d6',
                                        cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                                        confirmButtonText: "@lang('general.lbl_close') "
                                        }).then((result) => {
                                            window.location.href = "{{ route('invoices.index') }}"; 
                                        })
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
                                    });
                            }
                        });
                    }
                })
        }
    </script>
@endpush

@push('scripts')
<script type="text/javascript">
    let table, table_payment;
    let str_inv = "";
    let list_invoice;
    let list_invoice_init;
    let total_invoice = 0;
    let total_payment = 0;
    let total_charge = 0;
    let total_payment_nominal = 0;
    $(document).ready(function () {
        table = $('#example').DataTable({
                select: {
                    style: 'multi'
                },
        });

        table_payment = $('#payment').DataTable({
            dom: 'lrt',
            columns: [
                { data: 'invoice_no' },
                { data: 'customers_name' },
                { data: 'payment_type' },
                { data: 'total' },
                { data: 'total_payment' }
            ]
        });

        $('#join_payment').on('click',function(){
            str_inv = "";
            $('#join_payment').text("Gabung Pembayaran ("+table.rows({ selected: true }).count()+")");
            rowdata = table.rows('.selected').data();
              for (var i = 0; i < rowdata.length; i++) {
                if(i==0){
                    str_inv = rowdata[i][1]; 
                }else{
                    str_inv = str_inv + ";"+rowdata[i][1]; 
                }
            }

            if(table.rows({ selected: true }).count()>1){
                $('#join_payment').removeClass("d-none");

                const json = JSON.stringify({
                        invoice_no : str_inv,
                    }
                );
              
                var url = "{{ route('invoices.getfreeinvoice') }}";
                const res = axios.post(url, json,
                {
                    headers: {
                      'Content-Type': 'application/json'
                    }
                  }
                ).then(resp => {
                    table_payment.clear().draw();
                    list_invoice = resp.data;
                    list_invoice_init = resp.data;
                    total_invoice = 0;
                    total_payment = 0;
                    resp.data.forEach(element => {
                        table_payment.row.add( {
                            "invoice_no":  element.invoice_no.slice(-6),
                            "customers_name": element.customers_name,
                            "payment_type": element.payment_type,
                            "total": element.total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."),
                            "total_payment": element.total_payment.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")
                        } ).draw();
                        total_invoice = total_invoice + parseFloat(element.total);
                        total_payment = total_payment + parseFloat(element.total_payment);
                    });

                    $('#input_total').val(total_invoice.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."));
                    $('#input_total_payment').val(total_payment.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."));
                    
                });
                

            }else{
                $('#join_payment').addClass("d-none");
            }
           

         });

         table
        .on('select', function (e, dt, type, indexes) {
            if(table.rows({ selected: true }).count()>1){
                $('#join_payment').removeClass("d-none");
            }else{
                $('#join_payment').addClass("d-none");
            }
            $('#join_payment').val("Gabung Pembayaran ("+table.rows({ selected: true }).count()+")");
        })
        .on('deselect', function (e, dt, type, indexes) {
            if(table.rows({ selected: true }).count()>1){
                $('#join_payment').removeClass("d-none");
            }else{
                $('#join_payment').addClass("d-none");
            }
            $('#join_payment').val("Gabung Pembayaran ("+table.rows({ selected: true }).count()+")");
        });

        $('#input_btn_submit').on('click', function(){
            payment_type = $('#input_payment_type').find(':selected').val();
            payment_nominal = $('#input_payment_nominal').val();

            if(payment_nominal == "0"  || payment_nominal == "" || payment_type == ""){
                Swal.fire(
                {
                    position: 'top-end',
                    icon: 'warning',
                    text: "Silahkan lengkapi dahulu tipe pembayaran dan nominal",
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                });
            }else{
                payment_nominal_num = parseFloat(payment_nominal);
                total_payment_nominal =payment_nominal_num;

                total_payment = 0;

                for (let index = 0; index < list_invoice.length; index++) {
                    list_invoice[index].total_payment = "0";
                    list_invoice[index].payment_type = "";
                    list_invoice[index].payment_type_disp = "";
                    list_invoice[index].p_cash = "0";
                    list_invoice[index].p_credit_b1 = "0";
                    list_invoice[index].p_credit_b2 = "0";
                    list_invoice[index].p_debet_b1 = "0";
                    list_invoice[index].p_debet_b2 = "0";
                    list_invoice[index].p_transfer = "0";
                    list_invoice[index].p_qris = "0";
                }

                $('#input_total_payment').val("0");
                $('#input_charge').val("0");


                table_payment.clear().draw();
                list_invoice.forEach(element => {
                    table_payment.row.add( {
                        "invoice_no":  element.invoice_no.slice(-6),
                        "customers_name": element.customers_name,
                        "payment_type": element.payment_type,
                        "total": element.total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."),
                        "total_payment": element.total_payment.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")
                    } ).draw();
                });


                for (let index = 0; index < list_invoice.length; index++) {
                    const element = list_invoice[index];
                    var total_num = parseFloat(element.total);
                    var total_payment_num = parseFloat(element.total_payment);
                    if(payment_nominal_num >= total_num && total_payment_num < total_num){
                        list_invoice[index].total_payment = total_num - total_payment_num;
                        list_invoice[index].payment_type = payment_type;
                        list_invoice[index].payment_type_disp = payment_type;
                       
                        if(payment_type == "Cash"){
                            list_invoice[index].p_cash = total_num - total_payment_num;
                        }else if(payment_type == "Kredit Bank 1"){
                            list_invoice[index].p_credit_b1 = total_num - total_payment_num;
                        }else if(payment_type == "Kredit Bank 2"){
                            list_invoice[index].p_credit_b2 = total_num - total_payment_num;
                        }else if(payment_type == "Debet Bank 1"){
                            list_invoice[index].p_debet_b1 = total_num - total_payment_num;
                        }else if(payment_type == "Debet Bank 2"){
                            list_invoice[index].p_debet_b2 = total_num - total_payment_num;
                        }else if(payment_type == "Transfer"){
                            list_invoice[index].p_transfer = total_num - total_payment_num;
                        }else if(payment_type == "QRIS"){
                            list_invoice[index].p_qris = total_num - total_payment_num;
                        }else if(payment_type == "BCA - Debit"){
                            list_invoice[index].p_debet_b1 = total_num - total_payment_num;
                        }else if(payment_type == "BCA - Kredit"){
                            list_invoice[index].p_credit_b1 = total_num - total_payment_num;
                        }else if(payment_type == "Mandiri - Debit"){
                            list_invoice[index].p_debet_b1 = total_num - total_payment_num;
                        }else if(payment_type == "BCA - Kredit"){
                            list_invoice[index].p_credit_b2 = total_num - total_payment_num;
                        }
                        
                        payment_nominal_num = payment_nominal_num - (total_num - total_payment_num);
                        total_payment = total_payment + (total_num - total_payment_num);

                        console.log(total_payment);
                        

                    }else if(payment_nominal_num > 0 && total_payment_num < total_num && total_payment_num < total_num ){
                        list_invoice[index].payment_type = payment_type;
                        list_invoice[index].payment_type_disp = payment_type;

                        var pay_nom = payment_nominal_num+total_payment_num>=total_num?total_num:payment_nominal_num+total_payment_num;                                
                        var p_nom = payment_nominal_num+total_payment_num>=total_num?payment_nominal_num-(total_num-total_payment_num):payment_nominal_num+total_payment_num;
                        var sisa = payment_nominal_num - p_nom;


                        if(payment_type == "Cash"){
                            list_invoice[index].p_cash = sisa;
                        }else if(payment_type == "Kredit Bank 1"){
                            list_invoice[index].p_credit_b1 = sisa;
                        }else if(payment_type == "Kredit Bank 2"){
                            list_invoice[index].p_credit_b2 = sisa;
                        }else if(payment_type == "Debet Bank 1"){
                            list_invoice[index].p_debet_b1 = sisa;
                        }else if(payment_type == "Debet Bank 2"){
                            list_invoice[index].p_debet_b2 = sisa;
                        }else if(payment_type == "Transfer"){
                            list_invoice[index].p_transfer = sisa;
                        }else if(payment_type == "QRIS"){
                            list_invoice[index].p_qris = sisa;
                        }else if(payment_type == "BCA - Debit"){
                            list_invoice[index].p_debet_b1 = sisa;
                        }else if(payment_type == "BCA - Kredit"){
                            list_invoice[index].p_credit_b1 = sisa;
                        }else if(payment_type == "Mandiri - Debit"){
                            list_invoice[index].p_debet_b1 = sisa;
                        }else if(payment_type == "BCA - Kredit"){
                            list_invoice[index].p_credit_b2 = sisa;
                        }

                        list_invoice[index].total_payment = pay_nom;
                        payment_nominal_num = payment_nominal_num+total_payment_num>=total_num?p_nom:0;
                        total_payment = total_payment + (total_payment_num>=total_num?p_nom:pay_nom);

                        console.log("c "+total_payment);
                    }

                }

                table_payment.clear().draw();
                list_invoice.forEach(element => {
                    table_payment.row.add( {
                        "invoice_no":  element.invoice_no.slice(-6),
                        "customers_name": element.customers_name,
                        "payment_type": element.payment_type_disp,
                        "total": element.total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."),
                        "total_payment": element.total_payment.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")
                    } ).draw();
                });
            }

            $('#input_total_payment').val(total_payment.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."));
            $('#input_charge').val((total_payment_nominal-total_payment).toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."));

            if($('#input_total_payment').val()!=$('#input_total').val()){
                $('#input_total_payment').addClass('text-danger');
            }else{
                $('#input_total_payment').removeClass('text-danger');
            }
        });

        $('#input_btn_reset').on('click', function(){
            total_payment = 0;
            total_payment_nominal = 0;
            for (let index = 0; index < list_invoice.length; index++) {
                list_invoice[index].total_payment = "0";
                list_invoice[index].payment_type = "";
                list_invoice[index].payment_type_disp = "";
                list_invoice[index].p_cash = "0";
                list_invoice[index].p_credit_b1 = "0";
                list_invoice[index].p_credit_b2 = "0";
                list_invoice[index].p_debet_b1 = "0";
                list_invoice[index].p_debet_b2 = "0";
                list_invoice[index].p_transfer = "0";
                list_invoice[index].p_qris = "0";
            }

            $('#input_total_payment').val("0");
            $('#input_charge').val("0");


            table_payment.clear().draw();
            list_invoice.forEach(element => {
                table_payment.row.add( {
                    "invoice_no":  element.invoice_no.slice(-6),
                    "customers_name": element.customers_name,
                    "payment_type": element.payment_type,
                    "total": element.total.toString().replace(/\B(?=(\d{3})+(?!\d))/g, "."),
                    "total_payment": element.total_payment.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ".")
                } ).draw();
            });
        });

        $('#btn_save_payment').on('click', function(){
            if($('#input_total_payment').val()== "" || $('#input_total_payment').val()== "0"){
                Swal.fire(
                {
                    position: 'top-end',
                    icon: 'warning',
                    text: "Silahkan masukkan dulu nominal pembayaran",
                    showConfirmButton: false,
                    imageHeight: 30, 
                    imageWidth: 30,   
                    timer: 1500
                });
            }else{

            Swal.fire({
                    title: "Konfirmasi",
                    text: "Apakah yakin akan memproses pembayaran faktur ini?",
                    icon: 'warning',
                    showCancelButton: true,
                    confirmButtonColor: '#3085d6',
                    cancelButtonColor: '#d33', cancelButtonText: "@lang('general.lbl_cancel')",
                    confirmButtonText: "Ya, Proses"
                    }).then((result) => {
                        if (result.isConfirmed) {
                            var url = "{{ route('invoices.updatebulk') }}";

                            const json = JSON.stringify({
                                    invoices : list_invoice,
                                    invoice_no : str_inv,
                                    payment_nom : $('#input_payment_nominal').val(),
                                }
                            );
                            const res = axios.post(url, json, {
                                headers: {
                                    // Overwrite Axios's automatically set Content-Type
                                    'Content-Type': 'application/json'
                                }
                                }).then(
                                    resp => {
                                        if(resp.data.status=="success"){
                                            Swal.fire({
                                                title: 'Success!',
                                                text: "Pembayaran gabungan berhasil",
                                                icon: 'success',
                                                showCancelButton: true,
                                                confirmButtonColor: '#3085d6',
                                                cancelButtonColor: '#d33', cancelButtonText: "Cetak Faktur Gabungan",
                                                confirmButtonText: "@lang('general.lbl_close') "
                                                }).then((result) => {

                                                    if (result.isConfirmed) {
                                                        window.location.href = "{{ route('invoices.index') }}"; 
                                                    }else{
                                                        burl ="{{ route('invoices.printbulk', 'WWWW') }}";
                                                        burl = burl.replace('WWWW', resp.data.data)
                                                        //window.location.href = burl; 
                                                        window.open(
                                                            burl,
                                                            '_blank' // <- This is what makes it open in a new window.
                                                        );
                                                        window.location.href = "{{ route('invoices.index') }}"; 
                                                    }
                                                })
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
                                            });
                                    }
                                });
                            }
                        });


                }
        });

    });
</script>
@endpush
