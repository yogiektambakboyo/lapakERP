@extends('layouts.default', ['appSidebarSearch' => true])
@section('title', 'Laporan - Trip Map')
@section('content')
    <div class="bg-light p-4 rounded">
        <h1>Laporan - Trip Map</h1>
        <div class="lead row mb-3">
            <div class="col-md-1">
                <div class="col-md-10"> 	
                        <button onclick="openDialog();" class="btn btn-sm btn-lime">@lang('general.btn_filter')</button> 
                </div>
            </div>
            <div class="col-md-11">
                <label id="" class="form-label-sm col-md-1">Cabang</label>
                <label id="label_cbg" class="form-label-sm col-md-2">-</label>
                <label id="" class="form-label-sm col-md-1">Tgl</label>
                <label id="label_tgl" class="form-label-sm col-md-2">-</label>
                <label id="" class="form-label-sm col-md-1">Seller</label>
                <label id="label_seller" class="form-label-sm col-md-3">-</label>
            </div>
        </div>
        
        <div class="row">
            <div class="col-md-5 overflow-auto"  style="height:400px;">
                <table class="table" id="table_m">
                    <thead>
                        <tr>
                            <th class="notexport">ID</th>
                            <th>#</th>
                            <th>Branch</th>
                            <th>Name</th>
                            <th>KM</th>
                            <th>Sum KM</th>
                            <th class="notexport">Act</th>
                        </tr>
                    </thead>
                    <tbody id="table_tb">
                    </tbody>
                </table>
            </div>
            <div class="col-md-7" id="map" style="height:400px;">
            </div>
        </div>
        
        <div class="modal fade" id="modal-filter" data-bs-backdrop="static" data-bs-keyboard="false" tabindex="-1" aria-labelledby="staticBackdropLabel" aria-hidden="true">
            <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                <h5 class="modal-title"  id="input_expired_list_at_lbl">@lang('general.lbl_filterdata')</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body">
                    <form action="{{ route('reports.trip_map.search') }}" method="GET">
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Tgl</label>
                        </div>
                        <div class="col-md-12">
                            <input type="text" class="form-control" name="filter_begin_date_in" id="filter_begin_date_in" value="">
                        </div>
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">@lang('general.lbl_branch')</label>
                            <input type="hidden" name="export" id="export" value="Export Excel">
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_branch_id_in" id="filter_branch_id_in">
                                <option value="%">-- All -- </option>
                                @foreach($branchs as $branchx)
                                    <option value="{{ $branchx->id }}">{{ $branchx->remark }} </option>
                                @endforeach
                            </select>
                        </div>
                        <div class="col-md-10">
                            <label class="form-label col-form-label col-md-4">Seller</label>
                        </div>
                        <div class="col-md-12">
                            <select class="form-control" 
                                name="filter_seller_id_in" id="filter_seller_id_in">
                                <option value="%">-- All -- </option>
                                @foreach($sellers as $seller)
                                    <option value="{{ $seller->id }}" data-bs="{{ $seller->branch_id }}">{{ $seller->name }} </option>
                                @endforeach
                            </select>
                        </div>

                        <br>
                        <div class="row d-flex justify-content-center">
                            <div class="col-md-4">
                                <button type="button"  data-bs-dismiss="modal" onclick="search()" class="btn btn-primary form-control">@lang('general.lbl_apply')</button>
                            </div>
                        </div>
                        
                    </form>
                </div>
            </div>
            </div>
        </div>

    </div>
@endsection
@push('scripts')
    <script>
        (g=>{var h,a,k,p="The Google Maps JavaScript API",c="google",l="importLibrary",q="__ib__",m=document,b=window;b=b[c]||(b[c]={});var d=b.maps||(b.maps={}),r=new Set,e=new URLSearchParams,u=()=>h||(h=new Promise(async(f,n)=>{await (a=m.createElement("script"));e.set("libraries",[...r]+"");for(k in g)e.set(k.replace(/[A-Z]/g,t=>"_"+t[0].toLowerCase()),g[k]);e.set("callback",c+".maps."+q);a.src=`https://maps.${c}apis.com/maps/api/js?`+e;d[q]=f;a.onerror=()=>h=n(Error(p+" could not load."));a.nonce=m.querySelector("script[nonce]")?.nonce||"";m.head.append(a)}));d[l]?console.warn(p+" only loads once. Ignoring:",g):d[l]=(f,...n)=>r.add(f)&&u().then(()=>d[l](f,...n))})({
        key: "AIzaSyA9W1-Eiw2i3-U1QXOGkw9JDKWa2fYgr0s",
        // Add other bootstrap parameters as needed, using camel case.
        // Use the 'v' parameter to indicate the version to load (alpha, beta, weekly, etc.)
        });
    </script>
    <script type="text/javascript">
            let map;
            let list_latlong;
            let flightPath;
            var marker, geo_position, last_geo_position;
            let list_seller = [];

            let table = new DataTable('#table_m', {
                dom: 'Bfrtip',
                buttons: [
                    {
                        extend: 'copy',
                        className: 'btn btn-default',
                        exportOptions: {
                            columns: ':not(.notexport)'
                        }
                    },
                    {
                        extend: 'csv',
                        className: 'btn btn-default',
                        exportOptions: {
                            columns: ':not(.notexport)'
                        }
                    },
                    {
                        extend: 'excel',
                        className: 'btn btn-default',
                        exportOptions: {
                            columns: ':not(.notexport)'
                        }
                    },
                    {
                        extend: 'pdf',
                        className: 'btn btn-default',
                        exportOptions: {
                            columns: ':not(.notexport)'
                        }
                    },
                    {
                        extend: 'print',
                        className: 'btn btn-default',
                        exportOptions: {
                            columns: ':not(.notexport)'
                        }
                    }
                ],
                columns: [
                        {  },
                        {  },
                        {  },
                        {  },
                        {  },
                        { },
                        {
                            data: null,
                            render: function ( data, type, row ) {
                                return '<button class="btn btn-sm btn-primary">Click</button>';
                            }
                        }
                ],
                columnDefs: [
                    {
                        target: 0,
                        visible: false,
                        searchable: false,
                    }
                ],
                order: [[1, 'asc']],
            });

            // initMap is now async
            async function initMap() {
                // The location of Uluru
                const positions = { lat: -7.132404363561107, lng: 112.42614335625827 };
                // Request needed libraries.
                //@ts-ignore
                const { Map } = await google.maps.importLibrary("maps");
                var infoWin = new google.maps.InfoWindow();
                const {spherical} = await google.maps.importLibrary("geometry");
               

                // The map, centered at Uluru
                map = new Map(document.getElementById("map"), {
                    zoom: 5,
                    center: positions,
                    mapId: "DEMO_MAP_ID",
                });

                var counter_name = 1,last_name = "";
                var distance = 0, sum_distance = 0;

                $('#table_m').find("tr:gt(0)").remove();
                table.clear().draw();

                for(let i=0;i<list_latlong.length;i++){
                    geo_position = { lat: parseFloat(list_latlong[i].latitude), lng: parseFloat(list_latlong[i].longitude) };

                    distance = 0; 
                    
                    if(last_name == list_latlong[i].name){
                        counter_name = counter_name + 1;
                        last_geo_position = { lat: parseFloat(list_latlong[i-1].latitude), lng: parseFloat(list_latlong[i-1].longitude) };

                        distance = google.maps.geometry.spherical.computeDistanceBetween(last_geo_position, geo_position);

                        sum_distance = sum_distance + distance;

                    }else{
                        sum_distance = 0;
                        counter_name = 1;
                        last_name = list_latlong[i].name;
                    }

                    //$('#table_m tr:last').after('<tr onclick="panTo(\''+(list_latlong[i].latitude+'\',\''+list_latlong[i].longitude)+'\',\''+Number((distance/1000).toFixed(2))+'\','+list_latlong[i].id+');"><td>'+(i+1)+'</td><td>'+(list_latlong[i].remark)+'</td><td>'+(list_latlong[i].name+' '+Array.from(list_latlong[i].name)[0]+''+counter_name)+'</td><td>'+Number((distance/1000).toFixed(2))+'</td><td>'+Number((sum_distance/1000).toFixed(2))+'</td><td><button class="btn btn-sm btn-primary">Click Me</button></td></tr>');
                    table.row.add([list_latlong[i].id,(i+1), (list_latlong[i].remark), (list_latlong[i].name+' '+Array.from(list_latlong[i].name)[0]+''+counter_name), Number((distance/1000).toFixed(2)), Number((sum_distance/1000).toFixed(2)),'']).draw(false);
                    
                    const marker = new google.maps.Marker({
                        position: geo_position,
                        map : map,
                        label: Array.from(list_latlong[i].name)[0]+''+counter_name,
                        title: list_latlong[i].name + ' ' + counter_name,
                    });

                    const content_msg = list_latlong[i].name+' #'+counter_name+' ('+list_latlong[i].remark+')'+'<br>'+list_latlong[i].georeverse+'<br>'+list_latlong[i].created_at;

                    const infowindow = new google.maps.InfoWindow({
                        content: content_msg,
                    });

                    marker.addListener("click", () => {
                        infowindow.open(marker.get("map"), marker);
                    });
                }

                table.on('click','tr',function() {
                    var id = table.row(this).data()[0] ;
                    var distance = table.row(this).data()[4];
                    var lat = 0; 
                    var long = 0;

                    for(let i=0;i<list_latlong.length;i++){
                        if(list_latlong[i].id == id){
                            lat = list_latlong[i].latitude;
                            long = list_latlong[i].longitude;
                        }
                    }
                    panTo(lat,long, distance, id);
                });

            }

            function search(){
                $('#label_cbg').text($('#filter_branch_id_in').find(':selected').text());
                $('#label_tgl').text($('#filter_begin_date_in').val());
                $('#label_seller').text($('#filter_seller_id_in').find(':selected').text());

                var url = "{{ route('reports.trip_map.search') }}";
                const res = axios.get(url,
                {
                    headers: {
                        'Content-Type': 'application/json'
                    },
                    params : {
                        filter_seller_id_in : $('#filter_seller_id_in').find(':selected').val() ,filter_branch_id_in : $('#filter_branch_id_in').find(':selected').val(), filter_begin_date_in : $('#filter_begin_date_in').val() , filter_end_date_in : ''
                    }
                }
                ).then(resp => {
                    if(resp.data.status == "success"){
                        list_latlong = resp.data.data;
                        initMap();
                    }
                });
            }

            $("#filter_seller_id_in option").each(function()
            {
                list_seller.push({
                    branch_id : $(this).attr('data-bs'),
                    id : $(this).val(),
                    seller_name : $(this).text(),
                });
            });

            $('#filter_branch_id_in').on('change', function(){
                $("#filter_seller_id_in option").each(function()
                {
                    $(this).show();
                });
                $selected_branch_id =  $('#filter_branch_id_in').find(':selected').val();
                $("#filter_seller_id_in option").each(function()
                {
                    if($selected_branch_id != '%' && $selected_branch_id != $(this).attr('data-bs') && $(this).val() != '%' ){
                        //$("#filter_seller_id_in option[value=" + title + "]").hide();
                        $(this).hide();
                    }
                });
                $("#filter_seller_id_in").val('%');
            });

            function panTo(lat,long, distance, id){
                map.setZoom(18);
                map.panTo(new google.maps.LatLng( parseFloat(lat), parseFloat(long)));
                map.setCenter(new google.maps.LatLng( parseFloat(lat), parseFloat(long)));

                if(parseFloat(distance)>0){
                    var geo_1 = { lat: parseFloat(lat), lng: parseFloat(long) };
                    var geo_2 = { lat: parseFloat(lat), lng: parseFloat(long) };

                    for(let i=0;i<list_latlong.length;i++){
                        if(list_latlong[i].id == id){
                            geo_2 = { lat: parseFloat(list_latlong[i-1].latitude), lng: parseFloat(list_latlong[i-1].longitude) };
                        }
                    }

                    const flightPlanCoordinates = [];
                    flightPlanCoordinates.push(geo_1);
                    flightPlanCoordinates.push(geo_2);

                    flightPath = new google.maps.Polyline({
                        path: flightPlanCoordinates,
                        geodesic: true,
                        strokeColor: "#FF0000",
                        strokeOpacity: 1.0,
                        strokeWeight: 2,
                    });

                    flightPath.setMap(map);
                }
            }

            search();

            const today = new Date();
            const yyyy = today.getFullYear();
            const yyyy1 = today.getFullYear()+1;
            let mm = today.getMonth() + 1; // Months start at 0!
            let dd = today.getDate();

            if (dd < 10) dd = '0' + dd;
            if (mm < 10) mm = '0' + mm;

            const formattedToday = yyyy + '-' + mm + '-' + dd;

            $('#filter_begin_date_in').datepicker({
                dateFormat : 'yy-mm-dd',
                todayHighlight: true,
            });
            $('#filter_begin_date_in').val(formattedToday);

            $('#filter_end_date_in').datepicker({
                format : 'yy-mm-dd',
                todayHighlight: true,
            });
            $('#filter_end_date_in').val(formattedToday);

            var myModal = new bootstrap.Modal(document.getElementById('modal-filter'));

            function openDialog(){
                myModal.show();
            }

            $('#label_cbg').text($('#filter_branch_id_in').find(':selected').text());
            $('#label_seller').text($('#filter_seller_id_in').find(':selected').text());
            $('#label_tgl').text(formattedToday);

        //$('#app').removeClass('app app-sidebar-fixed app-header-fixed-minified').addClass('app app-sidebar-fixed app-header-fixed-minified app-sidebar-minified');

    </script>
@endpush